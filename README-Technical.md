# Come & Get It — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Come & Get It. For end-user documentation, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md).

## File Map

```
Come-and-Get-It/
├── .github/workflows/package.yml   # CurseForge release + library vendoring (canonical, copied verbatim)
├── .pkgmeta                        # package-as: ComeAndGetIt; library externals + ignore list
├── LICENSE                         # MIT
├── ComeAndGetIt.toc                # Load manifest: Interface versions, SavedVariables, file order
├── README.md                       # Player-facing documentation
├── README-Technical.md             # This document
├── Data/
│   ├── Data.lua                    # Constants: locked-chest error ID, cooldown, chat byte limit,
│   │                               #   target marker, output-channel manifest, URLs, registry, ns.PALETTE
│   └── Default-Settings.lua        # ns.DATABASE_DEFAULTS — the AceDB-3.0 defaults table (profile only)
├── Features/
│   ├── Core.lua                    # Version resolver, event dispatcher, error->mapping match,
│   │                               #   AnnounceNode pipeline, AceDB init + migration block
│   ├── Utilities.lua               # Derived COLORS table + GetColor accessor
│   ├── Announcements.lua           # Messaging: PrintMessage / PrintWelcome / BuildAnnounceMessage.
│   │                               #   NOT AnnounceNode — that lives in Core.lua.
│   └── Diagnostics.lua             # Opt-in report builders, event-log tap, taint toggle (canonical)
├── Options/
│   ├── Options-Utilities.lua       # Shared AceConfig widget builders (OptionsHeader / Desc / Spacer)
│   ├── Options-General.lua         # General panel: welcome toggle, output dropdown, links, version
│   ├── Options-Profiles.lua        # Stock AceDBOptions-3.0 profiles panel, returned as-is
│   ├── Options-Diagnostics.lua     # Diagnostics panel: gate toggle + gated report buttons (canonical)
│   └── Options.lua                 # ns.RegisterOptionsPanels() — registers all three; called at login
├── Locales/
│   ├── enUS.lua                    # Default locale (NewLocale(..., true)); the canonical 25-key set
│   └── deDE / esES / esMX / frFR / itIT / koKR / ptBR / ruRU / zhCN / zhTW .lua   # Standalone translations
└── Includes/
    ├── Images/Come-And-Get-It.tga  # Add-on icon (## IconTexture)
    └── Libraries/                  # Vendored: LibStub, CallbackHandler-1.0, AceLocale-3.0, AceDB-3.0,
                                    #   AceGUI-3.0, AceConfig-3.0 (+ Registry / Cmd / Dialog), AceDBOptions-3.0
```

The three root files above the TOC exist in the repo but **not** in an installed copy: `.pkgmeta`'s `ignore` list strips `.github`, `.pkgmeta`, and `LICENSE` from the published zip. Don't be surprised when they're missing from `Interface/AddOns/ComeAndGetIt/`, and don't add them there.

There are no deprecated or dead files. Every `Locales/*.lua` is standalone and translates the full `enUS.lua` key set; none registers another locale's strings.

`Features/Diagnostics.lua` and `Options/Options-Diagnostics.lua` are the canonical diagnostics framework copied from Open-Sesame. Only their manifests are re-authored here (`ns.DIAGNOSTIC_API_CHECKS`, `ns.DIAGNOSTIC_EVENT_EXCLUDE`, `ns:BuildContextReport`, the SavedVariables table name). Keep the framework verbatim so it stays diffable against the canonical.

## Architecture

### Module Layout & Load Order

Every file is a vararg module — `local ADDON_NAME, ns = ...` where the file needs the name, `local _, ns = ...` otherwise, and `local L = ns.L` only in files that read `L`. All files share the one namespace table, so the only globals are `ComeAndGetItDB` (owned by AceDB) and the anonymous event frame in `Core.lua`. Load order in `ComeAndGetIt.toc` is load-bearing:

