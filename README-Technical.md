# Come & Get It // Technical Reference

This document combines architecture notes and contribution guidance for developers working on Come & Get It. For end-user documentation, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md).

## File Map

```
Come-and-Get-It/
├── .github/
│   └── workflows/
│       └── package.yml          CurseForge and Wago release plus library vendoring
├── .gitattributes               Line-ending normalization
├── .gitignore                   Dev-clutter ignore list
├── .luacheckrc                  Lint config
├── .pkgmeta                     Externals and the packager ignore list
├── ComeAndGetIt_Vanilla.toc     Classic Era
├── ComeAndGetIt_TBC.toc         TBC Anniversary
├── ComeAndGetIt_Camelot.toc     WoW Forever
├── ComeAndGetIt_Mists.toc       MoP Classic
├── ComeAndGetIt_Mainline.toc    Retail
├── Data/
│   ├── Flavor.lua               Flavor identity, the canonical file copied byte for byte
│   ├── Data.lua                 Locale init, constants, output-channel manifest, palette
│   └── Default-Settings.lua     AceDB defaults, profile scope only
├── Features/
│   ├── Core.lua                 Version, dispatcher, AceDB init, the callout pipeline
│   ├── Utilities.lua            Color accessor
│   ├── Announcements.lua        Player prints and the callout line builder
│   └── Diagnostics.lua          Report builders, event log and its noise filter, taint log
├── Includes/
│   ├── Images/
│   │   └── Come-and-Get-It.tga  Add-on icon
│   └── Libraries/               Vendored Ace3 stack, never edited by hand
├── Locales/
│   ├── enUS.lua                 Source strings
│   └── deDE.lua … zhTW.lua      Ten translations
├── Options/
│   ├── Options-Utilities.lua    Shared widget builders
│   ├── Options-General.lua      Root General panel
│   ├── Options-Profiles.lua     Stock AceDBOptions-3.0 table
│   ├── Options-Diagnostics.lua  Diagnostic Tools panel
│   └── Options.lua              Registration, the options opener, /cgi
├── LICENSE                      MIT
├── README.md                    End-user documentation
├── README-Notes.md              The maintainer's settled exceptions and decisions
├── README-Technical.md          This document
└── README-Testing.md            Manual test plan
```

