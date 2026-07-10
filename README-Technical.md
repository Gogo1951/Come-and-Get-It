# Come & Get It — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Come & Get It. For end-user documentation, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md).

## File Map

```
ComeAndGetIt/
├── ComeAndGetIt.toc                # Load manifest: Interface versions, SavedVariables, file order
├── README.md                       # Player-facing documentation
├── README-Technical.md             # This document
├── Data/
│   ├── Data.lua                    # Constants: locked-chest error ID, cooldown, target marker,
│   │                               #   output-channel manifest, URLs, options-registry names, hex palette
│   └── Default-Settings.lua        # ns.DATABASE_DEFAULTS — the AceDB-3.0 defaults table (profile scope)
├── Features/
│   ├── Core.lua                    # Version resolver, event dispatcher, error→mapping match,
│   │                               #   AnnounceNode pipeline, AceDB init + legacy-key migration
│   ├── Utilities.lua               # Derived COLORS table + GetColor accessor (logic for Data's hex palette)
│   ├── Announcements.lua           # Messaging: PrintMessage / PrintWelcome, and BuildAnnounceMessage
│   │                               #   (marker + name + " // " decoration). NOT AnnounceNode — that is in Core.lua.
│   └── Diagnostics.lua             # Opt-in developer report builders, event-log tap, taint toggle (verbatim canonical)
├── Options/
│   ├── Options-Utilities.lua       # Shared AceConfig widget builders (OptionsHeader / Desc / Spacer)
│   ├── Options-General.lua         # General panel: welcome toggle, output dropdown, feedback links, version
│   ├── Options-Profiles.lua        # Stock AceDBOptions-3.0 profiles panel, returned as-is
│   ├── Options-Diagnostics.lua     # Diagnostics panel: gate toggle + gated report buttons (verbatim canonical)
│   └── Options.lua                 # ns.RegisterOptionsPanels() — registers all three panels; called from Core at login
├── Locales/
│   ├── enUS.lua                    # Default locale (NewLocale(..., true)); the canonical key set
│   └── deDE / esES / esMX / frFR / itIT / koKR / ptBR / ruRU / zhCN / zhTW .lua   # Standalone translations
└── Includes/
    ├── Images/Come-And-Get-It.tga  # Add-on icon (## IconTexture)
    └── Libraries/                  # Vendored: LibStub, CallbackHandler-1.0, AceLocale-3.0, AceDB-3.0, AceGUI-3.0,
                                    #   AceConfig-3.0 (+ Registry / Cmd / Dialog), AceDBOptions-3.0
```

Every `Locales/*.lua` is a standalone file that translates the full `enUS.lua` key set; none registers another locale's strings.

## Architecture

### Module Layout & Load Order

Every file is a vararg module — `local ADDON_NAME, ns = ...` where the file needs the name, `local _, ns = ...` otherwise. All files share the one namespace table WoW passes as the second vararg, so the only globals are `ComeAndGetItDB` (the SavedVariables table, owned by AceDB) and the anonymous `_G` event frame in `Core.lua`. Load order in `ComeAndGetIt.toc` is load-bearing:

1. **Libraries** — LibStub through AceDBOptions-3.0, in the fixed order the AceConfig stack requires.
2. **Locales** — `enUS.lua` first (it owns the `true` default flag); the rest fill their own client locale.
3. **Data** — `Data.lua` resolves `ns.L` and publishes constants; `Default-Settings.lua` publishes `ns.DATABASE_DEFAULTS`.
4. **Features then Options** — Core wires events; Utilities / Announcements / Diagnostics add helpers; `Options.lua` loads last and defines `ns.RegisterOptionsPanels()`, which Core calls at login.

Anything that reads `ns.L` or a constant must load *after* `Data/Data.lua`.

### Event Loop

`Core.lua` creates a single hidden `Frame` and registers exactly the events listed in `ns.EVENT_NAMES`:

```lua
ns.EVENT_NAMES = { "PLAYER_LOGIN", "UI_ERROR_MESSAGE" }
```

The `OnEvent` handler is the only dispatcher. It runs in order:

1. **Diagnostics tap** — if `ns.diagnostics.logging` is true, `ns:LogEvent(event, ...)` records the event first. The boolean guard makes the tap free when logging is off.
2. **`PLAYER_LOGIN`** — `InitSavedVariables()` (create the AceDB database + migrate legacy keys), then `ns.RegisterOptionsPanels()`, then `ns:PrintWelcome()`.
3. **`UI_ERROR_MESSAGE`** — `MatchError(messageID, message)` → on a match, `AnnounceNode(mapping)`.