1. **Libraries** — LibStub through AceDBOptions-3.0, in the fixed order the AceConfig stack requires.
2. **Locales** — `enUS.lua` first (it owns the `true` default flag); the rest fill their own client locale.
3. **Data** — `Data.lua` resolves `ns.L` and publishes constants; `Default-Settings.lua` publishes `ns.DATABASE_DEFAULTS`.
4. **Features then Options** — Core wires events; Utilities / Announcements / Diagnostics add helpers; `Options.lua` loads last and defines `ns.RegisterOptionsPanels()`, which Core calls at login.

Anything reading `ns.L` or a constant must load *after* `Data/Data.lua`. `Options-Utilities.lua` must load before `Options-General.lua`, which grabs the widget builders at file scope.

### Event Loop

`Core.lua` creates one hidden frame and registers exactly the events in `ns.EVENT_NAMES`:

```lua
ns.EVENT_NAMES = { "PLAYER_LOGIN", "UI_ERROR_MESSAGE" }
```

The `OnEvent` handler is the only dispatcher, and runs in order:

1. **Diagnostics tap** — if `ns.diagnostics.logging` is true, `ns:LogEvent(event, ...)` records the event first. A single boolean guard makes the tap free when logging is off.
2. **`PLAYER_LOGIN`** — `InitSavedVariables()`, then `ns.RegisterOptionsPanels()`, then `ns:PrintWelcome()`.
3. **`UI_ERROR_MESSAGE`** — `MatchError(messageID, message)`; on a match, `AnnounceNode(mapping)`.

There is no throttling at the dispatcher; rate limiting lives in `AnnounceNode`'s cooldown gate. `EVENT_NAMES` is exported and reused by Diagnostics' registration check, so the probe can never drift. Add events by appending to this table, never by calling `RegisterEvent` ad hoc.

### Combat Lockdown

`AnnounceNode` returns immediately when `InCombatLockdown()` is true. This is **intentional and load-bearing, not a missing feature**: the write step calls `ChatFrame_OpenChat`, which steals keyboard focus and breaks WASD movement mid-fight. The announcement is *dropped*, not queued — a stale node callout after combat ends is noise, and the node re-fires its `UI_ERROR_MESSAGE` on the next interaction. Do not replace this with a deferred-replay queue.

### Detect → Compose → Write

The announcement pipeline is the add-on's core flow, all in `Features/Core.lua`.

**Detect — `MatchError(messageID, message)`** uses two key kinds against one `ERROR_MAPPING` table:

- **Fast path (numeric):** locked chests fire a stable Blizzard error ID (`ns.ERROR_ID_LOCKED_CHEST = 268`), looked up directly.
- **Slow path (string):** herb/mine nodes fire a generic localized *"Requires &lt;Skill&gt;"* message with no stable ID, so the lowercased message is substring-scanned against `L["MATCH_HERB"]` / `L["MATCH_MINE"]`. A load-time `LOWER_MATCH` table keeps the hot path from re-lowercasing constants.

The two key kinds share one table but occupy disjoint namespaces (integers vs. strings); the integer is checked first, then string keys only on a miss. Substring matching is an accepted tradeoff, documented at the call site: no gather error carries a numeric ID stable across the supported clients, word-boundary patterns break CJK locales, and the residual risk is bounded because the add-on never auto-sends.

**Compose — `AnnounceNode(mapping)`** runs cheap suppression gates first, then gathers data:

1. Gates in order: `IsInInstance()` → `InCombatLockdown()` → cooldown (`ns.ANNOUNCE_COOLDOWN`, 5s) → `C_Map` availability.
2. Node name from `GameTooltipTextLeft1:GetText()`, read only while `GameTooltip` is shown. If nil or empty, bail — there is **no** fallback node name.
3. Bag-item suppression via `TooltipShowsItem()`.
4. Position and zone from the guarded `C_Map` chain.
5. Decorated line via `ns:BuildAnnounceMessage(mapping.formatKey, ...)`; bail if it returns nil.

**Write** opens — never sends — the chat editbox, pre-filled with the configured channel command:

```lua
local channelKey = (ns.db and ns.db.profile.defaultOutput) or ns.DEFAULT_OUTPUT_CHANNEL
local command = OUTPUT_COMMAND[channelKey] or OUTPUT_COMMAND[ns.DEFAULT_OUTPUT_CHANNEL]
ChatFrame_OpenChat(command .. " " .. announcement, ChatFrame1)
```