`.github/`, `.gitattributes`, `.gitignore`, `.luacheckrc`, `.pkgmeta` and `LICENSE` are repo-only: `.pkgmeta`'s ignore list strips them from the release zip, so a copy installed from CurseForge or Wago has none of them. `Includes/Libraries/` is rewritten from `.pkgmeta`'s externals by the release workflow on every tag, so a hand edit there is lost at the next release. The repo is `Come-and-Get-It`; the installed folder, and therefore the Lua `ADDON_NAME` and the AceLocale identity every `NewLocale` call spells out, is `ComeAndGetIt` (`.pkgmeta`'s `package-as`). "Come & Get It" is display text only, `L["ADDON_TITLE"]`.

**One TOC per flavor, identical except for `## Interface` and `## X-Flavor`.** Classic Era (with Season of Discovery riding the Vanilla TOC), TBC Anniversary and WoW Forever are the current targets. The MoP Classic and Retail TOCs are a recorded decision (README-Notes): they match Tracking Eye's clients, so a player there who finds Come & Get It still gets pointed to Tracking Eye (see *End of Support Notice*). The add-on ships no static game data, so there are no `Data/{Game}/` flavor folders and every TOC lists the same files. The one file that must stay gone is an unsuffixed `ComeAndGetIt.toc`: a client with no TOC of its own suffix falls back to it and loads the add-on, under whatever `X-Flavor` it names, on a client Come & Get It does not target.

Files are listed in TOC load order, and that order is load-bearing, because most files capture something from an earlier one while they load. Every `ns.L` read needs `Data/Data.lua`, which resolves it from the locales registered above it. `Features/Utilities.lua` builds its color table from `ns.PALETTE`, and every file aliasing `ns.GetColor` needs Utilities. `Options/Options-General.lua` aliases the widget builders from `Options/Options-Utilities.lua`, and `Options/Options-Diagnostics.lua` aliases `ns.DiagnosticsStrings` from `Features/Diagnostics.lua`. `Features/Core.lua` builds its mapping tables from the `MATCH_*` strings and `OUTPUT_COMMAND` from `ns.OUTPUT_CHANNELS` as it loads, `Options/Options-General.lua` builds the dropdown's values the same way, and `Data/Default-Settings.lua` reads `ns.DEFAULT_OUTPUT_CHANNEL`. A file moved above what it reads captures nil and breaks, at load or on first use. Core also runs the other way: it loads before Announcements, Diagnostics and the options registration yet calls into all three, which is safe only because each of those calls runs from an event, after the whole TOC has loaded.

This is a single-feature add-on, so the callout pipeline lives in `Features/Core.lua` rather than in its own `Features/` module (Style Guide → FILE STRUCTURE), and there is no feature options panel. `Features/Announcements.lua` holds only the messaging helpers; the node logic is `AnnounceNode` in Core.

`Features/Diagnostics.lua` and `Options/Options-Diagnostics.lua` are the house Diagnostic Tools framework (Style Guide → DIAGNOSTIC TOOLS), kept verbatim. This add-on authors the manifests the framework reads (`ns.DIAGNOSTIC_API_CHECKS`, `ns.MESSAGE_ID_FILTERED_EVENTS`), the Detection Context probe (`ns:BuildContextReport`) and the SavedVariables table name its dump reads; see *Diagnostics*.

## Architecture

### Event Loop

`Features/Core.lua` creates one unnamed frame and registers every event in `ns.EVENT_NAMES`, which holds exactly two: `PLAYER_LOGIN` and `UI_ERROR_MESSAGE`. Its `OnEvent` script is the only dispatcher, and it runs in this order:

1. **Diagnostics tap.** If `ns.diagnostics.logging` is on, `ns:LogEvent(event, ...)` records the event before anything else. The one boolean check makes the tap free while logging is off.
2. **`PLAYER_LOGIN`.** `InitSavedVariables()`, then `ns.RegisterOptionsPanels()`, then `ns:PrintWelcome()`, then `ns:PrintEndOfSupport()`. The order matters: the Profiles panel is built from `ns.db`, and the welcome reads `ns.db.profile.showWelcome`.
3. **`UI_ERROR_MESSAGE`.** `CanAnnounce()` first, and only then `ns.MatchError(messageID, message)`. On a match, `AnnounceNode(mapping)`.

The gate runs before the matcher on purpose. `UI_ERROR_MESSAGE` fires for every "Out of range" and "Not enough rage" the client shows, hardest in combat, which is exactly when `CanAnnounce` is guaranteed to say no, and the matcher's slow path lowercases the message before scanning it. Gating first makes the discarded case cost no string work. There is no other throttle: the 5-second cooldown inside `CanAnnounce` (`ns.ANNOUNCE_COOLDOWN`) is the debounce.

`ns.EVENT_NAMES` is exported so the Diagnostics Event Registration check reads the same list and can never drift from it.

### Combat Lockdown

Two things refuse during combat, and neither defers:

- **The options opener.** `ns:OpenOptionsPanel` checks `InCombatLockdown()` before any routing, prints `L["CHAT_OPTIONS_IN_COMBAT"]`, and returns. Blizzard's Settings panel is protected in combat; without the gate the player gets an `ADDON_ACTION_BLOCKED` error naming the add-on. It never queues or retries, and the `/cgi` handler carries no second check that could drift from this one.
- **The callout.** `CanAnnounce` returns false in combat, so the error is dropped before it is matched. The write step calls `ChatFrameUtil.OpenChat`, which takes keyboard focus and breaks movement mid-fight. The callout is dropped rather than queued because one replayed after the fight is stale, and the node raises its error again on the next right-click anyway. There is no dirty flag and no `PLAYER_REGEN_ENABLED` handler, by design.

### Detect, Compose, Write

The callout pipeline is the add-on's core flow, all in `Features/Core.lua`.

**Gate: `CanAnnounce()`.** `IsInInstance()`, then `InCombatLockdown()`, then the cooldown. It has one call site, in the dispatcher.

**Detect: `ns.MatchError(messageID, message)`.** Two tables, one per kind of key:

- **Fast path, by error name.** A numeric `UI_ERROR_MESSAGE` index shifts between patches and between clients (WoW Forever runs the Retail engine, which numbers errors differently from Classic), so the matcher never keys on it. It resolves the index with `GetGameMessageInfo(messageID)` and looks the GlobalStrings name up in `ERROR_STRING_MAPPING`. Locked chests match here, through `ns.ERROR_STRING_LOCKED_CHEST` (`"ERR_ITEM_LOCKED"`).
- **Slow path, by skill name.** Herb and mine nodes raise one shared error whose body reads `Requires <Skill>` in the client's language. The error says only that a profession was missing, never which one, so the lowercased message is substring-scanned for the names in `L["MATCH_HERB"]` and `L["MATCH_MINE"]`. One `MATCH_*` string can hold several names separated by semicolons, for a language whose clients don't all name the skill the same way. `LOWER_MATCH`, built once at load, holds each name lowercased, so the hot path never re-lowers constants.

The two mappings are separate tables because both key kinds are strings: merged, the substring scan would also try `ERR_ITEM_LOCKED` against message text. Substring matching is an accepted tradeoff. The shared error can't tell the two skills apart, word-boundary patterns break CJK locales, and a false match is bounded because the add-on never sends anything itself.

The skill scan is deliberately not gated behind the shared error's numeric ID. That would narrow the false-match surface, but normal play only ever exercises the string path, so a different number on another client would kill herb and mine detection there without anyone noticing. Gating it needs the gather error's ID captured with `/etrace` on every supported client first.

`MatchError` lives on the namespace rather than file-local because the Diagnostics noise filter must classify with this exact lookup.

**Compose: `AnnounceNode(mapping)`.** Each step bails silently on failure:

1. Map ID from `C_Map.GetBestMapForUnit("player")`.
2. Position from `C_Map.GetPlayerMapPosition`. A nil position bails, and so does an exact `0, 0`, which is what an area the map can't resolve reports.
3. Zone name from `C_Map.GetMapInfo`.
4. Node name from `GameTooltipTextLeft1:GetText()`, read only while `GameTooltip:IsShown()`. There is no fallback name; a generic "a node" callout is worse than none.
5. Bag-item suppression through `TooltipShowsItem()`. A lockbox in the player's bags raises the same locked error as a world chest, and world nodes are never items.
6. The line itself, from `ns:BuildAnnounceMessage(mapping.formatKey, ...)`, with the coordinates rounded to whole numbers.

**Write.** The add-on opens the chat edit box pre-filled with the configured channel's command and the line. It never sends:

```lua
ChatFrameUtil.OpenChat(command .. " " .. announcement, ChatFrame1)
```

If `ChatFrameUtil.GetActiveWindow()` reports that the player is already typing, the write is skipped, so a draft in progress is never clobbered. `lastAnnounceTime` is stamped only once the draft opens, so an attempt that bailed never starts the cooldown.

Just before the open, `AnnounceNode` measures `#announcement` in bytes against `ns.CHAT_MESSAGE_MAX_LENGTH` and prints `L["CHAT_TOO_LONG"]` on overflow. The draft still opens with the full text. The string is never trimmed, because a byte-wise cut would split a multi-byte character in ruRU, koKR or the Chinese locales, and dropping the zone or the coordinates would gut the message. The player edits it down, which the never-send design already assumes. The measurement covers `announcement` alone, because the client consumes the `command .. " "` prefix as a channel selector.

### Flavors and Client APIs

Each client loads the TOC carrying its own suffix, and `Data/Flavor.lua` reads that TOC's `X-Flavor` into `ns.FLAVOR` (Style Guide → COMPATIBILITY). Nothing reads it except the Diagnostic Tools report header: the add-on has no flavor gates and no flavor data, so every client runs the same code.

Apart from the two guarded calls below, every API is called directly, with no legacy fallback, and each one the callout, the options opener or Diagnostic Tools relies on has a row in `ns.DIAGNOSTIC_API_CHECKS`. There is no plan B, so a `[FAIL]` in that report is a real defect on the client that printed it. The two guarded calls are `C_EventUtils.IsEventValid`, whose Event Registration column reads `n/a` without it, and `Settings.OpenToCategory` in the options opener. Two choices are worth knowing:

- **`GameTooltip:GetItem()`** backs the bag-lockbox check because `TooltipUtil` is not on every supported client.
- **`Settings.OpenToCategory`** takes the category ID captured from `AddToBlizOptions` at registration, never the panel's title. The vendored AceConfigDialog aliases a category's ID to its title only on clients lacking `C_SettingsUtil.OpenSettingsPanel`; everywhere else the ID is a number assigned at registration, a title lookup finds nothing, and the fallthrough to `AceConfigDialog:Open` floats the panel as a loose window. That failure shows on TBC Anniversary while Classic Era still looks fine, so it survives single-flavor testing.

## Announcement Line

The line placed in the chat box is built in one place, `ns:BuildAnnounceMessage(formatKey, ...)` in `Features/Announcements.lua`, and it is the bare locale body: no target marker, no add-on name, no ` // `. That is the house rule for a line drafted into the player's own chat box, which is the player's words rather than the add-on's (Style Guide → MESSAGES → Target Marker), and WoW Forever blocks raid-marker tokens in chat anyway. `Data/Data.lua` therefore defines no `ns.TARGET_MARKER`.

There are three bodies, one per trigger, picked by the matched mapping's `formatKey`. Each is the whole line, with four `%s` filled in this fixed order: node name, x, y, zone.

```lua
L["MSG_FORMAT_MINE"] = "Hey Miners! %s at %s, %s in %s."
```

> Hey Miners! Rich Thorium Vein at 25, 54 in Eastern Plaguelands.

Two rules about the bodies are load-bearing:

- **Placeholder order is fixed in every locale.** A translation may reorder the sentence around the four `%s`, but not the `%s` themselves, because the call site passes them positionally.
- **Nothing attaches to the node name.** The greeting closes on "!" so the name starts a fresh clause. The role and verb are baked into each sentence rather than passed in as fragments, so no article or adjective ever has to agree with a name whose gender and number are unknown until runtime: German can't choose between "ein" and "eine" for a name it hasn't seen yet. A translation that puts an article directly in front of `%s` brings that bug back.

`BuildAnnounceMessage` strips stray pipes from the result, which is safe because the bodies never carry item links. A `formatKey` with no locale entry does not come back nil: AceLocale reports the missing entry as a Lua error and returns the key's own name, so the draft would read `MSG_FORMAT_...`. Every mapping's body has to exist in `enUS.lua`.

**Output ceiling.** The line is a chat message, so the ceiling is 255 bytes (Style Guide → MESSAGES → Message Length). Most of it arrives from the client in its own language: the node name off the tooltip and the zone off the map. Cyrillic takes two bytes a letter and Russian names run long, so ruRU is the locale to overflow-test a whole line against. The bodies' own text is widest in koKR (42 bytes of fixed text in its longest body, against 27 in enUS), then zhTW and ruRU, so re-measure those three whenever a body grows. The `CHAT_TOO_LONG` warning is a backstop, not a check: it fires after the line has already overflowed, and only the player sees it.

## Output Channels

`ns.OUTPUT_CHANNELS` in `Data/Data.lua` is the single source of truth for where a draft can be addressed. Each row pairs a stable saved key with a slash command and a locale label key:

```lua
{ key = "channel1", command = "/1", labelKey = "OPTIONS_OUTPUT_CHANNEL1" },
```

Two lookups derive from it at load, so the list, its order and the command mapping cannot drift: `Features/Core.lua` builds `OUTPUT_COMMAND` (key to command) for the write step, and `Options/Options-General.lua` builds the dropdown's `values` and `sorting`. Array order is dropdown order, and `sorting` is what keeps it; without it the dropdown sorts by saved key.

The chosen key is saved as `ns.db.profile.defaultOutput`. The saved value is the key, never the command or the label, so relabeling or re-pointing a channel strands nobody's setting. A saved key that no longer exists falls back to `ns.DEFAULT_OUTPUT_CHANNEL` at write time rather than erroring.

## End of Support Notice

`ns:PrintEndOfSupport()` in `Features/Announcements.lua` prints `L["CHAT_END_OF_SUPPORT"]` through `ns:PrintMessage` at every login, straight after the welcome. It has no setting and never reads `showWelcome`, so it shows even for a player who turned the welcome message off. That is a recorded decision (README-Notes): every player should learn that Come & Get It now lives on inside Tracking Eye. The MoP Classic and Retail TOCs carry the notice to Tracking Eye's other clients for the same reason.

## Diagnostics

- **Opt-in and runtime-only.** `ns.diagnostics` is a plain namespace table, not a SavedVariable, so it starts off at every login. `ns:SetDiagnosticsEnabled(false)` also stops the event log and releases its buffer. Every gated section hides on that one condition, baked into the panel's local `SectionHeader` and `ReportOutput` builders; the buttons and hint lines carry the same `Hidden` predicate themselves.
- **Read-only.** Reports build only on a button press, and each opens with the same client header: add-on version, client, build, TOC, locale, flavor and data folder. The sole state any button writes is the `taintLog` CVar.
- **The event log can't be flooded.** `UI_ERROR_MESSAGE` is a firehose that is only sometimes signal, so it is not excluded (`ns.DIAGNOSTIC_EVENT_EXCLUDE` stays empty). `ns.MESSAGE_ID_FILTERED_EVENTS` names the argument position of its message ID, and `ns:SuppressUncorrelatedMessage` classifies each firing at capture time with the live `ns.MatchError`. Correlated firings log in full, a firing with no ID logs verbatim, and everything else folds into a per-ID counter rendered as a summary at the end of the report, biggest first. Filtering at capture rather than at render is the point: the buffer holds 500 entries, and combat spam would otherwise evict the one line the report exists to carry.
- **The `GetNodeName` line.** On a match, the dispatcher logs a synthetic `GetNodeName(...)` entry carrying the tooltip read. A nil there is the signal that the tooltip read missed. It is logged only after the gate passes, so it is absent for errors seen in combat, in an instance or inside the cooldown, while the `UI_ERROR_MESSAGE` entry itself is still recorded.
- **Detection Context** is this add-on's context probe. `ns:BuildContextReport` prints live values (the locked-chest error name, both `MATCH_*` strings, the instance and combat gates, and the resolved map ID, position and zone), because an existence check can't prove the map chain returns something usable, and those values are what explain a "nothing happened" report.
- **API rows track the code.** A new API dependency anywhere in the add-on gets a row in `ns.DIAGNOSTIC_API_CHECKS`, as an existence or shape check only.
- **Strings are not localized.** All panel text lives in `ns.DiagnosticsStrings` as plain English. The localized values it reads are `L["ADDON_TITLE"]` for the header and the two `MATCH_*` strings Detection Context prints as data.
- **No Validate Data section.** The add-on ships no static game data, so there is no `ns.DIAGNOSTIC_DATA_SOURCES`. There is no offline test suite either; `README-Testing.md` is the manual plan.

## Saved Variables

One SavedVariables table, `ComeAndGetItDB`, managed by AceDB-3.0 and created in `InitSavedVariables` (`Features/Core.lua`) on `PLAYER_LOGIN`. It holds the player's settings, the welcome toggle and the Default Output channel key, plus AceDB's own profile bookkeeping.

**Come & Get It uses the Simple model** (Style Guide → SAVED VARIABLES → The Two Models), because nothing it stores differs from character to character. Every setting lives in `ns.db.profile`, every character shares the one `"Default"` profile, and `ns.db.global` is unused. **Reset Profile therefore clears everything, back to install defaults.**

```lua
ns.db = LibStub("AceDB-3.0"):New("ComeAndGetItDB", ns.DATABASE_DEFAULTS, true)
```

The third argument is the whole mechanical difference between the two house models: `true` puts every character on the shared profile. New settings go in `profile`. Under this model `global` is only for reset-proof state, what a profile reset must not take from the player, and the add-on keeps none; a setting parked there would survive Reset Profile, and the Profiles panel would silently fail to restore it.

Right after creation, `ns:ApplyProfile` is registered for `OnProfileChanged`, `OnProfileReset` and `OnProfileCopied`. The add-on applies nothing imperatively (no frames, no events registered off a toggle, no mini-map button), so `ApplyProfile` does one thing: `NotifyChange` on each `ns.OPTIONS_REGISTRY` name, so an open panel redraws instead of showing pre-reset values until a `/reload`.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied by AceDB-3.0 when a scope is first accessed, and explicit user values, including `false`, are never overridden. Note that scalar and table defaults are physically copied into the saved table (`copyDefaults` via `rawset`); only `*`/`**` wildcard defaults resolve through metatables.

There are no default item or spell lists, so there is no seeding or refill-on-empty logic. There is no migration chain: the add-on carries no migration code.

## Adding a New Node Type

1. **Identify the trigger** with `/etrace`. If the client raises an error unique to that node type, add its GlobalStrings name as a constant in `Data/Data.lua`, beside `ns.ERROR_STRING_LOCKED_CHEST`; never key on the numeric index. If it raises only the shared `Requires <Skill>` error, match the localized skill name instead.
2. **Add a mapping entry** in `Features/Core.lua`: in `ERROR_STRING_MAPPING` keyed by the error name, or in `SKILL_MAPPING` keyed by a new `L["MATCH_*"]`. Either way the entry carries one `formatKey` naming its `MSG_FORMAT_*` body. Keep the two tables separate.
3. **Add the locale keys** to `Locales/enUS.lua`: the new `MSG_FORMAT_*` body, and the `MATCH_*` skill name if you matched by substring. Write the body with four `%s` in the fixed order and nothing attached to the first. The Localization pass translates the rest.
4. **Extend Detection Context.** `ns:BuildContextReport` prints every match constant and string, so the new one gets a line there too.
5. **Check the length.** The composed line is a chat message: 255 bytes, measured in bytes against ruRU (see *Announcement Line*).

## Adding a New Output Channel

1. Add one row to `ns.OUTPUT_CHANNELS` in `Data/Data.lua`. Its `key` is saved to the database, so pick it once and never rename it.
2. Add its `OPTIONS_OUTPUT_*` label to `Locales/enUS.lua`.

`Features/Core.lua` and the dropdown pick the row up on their own.

## Adding a New Setting

1. Add the default under `profile` in `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`); see *Saved Variables* for why not `global`.
2. Add a widget to `ns.BuildGeneralOptions()` in `Options/Options-General.lua` whose `get` and `set` use `ns.db.profile.<key>`, guarding the `get` with `ns.db and ...`. The control carries a label and one `desc`; the `desc` is its tooltip and its whole explanation.
3. Add the `L` keys to `Locales/enUS.lua`, spelled out: `OPTIONS_<FEATURE>_NAME` and `OPTIONS_<FEATURE>_DESCRIPTION`.
4. If the setting is applied imperatively (a frame shown, an event registered off a toggle), have `ns:ApplyProfile` re-apply it, or a reset or profile switch leaves it stale until a `/reload`.