`EVENT_NAMES` is exported and reused by Diagnostics' registration check, so the probe can never drift from what the dispatcher registers. Add events by appending to this table, never by calling `RegisterEvent` ad hoc.

### Combat Lockdown

`AnnounceNode` returns immediately when `InCombatLockdown()` is true. This is **intentional and load-bearing, not a missing feature**: the write step calls `ChatFrame_OpenChat`, which steals keyboard focus and breaks WASD movement mid-fight. The announcement is *dropped*, not queued — a stale node callout after combat ends is noise, and the node re-fires its `UI_ERROR_MESSAGE` on the next interaction once combat drops. Do not replace this with a deferred-replay queue.

### Detect → Compose → Write

The announcement pipeline is the add-on's core flow, all in `Features/Core.lua`.

**Detect — `MatchError(messageID, message)`** uses a two-key strategy against one `ERROR_MAPPING` table:

- **Fast path (numeric):** locked chests fire a stable Blizzard error ID (`ns.ERROR_ID_LOCKED_CHEST = 268`), looked up directly as `ERROR_MAPPING[messageID]`.
- **Slow path (string):** herb/mine nodes fire a generic localized *"Requires &lt;Skill&gt;"* message with no stable ID, so the lowercased message is substring-scanned against the localized skill names (`L["MATCH_HERB"]`, `L["MATCH_MINE"]`). The scan uses a load-time `LOWER_MATCH` table so the hot path never re-lowercases constants.

The two key kinds share one table but occupy disjoint namespaces (integers vs. strings); `MatchError` checks the integer key first, then iterates string keys only on a miss.

**Compose — `AnnounceNode(mapping)`** runs cheap suppression gates first, then gathers data:

1. Gates, in order: `IsInInstance()` → `InCombatLockdown()` → cooldown (`GetTime() - lastAnnounceTime < ANNOUNCE_COOLDOWN`, 5s) → `C_Map` availability.
2. Node name from `GameTooltipTextLeft1:GetText()`. If it is nil/empty, bail — there is **no** fallback node name.
3. Bag-item suppression: `TooltipShowsItem()` bails when the tooltip is describing an inventory item (a locked lockbox in the bags fires the same error as a world chest).
4. Position and zone from the guarded `C_Map` chain.
5. English-only article fix: `"a"` → `"an"` before a vowel-initial node name (`enUS`/`enGB` only).
6. Decorated line via `ns:BuildAnnounceMessage("MSG_FORMAT", ...)`; bail if it returns nil.

**Write** opens — never sends — the chat editbox, pre-filled with the user's configured output channel command:

```lua
local channelKey = (ns.db and ns.db.profile.defaultOutput) or ns.DEFAULT_OUTPUT_CHANNEL
local command = OUTPUT_COMMAND[channelKey] or OUTPUT_COMMAND[ns.DEFAULT_OUTPUT_CHANNEL]
ChatFrame_OpenChat(command .. " " .. announcement, ChatFrame1)
```

A guard skips the write entirely if `ChatEdit_GetActiveWindow()` reports the player is already typing, so a draft in progress is never clobbered. `lastAnnounceTime` is stamped only after a successful open.

### Cross-Client API Guards

The add-on ships against Classic Era and TBC Anniversary (`## Interface: 11508, 20506`). Capabilities that differ across clients are resolved once, defensively, by availability — never by truthy result:

- **`C_Map`** may be entirely absent on the earliest Classic builds. `Core.lua` aliases the three needed functions at file scope (`GetBestMapForUnit`, `GetPlayerMapPosition`, `GetMapInfo`) and `AnnounceNode` bails if any alias is nil.
- **Tooltip item read** — `TooltipShowsItem` picks `TooltipUtil.GetDisplayedItem` where present, else `GameTooltip:GetItem()`, calling exactly one.
- **`C_AddOns.GetAddOnMetadata`** vs. the legacy global `GetAddOnMetadata`: `Core.lua`'s `GetVersion` and `Diagnostics.lua` both pick `(C_AddOns and C_AddOns.X) or X`.
- **`C_CVar.GetCVar` / `SetCVar`** vs. the legacy globals — Diagnostics' taint-log control picks by availability.
- **`C_EventUtils.IsEventValid`** exists only on newer clients; the diagnostics event check degrades to `"n/a"` when absent.

`Diagnostics.lua`'s API-endpoint report (`ns.DIAGNOSTIC_API_CHECKS`) lists the modern and legacy forms separately so a bug report shows exactly what a given client provides.

### Color System