A guard skips the write entirely if `ChatEdit_GetActiveWindow()` reports the player is already typing, so a draft in progress is never clobbered. `lastAnnounceTime` is stamped only after a successful open, so a bailed attempt never starts the cooldown.

Immediately before the open, `AnnounceNode` measures `#announcement` (bytes, not characters) against `ns.CHAT_MESSAGE_MAX_LENGTH` and prints `L["CHAT_TOO_LONG"]` when it overflows. The draft still opens with the full text: the string is never trimmed, because a byte-wise cut would split a multi-byte character in ruRU/koKR/zhCN, and dropping the zone or coordinates would gut the message. The player edits it down themselves, which the never-auto-send design already assumes. The measurement targets `announcement` alone, not the `command .. " "` prefix, which the client strips as a channel selector rather than sending.

### Cross-Client API Guards

The add-on ships against Classic Era and TBC Anniversary. Capabilities that differ across clients are resolved by availability, never by truthy result:

- **`C_Map`** may be absent on the earliest Classic builds. `Core.lua` aliases the three needed functions at file scope and `AnnounceNode` bails if any alias is nil.
- **Tooltip item read** — `TooltipShowsItem` picks `TooltipUtil.GetDisplayedItem` where present, else `GameTooltip:GetItem()`, calling exactly one. On Classic Era the legacy branch is the live path; `TooltipUtil` does not exist there.
- **`C_AddOns.GetAddOnMetadata`** vs. the legacy global — `GetVersion` and Diagnostics use a `(modern) or (legacy)` shim; safe here because neither call can return `false`. On 1.15.9 the legacy global is gone, so the modern branch is the live path.
- **`C_CVar.GetCVar` / `SetCVar`** vs. the legacy globals — the taint-log control picks by availability with an explicit `if`, because a CVar read *can* legitimately return `false`.
- **`C_EventUtils.IsEventValid`** exists only on newer clients; the event check degrades to `"n/a"` when absent.

`ns.DIAGNOSTIC_API_CHECKS` lists the modern and legacy forms separately so a bug report shows exactly what a given client provides — a `[FAIL]` on one half of a pair is expected, not a defect, as long as its partner passes.

### Color System

`Data/Data.lua` holds the raw hex palette as `ns.PALETTE`; `Features/Utilities.lua` derives the `COLORS` table by looping over the palette (prefixing each entry with `|cff`) and exposes `ns.GetColor(key)`, which returns the escape string. Deriving rather than listing keys by hand means a new palette entry needs registering in one place only. Callers append the closing `|r` at the point of use, and each consuming file aliases the accessor once as `local GetColor = ns.GetColor`. An unknown key falls back to `TEXT`.

The palette carries the BODY/HELP split: `BODY` is white (`FFFFFF`) for descriptions and options body text, `HELP` is silver (`CCCCCC`) for notes and helper text. Every note and hint in the options and diagnostics panels uses `GetColor("HELP")`. `BODY`, `ON`, and `OFF` are defined but currently unreferenced — that is deliberate; the palette is a fixed house set and unused keys stay.

## Announcement Message Format

The sent line is decorated in one place. `ns:BuildAnnounceMessage(formatKey, ...)` (`Features/Announcements.lua`) prepends the target marker, the display name, and the `" // "` separator, then fills the locale body's placeholders:

```lua
-- Composed: {marker} {ADDON_TITLE} // {body}
ns.TARGET_MARKER .. " " .. L["ADDON_TITLE"] .. " // " .. string.format(template, ...)
```

There are three bodies, one per trigger, and `ERROR_MAPPING` selects which by carrying a `formatKey`. Each is the **body only** — four positional `%s`, filled by `AnnounceNode` in this fixed order: node name, x coord, y coord, zone name.

```lua
-- L["MSG_FORMAT_MINE"] (enUS) — body only, no marker or name
"Hey Miners, I came across something I can't mine: %s at %s, %s in %s!"
```

