# Come & Get It // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Come & Get It. For end-user documentation, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md).

## File Map

```
Come-and-Get-It/
├── .github/
│   └── workflows/
│       └── package.yml          CurseForge release and library vendoring
├── .gitattributes               Line-ending normalization
├── .gitignore                   Dev-clutter ignore list
├── .luacheckrc                  Lint config
├── .pkgmeta                     Externals and ignore list
├── ComeAndGetIt.toc             Load manifest
├── Data/
│   ├── Data.lua                 Locale init, constants, output-channel manifest, palette
│   └── Default-Settings.lua     AceDB defaults, profile scope only
├── Features/
│   ├── Core.lua                 Saved-variable lifecycle, event dispatcher, announce pipeline
│   ├── Utilities.lua            Color accessor
│   ├── Announcements.lua        Player prints and the announcement line builder
│   └── Diagnostics.lua          Report builders, event log, noise filter, taint control
├── Includes/
│   ├── Images/
│   │   └── Come-and-Get-It.tga  Add-on icon
│   └── Libraries/               Vendored, never edited by hand
├── Locales/
│   ├── enUS.lua                 Source of truth
│   └── {locale}.lua             Ten translations, owned by the Localization pass
├── Options/
│   ├── Options-Utilities.lua    Shared widget builders
│   ├── Options-General.lua      Root General panel
│   ├── Options-Profiles.lua     Stock AceDBOptions-3.0 table
│   ├── Options-Diagnostics.lua  Diagnostic Tools panel
│   └── Options.lua              Registration, panel opener, /cgi
├── LICENSE                      MIT
├── README.md                    End-user documentation
├── README-Technical.md          This document
└── README-Testing.md            Manual test plan
```