Removing a setting is not the reverse of this. AceDB strips a value equal to its default at logout, but a value the player changed stays in the saved file, and once its key leaves the defaults table nothing strips it any more. Nil the key explicitly in every stored profile (`ns.db.profiles`), inside a migration tagged `-- MIGRATION (remove after YYYY-MM-DD)` and dated 30 days past its release, and never reuse the retired name: a reused name would read back a choice made under its old meaning. Any other change to the shape, name or scope of saved data ships with its own migration the same way.

## Adding a Registered Event

1. Append the name to `ns.EVENT_NAMES` in `Features/Core.lua` and handle it in the `OnEvent` dispatcher, so the dispatcher and Diagnostics pick it up together.
2. Confirm that every one of the five clients has the event (Style Guide → COMPATIBILITY names the evidence that counts). Every TOC registers the same list, and registering an event a client lacks throws there at load.
3. If the event is a firehose that is never signal, add it to `ns.DIAGNOSTIC_EVENT_EXCLUDE`. If it is sometimes signal and carries a message ID, give it a row in `ns.MESSAGE_ID_FILTERED_EVENTS` instead, bearing in mind that the filter counts a firing as signal only when `ns.MatchError` matches it.

## Localization

- **`enUS.lua` is the source of truth** and the only file that passes the `true` default-fallback flag to `NewLocale`. Every other locale translates its key set, and the Localization pass (`3 - Copy Cleanup & Localization Prompt.md`) owns those files: never hand-edit them during ordinary work. When you add or rename a key, change `enUS.lua` and every code reference together, and never reuse a retired key name, since a stale translation under that name would win over the new English.
- **Placeholders.** `%s`/`%d` count, type and order must match `enUS` per key in every locale, or the string crashes at runtime. The `MSG_FORMAT_*` bodies (four `%s`) are the critical case, and a comment block in `enUS.lua` documents their order for translators. `CHAT_TOO_LONG`'s two `%d` are the silent case: swapped, they don't crash, they report the numbers backwards.
- **Keys reached indirectly.** Eight keys never appear as `L["KEY"]` in code: the three `MSG_FORMAT_*` bodies resolve through `mapping.formatKey`, and the five `OPTIONS_OUTPUT_*` labels through `channel.labelKey`. A search for `L["` reports all eight as unused. They aren't.
- **`MATCH_*` is not display copy.** The two skill names must equal what the client itself prints in that language, because they are substring-matched against its error text. Where a language's clients disagree on a name, the string lists every one, separated by semicolons with no space on either side. A stylized translation silently stops herb and mine detection in that locale while chests keep working.
- **Speaker voice.** The bodies are spoken as the player, so a language with gendered verb agreement must phrase them to read correctly for any character. The current bodies carry no first-person verb; check this whenever one is rewritten.