`Data/Data.lua` holds the **raw hex palette only** (`ns.C_TITLE`, `ns.C_INFO`, …) because Data files carry no logic. `Features/Utilities.lua` derives the `COLORS` table (prefixing each with `|cff`) and exposes `ns.GetColor(key)`, which returns the escape string; callers append the closing `|r` at the point of use. `GetColor` falls back to `TEXT` for an unknown key.

## Announcement Message Format

The sent line is decorated in one place. `ns:BuildAnnounceMessage(formatKey, ...)` (`Features/Announcements.lua`) prepends the target marker, the display name, and the `" // "` separator, then fills the locale body's placeholders:

```lua
-- Composed: {marker} {ADDON_TITLE} // {body}
ns.TARGET_MARKER .. " " .. L["ADDON_TITLE"] .. " // " .. string.format(template, ...)
```

So each locale's `MSG_FORMAT` is the **body only** — seven positional `%s`, filled by `AnnounceNode` in this fixed order: role, prefix/article, node name, action verb, x coord, y coord, zone name.

```lua
-- L["MSG_FORMAT"] (enUS) — body only, no marker or name
"Hey %s, I came across %s %s that I can't %s at %s, %s in %s!"
```

Produces, e.g.:

> {rt7} Come & Get It // Hey Miners, I came across a Rich Thorium Vein that I can't mine at 25, 54 in Eastern Plaguelands!

Two non-obvious rules govern this:

- **The marker lives only in `ns.TARGET_MARKER` (`Data.lua`).** It is applied at send time by `BuildAnnounceMessage`, never baked into a locale body. A locale that re-adds the marker or name double-prefixes.
- **Placeholder order is coupled across all locales.** A translation may reorder the *sentence* (German moves the coordinates into a trailing parenthetical) but must keep the seven `%s` in the same logical order the code passes them, in the same count and type. Reordering placeholders without matching the call site garbles output; a `%s`/`%d` mismatch crashes at runtime.

`BuildAnnounceMessage` also strips stray pipes (`|`) from the finished body — safe here because announcement bodies never carry item links — and returns nil if the format key is missing, which `AnnounceNode` treats as "say nothing."

## Output Channels

`ns.OUTPUT_CHANNELS` (`Data/Data.lua`) is the single source of truth for where a draft can be addressed. Each row pairs a stable saved key with the slash command and a locale label key:

```lua
{ key = "channel1", command = "/1", labelKey = "OPTIONS_OUTPUT_CHANNEL1" }
```

Two derived lookups trace back to it so the list, its order, and the command mapping can never drift:

- `Core.lua` builds `OUTPUT_COMMAND` (`key → command`) for the write step.
- `Options-General.lua` builds the dropdown's `values`/`sorting` from the same manifest, labels localized at display time.

The chosen key is saved to `ns.db.profile.defaultOutput`; array order is dropdown order. Adding a channel is one row here plus its `OPTIONS_OUTPUT_*` locale string. Local (`/1`) is the zone General channel — layer-specific in Classic, which the option's note string calls out.

## Diagnostics Panel

`Features/Diagnostics.lua` + `Options/Options-Diagnostics.lua` are the verbatim canonical diagnostics framework (from Open-Sesame), re-authored only where the manifests are add-on-specific. Design constraints:

- **Opt-in and runtime-only.** `ns.diagnostics = { enabled, logging, log }` is a plain namespace table, **not** a SavedVariable — it resets every session. A single toggle (`ns:SetDiagnosticsEnabled`) gates the whole panel; turning it off also calls `ns:StopEventLog`. Every section below the toggle is an inline widget with a `hidden` function, since header widgets don't honor `hidden` directly.
- **Read-only by contract.** Reports build only on a button press, never on load or panel open. The sole state any button writes is the **Taint Log** CVar (`taintLog`, `2`/off `0`).
- **Event-log tap.** `ns:LogEvent` (driven by Core's dispatcher) snapshots arguments to strings *immediately* — never retaining frame/table references that would leak or go stale — caps at 8 args and 255 bytes each, escapes pipes (`|` → `||`) **after** the length cut, and keeps a 500-entry ring buffer. `ns.DIAGNOSTIC_EVENT_EXCLUDE` pre-filters firehose events (defensive — the add-on registers none today).
- **Live detection context.** `BuildContextReport` prints *actual values* (resolved `mapID`, position, zone, plus the instance/combat gates and the match strings) rather than existence checks, because that is what explains a "nothing happened" report.
- **Single sources of truth.** Event checks iterate `ns.EVENT_NAMES` (from Core); API checks iterate `ns.DIAGNOSTIC_API_CHECKS`. Neither list is duplicated.
- **Strings are not localized.** All diagnostics UI text lives in `ns.DiagnosticsStrings` as plain English. The one localized value used here is the add-on's own display name (`L["ADDON_TITLE"]`), which is identity, not diagnostics copy.

## Saved Variables

A single account-wide `SavedVariables` table, `ComeAndGetItDB`, declared in the `.toc` and managed by **AceDB-3.0**. Every user setting lives under the active profile:

| Field (`ns.db.profile`) | Type | Default | Holds |
| --- | --- | --- | --- |
| `showWelcome` | boolean | `true` | Whether `PrintWelcome` prints the version/settings line on login |
| `defaultOutput` | string | `"channel1"` | Which `ns.OUTPUT_CHANNELS` key the draft is addressed to |

`ns.db.global` is reserved for a minimap-button position and is unused here — this add-on has no minimap button. The database is created in `InitSavedVariables` (`Features/Core.lua`) on `PLAYER_LOGIN`:

```lua
ns.db = LibStub("AceDB-3.0"):New("ComeAndGetItDB", ns.DATABASE_DEFAULTS, true)
```

The third argument (`true`) puts every character on one shared "Default" profile; per-character profiles are opt-in through the stock Profiles panel (`Options/Options-Profiles.lua`).

### Migration Chain

- **`MigrateFlatKeys`** (inline in `InitSavedVariables`, tagged `MIGRATION (remove after 2026-10-08)`) — pre-AceDB builds stored `showWelcome` / `defaultOutput` at the root of `ComeAndGetItDB`. On first login it lifts any such root value into `ns.db.profile` and clears the root key, then AceDB owns it. Delete this block (no legacy TOC entry to drop) once the window closes.

Defaults come from `ns.DATABASE_DEFAULTS` and are applied lazily by AceDB-3.0 via metatables — nothing is copied into the saved table, and explicit user values (including `false`) are never overridden.

There are no default item/spell lists, so there is no refill-on-empty logic.

## Adding a New Tracked Node Type

To support a new gatherable/openable the player can't use:

1. **Identify the trigger.** If the client fires a *stable numeric* UI error ID, add it as a constant in `Data/Data.lua` (mirroring `ns.ERROR_ID_LOCKED_CHEST = 268`). If it fires only a localized *"Requires &lt;Skill&gt;"* string, you'll match a localized substring instead — no constant needed.
2. **Add an `ERROR_MAPPING` entry** in `Features/Core.lua`, keyed by the numeric ID (fast path) **or** by `L["MATCH_…"]` (substring path), with `role`, `prefix`, and `action`. (There is no `defaultNode`; a missing node name means the callout is skipped.)
3. **Add every referenced `L` key** to `Locales/enUS.lua` first: the role, prefix/article, action verb, and the `MATCH_…` skill string if you matched by substring. The Localization pass translates the rest.
4. **Keep the key namespaces disjoint** — numeric keys take the fast path, string keys are lowercased and substring-scanned. Never reuse a number as a string key.
5. **Watch the line length.** The composed announcement is a chat message, so the ceiling is the **255-byte chat line**. Verbose locales (German is the canary) plus a long node and zone name can approach it — sanity-check the longest case.

## Adding a New Setting

1. Add the default under `profile` in `ns.DATABASE_DEFAULTS` (`Data/Default-Settings.lua`); AceDB applies it lazily.
2. Add a widget to `BuildGeneralOptions()` in `Options/Options-General.lua` whose `get`/`set` read and write `ns.db.profile.<key>`. Guard the `get` with `ns.db and …`, since the panel can build before the database exists.
3. Add the `name`/`desc` `L` keys to `Locales/enUS.lua`.

## Adding a New Diagnostic Report

1. Add a `ns:BuildXxxReport()` builder in `Features/Diagnostics.lua` that returns a string and starts from `GetClientHeader()`. Keep it read-only and side-effect free.
2. Add the `TITLE`/`BUTTON` text to `ns.DiagnosticsStrings` as plain English (these are **not** localized).
3. In `Options/Options-Diagnostics.lua`, add a gated `SectionHeader`, an `execute` button that stores into `ns.diagnostics.xxxReport` and calls `Refresh()`, and a `ReportOutput("xxxReport", order)`.

## Adding a Registered Event

Append the event name to `ns.EVENT_NAMES` in `Features/Core.lua` and handle it in the `OnEvent` dispatcher. Registering it anywhere else means Diagnostics' registration check and event log silently miss it. If the new event is a firehose (fires many times per second), add it to `ns.DIAGNOSTIC_EVENT_EXCLUDE` so it doesn't bury the event log.

## Localization

- **Structure** — locale files live in `Locales/<locale>.lua`, each registered through AceLocale-3.0's `NewLocale`. `enUS.lua` is the source of truth and the only file that passes the `true` default-fallback flag; every string originates there. Each other locale is a standalone file translating the same key set (esES and esMX included — neither shares a table with the other).
- **Keeping locales in sync** — AceLocale falls back to English via `__index` for anything missing at runtime. Translating each `enUS.lua` key into every locale and keeping the files aligned is the job of the Localization pass (`3 - Copy Cleanup & Localization Prompt.md`); don't hand-edit the other locales during ordinary work. When you add or rename a key, add it to `enUS.lua` and every code reference in the same change.
- **Placeholders** — `%s`/`%d` count, type, and order must match `enUS` per key in every locale, or the string crashes at runtime. `MSG_FORMAT`'s seven `%s` are the critical case; an in-file comment block documents their order for translators.
- **Spanish** — esES/esMX are two separate, self-contained files; identical Spanish in both is correct and expected.
- **Locale overflow** — German is the usual canary against the 255-byte chat-line ceiling; check the longest composed `MSG_FORMAT` there.

## Common Pitfalls

- **Announcing in combat**: `ChatFrame_OpenChat` steals keyboard focus and breaks movement. `AnnounceNode` deliberately *drops* the announcement when `InCombatLockdown()` is true — don't "fix" it into a deferred queue.
- **`Announcements.lua` is misnamed**: it holds only the messaging helpers (`PrintMessage`, `PrintWelcome`, `BuildAnnounceMessage`). The node-announce logic is `AnnounceNode` in `Core.lua`. Look in Core when changing announcement behavior.
- **Baking the marker into a locale string**: the target marker lives only in `ns.TARGET_MARKER` and is applied by `BuildAnnounceMessage`. A `MSG_FORMAT` (or any body) that includes `{rt7}` or the add-on name double-prefixes the sent line.
- **Reordering `%s` in a locale's `MSG_FORMAT`**: argument order is fixed by the `AnnounceNode` call site across all locales. Reorder the sentence freely, but not the placeholders.
- **Bag lockboxes**: a locked lockbox in the player's own bags fires the same error (`268`) as a world chest. `AnnounceNode` suppresses it via `TooltipShowsItem`; don't remove that gate or it will call out inventory items with world coordinates.
- **Registering an event outside `EVENT_NAMES`**: calling `RegisterEvent` directly means Diagnostics' registration check and event log silently miss it. Always append to `ns.EVENT_NAMES` in `Core.lua`.
- **Registering options panels at file scope**: the Profiles panel is built from `AceDBOptions:GetOptionsTable(ns.db)`, so it needs the database. `Options.lua` only *defines* `ns.RegisterOptionsPanels()`; Core calls it after `ns.db` exists. Registering at file scope errors.
- **Assuming `C_Map` exists**: it is nil on early Classic builds. Use the file-scope aliases and bail like `AnnounceNode` does; don't call `C_Map.*` unguarded.
- **Putting diagnostics text in `Locales/`**: diagnostics strings are intentionally English-only and live in `ns.DiagnosticsStrings`. Locale files are for player-facing copy only.
- **Treating `ns.diagnostics` as persistent**: it is runtime-only and resets each session. Only `ComeAndGetItDB` survives a reload.

## Contributing

- **Issues**: open them on the [GitHub Issues tab](https://github.com/Gogo1951/Come-and-Get-It/issues).
- **Bug reports** should include: game version + locale, character class + level, repro steps, and the relevant chat output — ideally the drafted announcement line, or a **Detection Context** report from the Diagnostics panel.
- **Discord**: [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **Pull requests**:
  - Keep each PR scoped to one change. Match the surrounding code style (vararg namespace modules, `--` section banners, present-tense intent comments).
  - Respect load order and the single-source-of-truth tables (`EVENT_NAMES`, `ERROR_MAPPING`, `OUTPUT_CHANNELS`, `DiagnosticsStrings`).
  - If you change `MSG_FORMAT` or any locale string, verify the longest composed line stays within the **255-byte chat limit** (German is the canary) and keep the seven `%s` order intact.
  - Saved-variable discipline: add settings as `ns.DATABASE_DEFAULTS.profile` defaults; any table/key reshape gets a dated `MIGRATION (remove after …)` block, never a rewrite of existing user values.
  - Update this document if the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X." Frame it as who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player who got pulled into combat the instant I clicked a vein, I wanted Come & Get It to stay silent during a fight so the chat box wouldn't steal my movement keys. This change drops the announcement when `InCombatLockdown()` is true rather than queuing it for later.*