The repo is `Come-and-Get-It`; the installed folder, and therefore the Lua `ADDON_NAME`, is `ComeAndGetIt` (`.pkgmeta`'s `package-as`). The dotfiles and `LICENSE` are repo-only: the packager keeps them out of the player zip, so an installed copy never has them. Don't add them there.

There are no deprecated or dead files.

This is a single-feature add-on, so the feature's pipeline lives in `Features/Core.lua` rather than in its own `Features/` module, and there is no feature options panel. Despite its name, `Features/Announcements.lua` holds only the messaging helpers; the node-announce logic is `AnnounceNode` in `Core.lua`.

`Features/Diagnostics.lua` and `Options/Options-Diagnostics.lua` are the house diagnostics framework. Only their manifests are authored here (`ns.DIAGNOSTIC_API_CHECKS`, `ns.MESSAGE_ID_FILTERED_EVENTS`, `ns:BuildContextReport`, the SavedVariables table name). Keep the framework itself verbatim so it stays diffable against the other add-ons.

## Architecture

### Load Order

All files share one namespace table (`local ADDON_NAME, ns = ...`). The only globals are `ComeAndGetItDB`, which AceDB owns, and the `/cgi` registration (`SLASH_COMEANDGETIT1` plus its `SlashCmdList` entry). Both frames the add-on creates are unnamed file-locals, so neither reaches `_G`.

The TOC order is Includes, Locales, Data, Features, Options. Most code reaches through `ns` at call time and would not care, but four files resolve a dependency at file scope, which is what makes their position load-bearing:

- `Features/Core.lua` builds `SKILL_MAPPING` from `L["MATCH_*"]` and `OUTPUT_COMMAND` from `ns.OUTPUT_CHANNELS`, so it needs `Data/Data.lua`.
- `Features/Announcements.lua` aliases `ns.GetColor`, so it needs `Features/Utilities.lua`.
- `Options/Options-General.lua` aliases the widget builders and resolves the dropdown labels, so it needs `Options/Options-Utilities.lua` and `Data/Data.lua`.
- `Options/Options-Diagnostics.lua` aliases `ns.DiagnosticsStrings` and `ns.GetColor`, so it needs `Features/Diagnostics.lua` and `Features/Utilities.lua`.

`Data/Default-Settings.lua` reads `ns.DEFAULT_OUTPUT_CHANNEL` at file scope for the same reason, which is why it follows `Data/Data.lua`.

### Event Loop

`Features/Core.lua` creates one hidden frame and registers exactly the events in `ns.EVENT_NAMES`:

```lua
ns.EVENT_NAMES = {
	"PLAYER_LOGIN",
	"UI_ERROR_MESSAGE",
}
```

The `OnEvent` handler is the only dispatcher. It runs in this order:

1. **Diagnostics tap.** If `ns.diagnostics.logging` is true, `ns:LogEvent(event, ...)` records the event before anything else. One boolean check makes the tap free when logging is off.
2. **`PLAYER_LOGIN`.** `InitSavedVariables()`, then `ns.RegisterOptionsPanels()`, then `ns:PrintWelcome()`. The order matters: the Profiles panel is built from `ns.db`, and the welcome reads `ns.db.profile.showWelcome`.
3. **`UI_ERROR_MESSAGE`.** `CanAnnounce()` first, and only then `ns.MatchError(messageID, message)`. On a match, `AnnounceNode(mapping)`.

The suppression gates run before matching on purpose. `UI_ERROR_MESSAGE` fires for every "Out of range" and "Not enough rage" the client shows, hardest in combat, which is exactly when `CanAnnounce` is guaranteed to say no, and the matcher's slow path lowercases the message before scanning it. Gating first makes the discarded case cost no string work. There is no other throttle; the 5-second cooldown inside `CanAnnounce` is the debounce.

`ns.EVENT_NAMES` is exported so the Diagnostics registration check reads the same list and can never drift from it.

### Combat Lockdown

Two things refuse during combat, and neither defers:

- **The options opener.** `ns:OpenOptionsPanel` checks `InCombatLockdown()` before any routing, prints `L["CHAT_OPTIONS_IN_COMBAT"]`, and returns. Blizzard's Settings panel is protected in combat; without the gate the player gets an `ADDON_ACTION_BLOCKED` error naming the add-on. It never queues or retries, and the `/cgi` handler carries no second check that could drift from this one.
- **The announcement.** `CanAnnounce` returns false in combat, so the error is dropped before it is matched. The write step calls `ChatFrame_OpenChat`, which steals keyboard focus and breaks movement mid-fight. The announcement is dropped rather than queued because a callout replayed after the fight is stale, and the node re-fires its error on the next right-click anyway. There is no dirty flag and no `PLAYER_REGEN_ENABLED` handler, by design.

### Detect, Compose, Write

The announcement pipeline is the add-on's core flow, all in `Features/Core.lua`.

**Gate: `CanAnnounce()`.** `IsInInstance()`, then `InCombatLockdown()`, then the cooldown (`ns.ANNOUNCE_COOLDOWN`, 5 seconds). It has one call site, in the dispatcher.

**Detect: `ns.MatchError(messageID, message)`.** Two tables, one per kind of key:

- **Fast path, by error name.** A numeric `UI_ERROR_MESSAGE` index shifts between patches and between clients (Forever runs on the Retail engine, which numbers errors differently from Classic), so the matcher never keys on it. It resolves the index with `GetGameMessageInfo(messageID)` and looks the GlobalStrings name up in `ERROR_STRING_MAPPING`. Locked chests match here, through `ns.ERROR_STRING_LOCKED_CHEST = "ERR_ITEM_LOCKED"`.
- **Slow path, by skill name.** Herb and mine nodes fire the same error with a localized "Requires &lt;Skill&gt;" body. The error establishes only that a profession skill was missing, never which one, so the lowercased message is substring-scanned against `L["MATCH_HERB"]` and `L["MATCH_MINE"]`. A load-time `LOWER_MATCH` table keeps the hot path from re-lowercasing constants.

The two mappings are separate tables because both key kinds are strings; merged, the substring scan would also try `ERR_ITEM_LOCKED` against message text. Substring matching is an accepted tradeoff: the shared error cannot tell the two gather skills apart, word-boundary patterns break CJK locales, and the residual risk of a false match is bounded because the add-on never sends anything itself.

The scan is deliberately not gated behind the shared error's numeric ID (observed as `272` on one client). That would narrow the false-match surface, but because normal play only ever exercises the string path, a different number on another client would kill herb and mine detection silently. Revisit only with an `/etrace` capture of the gather error from every supported client.

`MatchError` is on the namespace rather than file-local because the Diagnostics noise filter must classify with this exact lookup.

**Compose: `AnnounceNode(mapping)`.** Each step bails silently on failure:

1. Map ID from `C_Map.GetBestMapForUnit("player")`.
2. Position from `C_Map.GetPlayerMapPosition`. A nil position bails, and so does an exact `0, 0`, which is what an area the map can't resolve reports.
3. Zone name from `C_Map.GetMapInfo`.
4. Node name from `GameTooltipTextLeft1:GetText()`, read only while `GameTooltip:IsShown()`. There is no fallback name; a generic "a node" callout is worse than none.
5. Bag-item suppression through `TooltipShowsItem()`. A lockbox in the player's bags fires the same locked error as a world chest, and world nodes are never items.
6. The line itself, from `ns:BuildAnnounceMessage(mapping.formatKey, ...)`.

**Write.** The add-on opens the chat edit box pre-filled with the configured channel command. It never sends:

```lua
ChatFrame_OpenChat(command .. " " .. announcement, ChatFrame1)
```

If `ChatEdit_GetActiveWindow()` reports the player is already typing, the write is skipped so a draft in progress is never clobbered. `lastAnnounceTime` is stamped only after a successful open, so a bailed attempt never starts the cooldown.

Just before the open, `AnnounceNode` measures `#announcement` in bytes against `ns.CHAT_MESSAGE_MAX_LENGTH` and prints `L["CHAT_TOO_LONG"]` on overflow. The draft still opens with the full text. The string is never trimmed, because a byte-wise cut would split a multi-byte character in ruRU, koKR, or the Chinese locales, and dropping the zone or coordinates would gut the message. The player edits it down, which the never-send design already assumes. The measurement covers `announcement` alone, because the client consumes the `command .. " "` prefix as a channel selector.

### Cross-Client APIs

The TOC declares Classic Era, WoW Forever, and TBC Anniversary. Every API the add-on depends on ships on all three, so each is called directly with no legacy fallback, and each has a row in `ns.DIAGNOSTIC_API_CHECKS` so a `[FAIL]` in that report is a real defect on that client. Two choices are worth knowing:

- **`GameTooltip:GetItem()`** backs the bag-lockbox check because `TooltipUtil` is not on every supported client.
- **`Settings.OpenToCategory`** is routed by the category ID captured from `AddToBlizOptions` at registration. Looking the category up by title returns nil wherever the Settings API exists, and the fallthrough to `AceConfigDialog:Open` floats the panel as a loose window. That failure shows on TBC Anniversary while Classic Era still looks fine, so it survives single-flavor testing.

`C_EventUtils.IsEventValid` is the one guarded call: the event check degrades to `n/a` when it is absent.

## Announcement Line

The line placed in the chat box is built in one place, `ns:BuildAnnounceMessage(formatKey, ...)` in `Features/Announcements.lua`, and it departs from the house sent-message format on purpose: no target marker, no add-on name, no ` // `. WoW Forever blocks raid-marker tokens in chat, and the line is a draft the player sends themselves, so it reads as the player talking. `Data/Data.lua` therefore defines no `ns.TARGET_MARKER`.

There are three bodies, one per trigger, selected by the matched mapping's `formatKey`. Each is the whole line, with four `%s` filled in this fixed order: node name, x, y, zone.

```lua
L["MSG_FORMAT_MINE"] = "Hey Miners! %s at %s, %s in %s."
```

> Hey Miners! Rich Thorium Vein at 25, 54 in Eastern Plaguelands.

Two rules about the bodies are load-bearing:

- **Placeholder order is coupled across every locale.** A translation may reorder the sentence but not the four `%s`, because the call site passes them positionally.
- **Nothing attaches to the node name.** The greeting closes on "!" so the name starts a fresh clause. The role and verb are baked into each sentence rather than passed as fragments, so no article or adjective ever has to agree with a name whose gender and number are unknown until runtime. German cannot choose between "ein" and "eine" for a name it has not seen yet. A translation that puts an article directly in front of `%s` reintroduces that bug.

`BuildAnnounceMessage` strips stray pipes from the result, which is safe because the bodies never carry item links, and returns nil on a missing key, which `AnnounceNode` treats as "say nothing."

## Output Channels

`ns.OUTPUT_CHANNELS` in `Data/Data.lua` is the single source of truth for where a draft can be addressed. Each row pairs a stable saved key with a slash command and a locale label key:

```lua
{ key = "channel1", command = "/1", labelKey = "OPTIONS_OUTPUT_CHANNEL1" },
```

Two lookups derive from it, so the list, its order, and the command mapping cannot drift: `Core.lua` builds `OUTPUT_COMMAND` (key to command) for the write step, and `Options-General.lua` builds the dropdown's `values` and `sorting`. Array order is dropdown order.

The chosen key is saved as `ns.db.profile.defaultOutput`. The saved value is the key, never the command or the label, so relabeling or re-pointing a channel does not strand anyone's setting. A saved key that no longer exists falls back to `ns.DEFAULT_OUTPUT_CHANNEL` at write time rather than erroring.

## Diagnostics

- **Opt-in and runtime-only.** `ns.diagnostics` is a plain namespace table, not a SavedVariable, so it starts off at every login. `ns:SetDiagnosticsEnabled(false)` also stops the event log and releases its buffer. Every gated section hides on that one condition, baked into the panel's local `SectionHeader` and `ReportOutput` builders.
- **Read-only.** Reports build only on a button press. The sole state any button writes is the `taintLog` CVar.
- **The event log cannot be flooded.** `UI_ERROR_MESSAGE` is a firehose that is only sometimes signal, so it is not excluded (`ns.DIAGNOSTIC_EVENT_EXCLUDE` stays empty). `ns.MESSAGE_ID_FILTERED_EVENTS` names the argument position of its message ID, and `ns:SuppressUncorrelatedMessage` classifies each firing at capture time with the live `ns.MatchError`. Correlated firings log in full, a firing with no ID logs verbatim, and everything else folds into a per-ID counter rendered as a summary at the end of the report, biggest first. Filtering at capture rather than at render is the point: the buffer holds 500 entries, and combat spam would otherwise evict the one line the report exists to carry.
- **The `GetNodeName` line.** On a match, the dispatcher logs a synthetic `GetNodeName(...)` entry carrying the tooltip read. A nil there is the signal that the tooltip read missed. It fires only after the gates pass, so it is absent for errors seen in combat or in an instance, while the `UI_ERROR_MESSAGE` entry itself is still recorded.
- **Detection Context** is this add-on's context probe. `ns:BuildContextReport` prints live values (the match strings, the two gates, the resolved map ID, position, and zone) because an existence check cannot prove the map chain returns something usable, and those values are what explain a "nothing happened" report.
- **Strings are not localized.** All panel text lives in `ns.DiagnosticsStrings` as plain English. The one localized value it reads is `L["ADDON_TITLE"]`.
- **No Validate Data section.** The add-on ships no static spell or item tables, so there is no `ns.DIAGNOSTIC_DATA_SOURCES`.

## Saved Variables

One SavedVariables table, `ComeAndGetItDB`, managed by AceDB-3.0. It holds the player's two settings (the welcome toggle and the default output channel key) plus AceDB's own profile bookkeeping. Nothing else is persisted.

**Come & Get It uses the Simple model.** Every setting lives in `ns.db.profile`, every character shares the one `"Default"` profile, and `ns.db.global` is unused. Reset Profile therefore clears everything, back to install defaults.

The database is created in `InitSavedVariables` (`Features/Core.lua`) on `PLAYER_LOGIN`:

```lua
ns.db = LibStub("AceDB-3.0"):New("ComeAndGetItDB", ns.DATABASE_DEFAULTS, true)
```

The third argument is the entire mechanical difference between the two house models: `true` puts every character on the shared profile. `ns.db.global` stays empty on purpose. `ResetProfile` never touches that scope, so a setting parked there would survive a reset and the Profiles panel would silently fail to restore it. New settings go in `profile`.

Right after creation, `ns:ApplyProfile` is registered against `OnProfileChanged`, `OnProfileReset`, and `OnProfileCopied`. The add-on applies nothing imperatively (no frames, no events registered off a toggle, no mini-map button), so `ApplyProfile` does one thing: `NotifyChange` on each `ns.OPTIONS_REGISTRY` name, so an open panel redraws instead of showing pre-reset values until a `/reload`.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed, and explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*`/`**` wildcard defaults resolve through metatables.

There are no default item or spell lists, so there is no refill-on-empty logic. There is no migration chain.

## Adding a New Node Type

1. **Identify the trigger** with `/etrace`. If the client fires an error unique to that node type, add its GlobalStrings name as a constant in `Data/Data.lua`, beside `ns.ERROR_STRING_LOCKED_CHEST`. Never key on the numeric index. If it fires only the shared "Requires &lt;Skill&gt;" error, match the localized skill name instead.
2. **Add a mapping entry** in `Features/Core.lua`: in `ERROR_STRING_MAPPING` keyed by the error name, or in `SKILL_MAPPING` keyed by `L["MATCH_*"]`. Either way the entry carries one `formatKey` naming its `MSG_FORMAT_*` body. Keep the two tables separate.
3. **Add the locale keys** to `Locales/enUS.lua`: the new `MSG_FORMAT_*` body, and the `MATCH_*` skill name if you matched by substring. Write the body with four `%s` in the fixed order and nothing attached to the first. The Localization pass translates the rest.
4. **Check the length.** The composed line is a chat message, so the ceiling is 255 bytes (see Localization).

## Adding a New Output Channel

1. Add one row to `ns.OUTPUT_CHANNELS` in `Data/Data.lua`. The `key` is saved to the database, so pick it once and never rename it.
2. Add its `OPTIONS_OUTPUT_*` label to `Locales/enUS.lua`.

`Core.lua` and the dropdown pick the row up on their own.

## Adding a New Setting

1. Add the default under `profile` in `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`). Never under `global`.
2. Add a widget to `ns.BuildGeneralOptions()` in `Options/Options-General.lua` whose `get` and `set` use `ns.db.profile.<key>`. Guard the `get` with `ns.db and ...`. The control carries a label and one `desc`; the `desc` is its tooltip and its whole explanation.
3. Add the `L` keys to `Locales/enUS.lua`, spelled out: `OPTIONS_<FEATURE>_NAME` and `OPTIONS_<FEATURE>_DESCRIPTION`.

Removing a setting is not the reverse of this. AceDB only manages keys that are in the defaults table, so a key deleted from the defaults sits in every existing save file forever. Pair the removal with an explicit cleanup that nils the key across `ns.db.profiles`. Any change to the shape, name, or scope of saved data ships with a migration tagged `-- MIGRATION (remove after YYYY-MM-DD)`, dated 30 days past its release.

## Adding a Registered Event

Append the name to `ns.EVENT_NAMES` in `Features/Core.lua` and handle it in the `OnEvent` dispatcher, so the dispatcher and Diagnostics pick it up together. If the new event is a firehose that is never signal, add it to `ns.DIAGNOSTIC_EVENT_EXCLUDE`. If it is sometimes signal and carries a message ID, give it a row in `ns.MESSAGE_ID_FILTERED_EVENTS` instead.

## Adding a Diagnostic Report

1. Add a `ns:BuildXxxReport()` builder in `Features/Diagnostics.lua` that returns a string and opens with `GetClientHeader()`. Read-only, no side effects.
2. Add its title and button text to `ns.DiagnosticsStrings` as plain English.
3. In `Options/Options-Diagnostics.lua`, add a `SectionHeader`, an `execute` that stores the result on `ns.diagnostics` and calls `Refresh()`, and a `ReportOutput` for that field.

A new API dependency anywhere in the add-on also gets a row in `ns.DIAGNOSTIC_API_CHECKS`.

## Localization

- **`enUS.lua` is the source of truth** and the only file that passes the `true` default-fallback flag to `NewLocale`. Every other locale translates its key set, and the Localization pass (`3 - Copy Cleanup & Localization Prompt.md`) owns those files. Never hand-edit them during ordinary work. When you add or rename a key, change `enUS.lua` and every code reference together, and never reuse a retired key name: a stale translation under that name would win over the new English.
- **Placeholders.** `%s`/`%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime. The `MSG_FORMAT_*` bodies (four `%s`) are the critical case, and an in-file comment block documents their order for translators. `CHAT_TOO_LONG`'s two `%d` are the silent case: swapping them does not crash, it reports the numbers backwards.
- **Keys reached indirectly.** Eight keys never appear as `L["KEY"]` in code. The three `MSG_FORMAT_*` bodies resolve through `mapping.formatKey`, and the five `OPTIONS_OUTPUT_*` labels through `channel.labelKey`. A search for `L["` reports all eight as unused. They are not.
- **`MATCH_*` is not display copy.** The two skill names must equal what the client itself prints in that language, because they are substring-matched against the client's error text. A stylized translation silently stops herb and mine detection in that locale while chests keep working.
- **Speaker voice.** The bodies are spoken as the player, so a language with gendered verb agreement must phrase them to read correctly for any character. The current bodies carry no first-person verb; check this whenever one is rewritten.
- **Output ceiling.** The composed line is a chat message: 255 bytes, measured in bytes. The overflow canary is the widest-encoding locale, which here is koKR, followed by zhTW and ruRU, not German. With a 42-byte node name and a 44-byte zone, the longest koKR line is about 132 bytes against 117 for enUS, so there is headroom, but re-measure those locales whenever a body grows. The runtime warning in `AnnounceNode` is a backstop for the tail, not a substitute: it fires after the line has already overflowed, and only the player sees it.

## Common Pitfalls

- **Queueing the announcement for after combat**: `ChatFrame_OpenChat` steals keyboard focus, so `CanAnnounce` drops the announcement in combat. A replay queue would open a stale callout in the player's face as the fight ends. Keep the drop.
- **Keying herb or mine on the error ID**: both node types share one error, so keying on it announces every vein as an herb, and the number is not stable across clients anyway. The skill-name scan is the only thing that separates them.
- **Merging the two mapping tables**: both are string-keyed. Merged, the substring scan would test `ERR_ITEM_LOCKED` against message text. `ERROR_STRING_MAPPING` and `SKILL_MAPPING` stay separate.
- **Making `ns.MatchError` file-local again**: the Diagnostics noise filter calls it. Localize it and starting the event log raises a Lua error on the next red error message.
- **Trusting a nil check to catch a bad map position**: `C_Map.GetPlayerMapPosition` returns a valid vector reading exactly `0, 0` where the map cannot resolve the player. `AnnounceNode` guards both; drop the second guard and drafts point at the map origin.
- **Stale tooltip text**: the client does not clear `GameTooltipTextLeft1` when the tooltip hides, so the font string keeps returning the last thing hovered. `GetNodeName` reads it only while `GameTooltip:IsShown()`. Without that check, an error arriving with nothing hovered drafts the previous node's name, or a creature's, against the current coordinates. `TooltipShowsItem` does not cover this; it catches item tooltips only.
- **Bag lockboxes**: a locked lockbox in the bags fires the same `ERR_ITEM_LOCKED` as a world chest. `TooltipShowsItem` suppresses it; remove that gate and inventory items get called out with world coordinates.
- **Adding a raid marker or the add-on name to the line**: WoW Forever blocks `{rtN}` tokens in chat, and the plain line is a recorded exception to the house format. Keep `BuildAnnounceMessage` and every `MSG_FORMAT_*` body bare.
- **Trimming an over-long draft**: a byte-wise cut splits multi-byte characters. `AnnounceNode` warns and leaves the text whole.
- **Measuring the draft with the channel command attached**: the client strips `/1 ` before sending. Measure `announcement` alone, in bytes.
- **Putting a setting in `ns.db.global`**: Reset Profile never touches that scope, so the setting survives a reset and the Profiles panel lies. Everything goes in `profile`.
- **Deleting a setting without a cleanup**: AceDB only manages keys present in the defaults, so a removed key persists in every save file as ordinary user data. Nil it across `ns.db.profiles` in the same change.
- **Renaming an output channel key**: the key is what is saved. A renamed key silently sends existing players back to the default channel.
- **Registering options panels at file scope**: the Profiles panel is built from `ns.db`, which does not exist until `PLAYER_LOGIN`. `ns.RegisterOptionsPanels()` is called from Core right after `AceDB:New`.
- **Opening the options by category title**: returns nil wherever the Settings API exists and floats the panel loose. `ns:OpenOptionsPanel` routes by the captured category ID.
- **Registering an event outside `ns.EVENT_NAMES`**: the Diagnostics registration check and the event log silently miss it.
- **Putting diagnostics text in `Locales/`**: it is English-only by design and lives in `ns.DiagnosticsStrings`.

## Contributing

- **Issues**: open them on the [GitHub Issues tab](https://github.com/Gogo1951/Come-and-Get-It/issues).
- **Bug reports**: include game version and locale, class and level, repro steps, and the relevant chat output. The drafted line itself, or a Detection Context report from Diagnostic Tools, is ideal.
- **Discord**: [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **Pull requests**:
  - Keep each PR scoped to one change, and match the surrounding style: vararg namespace modules, dashed section dividers, and comments reserved for what the code cannot say for itself.
  - Run StyLua with its default configuration (the repo ships no `.stylua.toml`), then `luac -p` and a clean `luacheck .`.
  - Respect the single-source tables: `ns.EVENT_NAMES`, `ns.OUTPUT_CHANNELS`, `ns.PALETTE`, `ns.DiagnosticsStrings`, and the two mapping tables in `Core.lua`.
  - If you change a `MSG_FORMAT_*` body, confirm the longest composed line stays within the 255-byte chat limit, measured in bytes against koKR, zhTW, and ruRU rather than English, and keep the four `%s` in order.
  - Migration discipline: settings go under `profile`, a removed setting gets a cleanup, and any reshape of saved data ships a dated migration rather than rewriting or dropping what players already have.
  - Update this document if the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X" or "I fixed Y." Frame the change in terms of who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player who got pulled into combat the instant I clicked a vein, I wanted Come & Get It to stay silent during a fight so that the chat box wouldn't steal my movement keys. This change drops the announcement when `InCombatLockdown()` is true rather than queuing it for later.*