Everything else, including the Spanish file pairing, the overflow canary and the output ceilings, is per Style Guide → LOCALIZATION and MESSAGES → Message Length; *Announcement Line* covers what the ceiling means for the callout.

## Common Pitfalls

- **Queueing the callout for after combat**: `ChatFrameUtil.OpenChat` takes keyboard focus, so `CanAnnounce` drops the callout in combat. A replay queue would open a stale draft in the player's face as the fight ends. Keep the drop.
- **Keying herb or mine on the error ID**: both node types share one error, so keying on it can't tell a vein from an herb, and the number isn't stable across clients anyway. The skill-name scan is the only thing that separates them.
- **Merging the two mapping tables**: both are string-keyed. Merged, the substring scan would test `ERR_ITEM_LOCKED` against message text. `ERROR_STRING_MAPPING` and `SKILL_MAPPING` stay separate.
- **Making `ns.MatchError` file-local**: the Diagnostics noise filter calls it. Localize it and the first red error after the event log starts raises a Lua error.
- **Trusting a nil check to catch a bad map position**: `C_Map.GetPlayerMapPosition` returns a valid vector reading exactly `0, 0` where the map can't place the player. `AnnounceNode` guards both; drop the second guard and drafts point at the map's corner.
- **Stale tooltip text**: the client doesn't clear `GameTooltipTextLeft1` when the tooltip hides, so the font string keeps returning the last thing hovered. `GetNodeName` reads it only while `GameTooltip:IsShown()`. Without that check, an error arriving with nothing hovered drafts the previous node's name, or a creature's, against the current coordinates. `TooltipShowsItem` doesn't cover this; it catches item tooltips only.
- **Bag lockboxes**: a locked lockbox in the bags raises the same `ERR_ITEM_LOCKED` as a world chest. `TooltipShowsItem` suppresses it; remove that gate and inventory items get called out with world coordinates.
- **A `formatKey` with no body in `enUS.lua`**: AceLocale returns the key's own name rather than nil, so the draft reads `MSG_FORMAT_...` instead of staying silent. Add the body in the same change as its mapping.
- **Adding a raid marker or the add-on name to the line**: the draft is the player's own words (Style Guide → MESSAGES → Target Marker), and WoW Forever blocks `{rtN}` tokens in chat. Keep `BuildAnnounceMessage` and every `MSG_FORMAT_*` body bare.
- **Trimming an over-long draft**: a byte-wise cut splits multi-byte characters. `AnnounceNode` warns and leaves the text whole.
- **Measuring the draft with the channel command attached**: the client strips `/1 ` before sending. Measure `announcement` alone, in bytes.
- **Gating the End of Support notice behind the welcome toggle**: it prints at every login whatever `showWelcome` says, a recorded decision (README-Notes). `ns:PrintEndOfSupport` stays unconditional.
- **Putting a setting in `ns.db.global`**: Reset Profile never touches that scope, so the setting survives a reset and the Profiles panel lies. Settings go in `profile`.
- **Deleting a setting without a cleanup**: a value the player changed stays in the saved file once its key leaves the defaults. Nil it in every stored profile, inside a tagged migration.
- **Renaming an output channel key**: the key is what is saved. A renamed key silently sends existing players back to the default channel.
- **Registering options panels at file scope**: the Profiles panel is built from `ns.db`, which doesn't exist until `PLAYER_LOGIN`. `ns.RegisterOptionsPanels()` is called from Core right after `AceDB:New`.
- **Opening the options by category title**: a title lookup fails wherever the category ID is a number assigned at registration, and the panel floats loose. `ns:OpenOptionsPanel` routes by the captured category ID.
- **Registering an event outside `ns.EVENT_NAMES`, or on a second frame**: the Diagnostics registration check and the event log silently miss it.
- **Registering an event one client lacks**: every TOC loads the same `ns.EVENT_NAMES`, so it throws at load on that client.
- **Putting diagnostics text in `Locales/`**: it is English-only by design and lives in `ns.DiagnosticsStrings`.
- **Adding an unsuffixed `ComeAndGetIt.toc`**: a client with no TOC of its own suffix falls back to it and loads the add-on, under whatever `X-Flavor` it names, on a client Come & Get It does not target.