Produces, e.g.:

> {rt7} Come & Get It // Hey Miners, I came across something I can't mine: Rich Thorium Vein at 25, 54 in Eastern Plaguelands!

Three non-obvious rules govern this:

- **The marker lives only in `ns.TARGET_MARKER` (`Data.lua`).** It is applied at send time, never baked into a locale body. A locale that re-adds the marker or name double-prefixes.
- **Placeholder order is coupled across all locales.** A translation may reorder the *sentence* freely but must keep the four `%s` in the same logical order, count, and type. A `%s`/`%d` mismatch crashes at runtime.
- **Nothing precedes the node name, and that is load-bearing.** The role and verb are baked into each sentence rather than passed as fragments, so no article or adjective ever has to agree with a name whose gender and number are unknown until runtime. The old fragment design forced exactly that and was unfixable in gendered languages: deDE rendered "ein Goldader" where "Ader" is feminine. A translation that reintroduces an article directly before `%s` reintroduces the bug.

`BuildAnnounceMessage` also strips stray pipes (`|`) from the finished body — safe because announcement bodies never carry item links — and returns nil if the format key is missing, which `AnnounceNode` treats as "say nothing."

## Output Channels

`ns.OUTPUT_CHANNELS` (`Data/Data.lua`) is the single source of truth for where a draft can be addressed. Each row pairs a stable saved key with the slash command and a locale label key:

```lua
{ key = "channel1", command = "/1", labelKey = "OPTIONS_OUTPUT_CHANNEL1" }
```

Two derived lookups trace back to it so the list, its order, and the command mapping can never drift:

- `Core.lua` builds `OUTPUT_COMMAND` (`key -> command`) for the write step.
- `Options-General.lua` builds the dropdown's `values`/`sorting` from the same manifest, labels resolved once at load.

The chosen key is saved to `ns.db.profile.defaultOutput`; array order is dropdown order. Adding a channel is one row here plus its `OPTIONS_OUTPUT_*` locale string. Local (`/1`) is the zone General channel — layer-specific in Classic, which the option's note string calls out.

## Diagnostics Panel

Design constraints:

- **Opt-in and runtime-only.** `ns.diagnostics = { enabled, logging, log }` is a plain namespace table, **not** a SavedVariable — it resets every session. A single toggle (`ns:SetDiagnosticsEnabled`) gates the whole panel; turning it off also calls `ns:StopEventLog`. Every section below the toggle is an inline widget with a `hidden` function, since header widgets don't honor `hidden` directly.
- **Read-only by contract.** Reports build only on a button press, never on load or panel open. The sole state any button writes is the `taintLog` CVar.
- **Event-log tap.** `ns:LogEvent` snapshots arguments to strings *immediately* — never retaining frame/table references — caps at 8 args and 255 bytes each, escapes pipes (`|` → `||`) **after** the length cut, and keeps a 500-entry ring buffer.
- **`ns.DIAGNOSTIC_EVENT_EXCLUDE` is deliberately empty.** The dispatcher only ever hands `LogEvent` the events this add-on registers, and neither is a firehose, so the log never sees an event worth dropping. The lookup stays so a genuine no-signal firehose can be excluded here if one is ever registered.
- **Live detection context.** `ns:BuildContextReport` prints *actual values* — the match strings, the instance/combat gates, and the resolved `mapID`, position, and zone — because that is what explains a "nothing happened" report. It replaces Open-Sesame's loot-specific probe.
- **Single sources of truth.** Event checks iterate `ns.EVENT_NAMES` (from Core); API checks iterate `ns.DIAGNOSTIC_API_CHECKS`.
- **Strings are not localized.** All diagnostics UI text lives in `ns.DiagnosticsStrings` as plain English. The one localized value is `L["ADDON_TITLE"]`, which is identity, not diagnostics copy.

## Saved Variables

A single account-wide `SavedVariables` table, `ComeAndGetItDB`, declared in the `.toc` and managed by **AceDB-3.0**. Every user setting lives under the active profile:

| Field (`ns.db.profile`) | Type | Default | Holds |
| --- | --- | --- | --- |
| `showWelcome` | boolean | `true` | Whether `PrintWelcome` prints the version/settings line on login |
| `defaultOutput` | string | `"channel1"` | Which `ns.OUTPUT_CHANNELS` key the draft is addressed to |

`ns.db.global` is unused — it is reserved for a minimap-button position, and this add-on has no minimap button. The database is created in `InitSavedVariables` (`Features/Core.lua`) on `PLAYER_LOGIN`:

```lua
ns.db = LibStub("AceDB-3.0"):New("ComeAndGetItDB", ns.DATABASE_DEFAULTS, true)
```

The third argument (`true`) puts every character on one shared "Default" profile; per-character profiles are opt-in through the stock Profiles panel.

### Migration Chain

Two cleanups share one inline block at the end of `InitSavedVariables`, under a single tag: `MIGRATION (remove after 2026-10-08)`. Delete the whole block once the window closes — there is no legacy TOC entry to drop.

- **Flat-key lift** — pre-AceDB builds stored `showWelcome` / `defaultOutput` at the root of `ComeAndGetItDB`; on first login it lifts any such root value into `ns.db.profile` and clears the root key.
- **Dead-key deletion** — `announceOnClick` was a setting in an earlier build and is gone from the code, but AceDB never removes it: a key absent from `ns.DATABASE_DEFAULTS` is ordinary user data, not a managed default, so it persists untouched forever. The block clears it by iterating `ns.db.profiles`, AceDB's table of *every* stored profile, rather than touching `ns.db.profile` alone — that would clean only whichever profile happened to be active at login and leave the key in all the others. The active profile is itself a member of that table, so no separate pass is needed.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied lazily by AceDB-3.0 via metatables — nothing is copied into the saved table, and explicit user values (including `false`) are never overridden.

There are no default item or spell lists, so there is no refill-on-empty logic.

## Adding a New Tracked Node Type

1. **Identify the trigger.** If the client fires a *stable numeric* UI error ID, add it as a constant in `Data/Data.lua` (mirroring `ns.ERROR_ID_LOCKED_CHEST = 268`). If it fires only a localized *"Requires &lt;Skill&gt;"* string, match a localized substring instead — no constant needed.
2. **Add an `ERROR_MAPPING` entry** in `Features/Core.lua`, keyed by the numeric ID (fast path) **or** by `L["MATCH_…"]` (substring path), carrying a single `formatKey` naming its `MSG_FORMAT_…` body.
3. **Add every referenced `L` key** to `Locales/enUS.lua` first: the new `MSG_FORMAT_…` body, and the `MATCH_…` skill string if you matched by substring. Write the body with nothing preceding its leading `%s`. The Localization pass translates the rest.
4. **Keep the key namespaces disjoint** — numeric keys take the fast path, string keys are lowercased and substring-scanned. Never reuse a number as a string key.
5. **Watch the line length.** The composed announcement is a chat message, so the ceiling is the **255-byte chat line** — see Localization → Locale overflow.

## Adding a New Setting

1. Add the default under `profile` in `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`); AceDB applies it lazily.
2. Add a widget to `ns.BuildGeneralOptions()` in `Options/Options-General.lua` whose `get`/`set` read and write `ns.db.profile.<key>`. Guard the `get` with `ns.db and …`.
3. Add the `L` keys to `Locales/enUS.lua`. Key names spell words out — `OPTIONS_<FEATURE>_NAME` and `OPTIONS_<FEATURE>_DESCRIPTION`, never `_DESC`.

**Removing one is not the reverse of this.** Deleting the default and the widget leaves the key sitting in every existing player's saved profile forever, because AceDB only manages keys that are in the defaults table. Every removal needs a dated cleanup line in the migration block that iterates `ns.db.profiles` — see Saved Variables → Migration Chain for the shape.

## Adding a New Diagnostic Report

1. Add a `ns:BuildXxxReport()` builder in `Features/Diagnostics.lua` that returns a string and starts from `GetClientHeader()`. Keep it read-only and side-effect free.
2. Add the `TITLE`/`BUTTON` text to `ns.DiagnosticsStrings` as plain English (these are **not** localized).
3. In `Options/Options-Diagnostics.lua`, add a gated `SectionHeader`, an `execute` button that stores into `ns.diagnostics.xxxReport` and calls `Refresh()`, and a `ReportOutput("xxxReport", order)`.

## Adding a Registered Event

Append the event name to `ns.EVENT_NAMES` in `Features/Core.lua` and handle it in the `OnEvent` dispatcher, so the dispatcher and diagnostics pick it up together. Registering it anywhere else means Diagnostics' registration check and event log silently miss it. If the new event is a firehose, add it to `ns.DIAGNOSTIC_EVENT_EXCLUDE` — that table is empty today precisely because nothing registered warrants it.

## Localization

- **Structure** — locale files live in `Locales/<locale>.lua`, each registered through AceLocale-3.0's `NewLocale`. `enUS.lua` is the source of truth and the only file that passes the `true` default-fallback flag; every string originates there and the other locales translate from it. The current key set is 25 keys, identical in all 11 files.
- **Keeping locales in sync** — AceLocale falls back to English via `__index` for anything missing at runtime, so a missing key degrades to English rather than erroring. Translating each `enUS.lua` key into every locale and keeping the files aligned is the job of the Localization pass (`3 - Copy Cleanup & Localization Prompt.md`); don't hand-edit the other locales during ordinary work. When you add or rename a key, change `enUS.lua` and every code reference in the same commit.
- **Placeholders** — `%s`/`%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime. The `MSG_FORMAT_*` bodies (four `%s` each) are the critical case; an in-file comment block documents their order for translators. `CHAT_TOO_LONG`'s two `%d` are the silent case: swapping them does not crash, it just reports the numbers backwards.
- **Keys reached indirectly** — eight of the 25 keys are never written as `L["KEY"]` anywhere in the code. The three `MSG_FORMAT_*` bodies resolve through `mapping.formatKey`, and the five `OPTIONS_OUTPUT_*` labels through `channel.labelKey`. A search for `L["` will report all eight as unused; they are not. Match bare string literals too before deleting anything.
- **Spanish** — esES/esMX are two separate, self-contained files; identical Spanish in both is correct and expected.
- **Locale overflow** — the ceiling is the **255-byte chat line**, and it is measured in *bytes*, not characters. German is the usual first suspect, but for this add-on the longest composed line is Russian. Measured against a Cyrillic-scale worst case (42-byte node name, 44-byte zone), the tightest locales are ruRU 217 bytes and koKR 209, against deDE 206, frFR 201, and enUS 178. Cyrillic runs two bytes per character and CJK three, so check those locales, not just German, whenever a `MSG_FORMAT_*` body grows. `AnnounceNode` also measures the composed line at runtime and warns the player when it overflows (see Detect → Compose → Write), but that is a backstop for the long-node-name-in-a-long-zone tail: measuring at translation time is still the first line of defence, because the runtime warning fires after the fact and only the player sees it.

## Common Pitfalls

- **Announcing in combat**: `ChatFrame_OpenChat` steals keyboard focus and breaks movement. `AnnounceNode` deliberately *drops* the announcement when `InCombatLockdown()` is true — don't "fix" it into a deferred queue.
- **`Announcements.lua` is misnamed**: it holds only the messaging helpers (`PrintMessage`, `PrintWelcome`, `BuildAnnounceMessage`). The node-announce logic is `AnnounceNode` in `Core.lua`.
- **Baking the marker into a locale string**: the target marker lives only in `ns.TARGET_MARKER` and is applied by `BuildAnnounceMessage`. A body that includes `{rt7}` or the add-on name double-prefixes the sent line.
- **Reordering `%s` in a locale's `MSG_FORMAT_*`**: argument order is fixed by the `AnnounceNode` call site across all locales. Reorder the sentence freely, but not the placeholders.
- **Putting an article back in front of the node name**: the three `MSG_FORMAT_*` bodies deliberately lead into `%s` with nothing attached to it. An article or adjective there has to agree with a name whose gender and number are not known until runtime, which no translation can satisfy.
- **Deleting a setting without a cleanup line**: removing it from `ns.DATABASE_DEFAULTS` and the options panel does not remove it from anyone's save file — AceDB only manages keys present in the defaults. `announceOnClick` survived that way and had to be swept later. Pair every removal with a dated migration-block deletion.
- **Bag lockboxes**: a locked lockbox in the player's own bags fires the same error (`268`) as a world chest. `AnnounceNode` suppresses it via `TooltipShowsItem`; removing that gate calls out inventory items with world coordinates.
- **Stale tooltip text**: WoW does not clear `GameTooltipTextLeft1` when a tooltip hides, so the FontString keeps returning the last thing hovered. `GetNodeName` therefore reads it only while `GameTooltip:IsShown()` is true. Drop that check and an error arriving with nothing hovered drafts the previous node's name, or a creature's, against your current coordinates. `TooltipShowsItem` does not cover this: it catches item tooltips only, not unit tooltips or stale text.
- **Registering an event outside `EVENT_NAMES`**: Diagnostics' registration check and event log silently miss it. Always append to `ns.EVENT_NAMES`.
- **Registering options panels at file scope**: the Profiles panel is built from `AceDBOptions:GetOptionsTable(ns.db)`, so it needs the database. Core calls `ns.RegisterOptionsPanels()` after `ns.db` exists; registering at file scope errors.
- **Assuming `C_Map` exists**: it is nil on early Classic builds. Use the file-scope aliases and bail like `AnnounceNode` does.
- **Reading a `[FAIL]` in the API report as a bug**: the manifest lists modern and legacy forms as separate rows on purpose. On 1.15.9, `GetAddOnMetadata (legacy)` and `TooltipUtil.GetDisplayedItem` both fail, and both are fine — their partners pass and the guards pick by availability.
- **Using `GetColor("BODY")` for helper text**: `BODY` is white. Notes, hints, and pro tips use `GetColor("HELP")` (silver).
- **Putting diagnostics text in `Locales/`**: diagnostics strings are intentionally English-only and live in `ns.DiagnosticsStrings`.
- **Treating `ns.diagnostics` as persistent**: it is runtime-only and resets each session. Only `ComeAndGetItDB` survives a reload.
- **Editing the diagnostics pair freely**: `Features/Diagnostics.lua` and `Options/Options-Diagnostics.lua` are canonical copies. Change the manifests, keep the framework verbatim.

## Contributing

- **Issues**: open them on the [GitHub Issues tab](https://github.com/Gogo1951/Come-and-Get-It/issues).
- **Bug reports** should include: game version + locale, character class + level, repro steps, and the relevant chat output — ideally the drafted announcement line, or a **Detection Context** report from the Diagnostics panel.
- **Discord**: [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **Pull requests**:
  - Keep each PR scoped to one change. Match the surrounding style (vararg namespace modules, dashed section dividers, and comments reserved for the non-obvious *why*).
  - Run StyLua with its default configuration before committing; the repo ships no `.stylua.toml`. Default output includes LF line endings.
  - Respect load order and the single-source-of-truth tables (`EVENT_NAMES`, `ERROR_MAPPING`, `OUTPUT_CHANNELS`, `PALETTE`, `DiagnosticsStrings`).
  - If you change a `MSG_FORMAT_*` body or any locale string, verify the longest composed line stays within the **255-byte chat limit** (check ruRU and koKR, not just deDE) and keep the four `%s` order intact. The runtime check in `AnnounceNode` warns the player past that ceiling, but it does not excuse skipping the measurement: it fires only once the line has already overflowed.
  - Saved-variable discipline: add settings as `ns.DATABASE_DEFAULTS.profile` defaults; any table or key reshape gets a dated `MIGRATION (remove after …)` block, never a rewrite of existing user values. Removing a setting needs a cleanup line, not just a deletion.
  - Update this document if the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X." Frame it as who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player who got pulled into combat the instant I clicked a vein, I wanted Come & Get It to stay silent during a fight so the chat box wouldn't steal my movement keys. This change drops the announcement when `InCombatLockdown()` is true rather than queuing it for later.*