## Contributing

- **Issues**: open them on the [GitHub Issues tab](https://github.com/Gogo1951/Come-and-Get-It/issues).
- **Bug reports**: include game version and locale, class and level, repro steps, and the relevant chat output. The drafted line itself, or a Detection Context report from Diagnostic Tools, is ideal.
- **Discord**: [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **Pull requests**:
  - Keep each PR scoped to one change, and match the surrounding style: vararg namespace modules, dashed section dividers, and comments only for what the code can't say for itself.
  - Run StyLua with its default configuration plus `--syntax lua51` (the repo ships no `.stylua.toml`), then `luac -p` and a clean `luacheck .`.
  - Respect the single-source tables: `ns.EVENT_NAMES`, `ns.OUTPUT_CHANNELS`, `ns.PALETTE`, `ns.DiagnosticsStrings`, and the two mapping tables in `Core.lua`.
  - If you change a `MSG_FORMAT_*` body, keep its four `%s` in order and confirm the longest composed line stays within the 255-byte chat limit, measured in bytes against ruRU and koKR rather than English (Style Guide → MESSAGES → Message Length).
  - Migration discipline: settings go under `profile`, and any change to the shape, name or scope of saved data, a removed setting included, ships a dated migration rather than rewriting or dropping what players already have.
  - Update this document if the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X" or "I fixed Y." Frame the change in terms of who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player who got pulled into combat the instant I clicked a vein, I wanted Come & Get It to stay silent during a fight so that the chat box wouldn't steal my movement keys. This change drops the callout when `InCombatLockdown()` is true rather than queuing it for later.*
