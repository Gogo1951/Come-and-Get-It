# Come & Get It — Technical Reference

This document combines architecture notes and contribution guidance for developers working on Come & Get It. For end-user documentation, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md).

## File Map

```
ComeAndGetIt/
├── ComeAndGetIt.toc                # Load manifest: Interface versions, SavedVariables, file order
├── README.md                       # Player-facing documentation
├── README-Technical.md             # This document
├── Data/
│   ├── Data.lua                    # Constants: locked-chest error ID, cooldown, target marker, URLs,
│   │                               #   options-registry names, raw hex color palette, Version resolver
│   └── Default-Settings.lua        # DEFAULT_CONFIGURATION — the additive-merge source for ComeAndGetItDB
├── Features/
│   ├── Core.lua                    # Event frame + dispatcher, error→mapping match, announcement
│   │                               #   composition (AnnounceNode), saved-variable init
│   ├── Utilities.lua               # Derived COLORS table + GetColor accessor (logic for Data.lua's palette)
│   ├── Announcements.lua           # Chat PRINT helpers (PrintMessage, PrintWelcome) — NOT the node-announce
│   │                               #   logic; that lives in Core.lua. Name is a known footgun.
│   └── Diagnostics.lua             # Opt-in developer report builders, event-log tap, taint-log toggle
├── Options/
│   ├── Options-Utilities.lua       # Shared AceConfig widget builders (OptionsHeader/Desc/Spacer)
│   ├── Options-General.lua         # General panel: welcome toggle, feedback links, version line
│   ├── Options-Diagnostics.lua     # Diagnostics panel: single gate toggle + gated report buttons
│   └── Options.lua                 # Registers both panels into Blizzard options (loads last)
├── Locales/
│   ├── enUS.lua                    # Default locale (NewLocale(..., true)); the canonical key set
│   ├── esMX.lua                    # Canonical Spanish: shared `strings` table, registers BOTH esES + esMX
│   ├── esES.lua                    # DEAD — partial legacy duplicate; loads before esMX.lua and is fully
│   │                               #   overwritten by it. Do not add strings here (see Common Pitfalls).
│   ├── deDE.lua                    # German translation (the locale-overflow canary)
│   └── frFR / itIT / koKR / ptBR / ruRU / zhCN / zhTW .lua   # Translations
└── Includes/
    ├── Images/Come-And-Get-It.tga  # Addon icon (## IconTexture)
    └── Libraries/                  # Bundled Ace3 stack: LibStub, CallbackHandler-1.0, AceLocale-3.0,
                                    #   AceGUI-3.0, AceConfig-3.0 (+ Registry/Cmd/Dialog)
```

## Architecture

### Module Layout & Load Order

Every file is a vararg module: `local _, namespace = ...` (some use `ns`). All files share the one table WoW passes as the second vararg, so there is no global namespace beyond `ComeAndGetItDB` and the addon's `_G` event frame. Load order in `ComeAndGetIt.toc` is load-bearing:

1. **Libraries** — LibStub through AceConfig, so `AceLocale` exists before any locale registers.
2. **Locales** — `enUS.lua` first (it owns the `true` default flag); the rest fill their own client locale.
3. **Data** — `Data.lua` resolves `namespace.L` (the active AceLocale table) and publishes constants; `Default-Settings.lua` publishes `DEFAULT_CONFIGURATION`.
4. **Features then Options** — Core wires events; Utilities/Announcements/Diagnostics add helpers; `Options.lua` registers panels last, after every builder it references exists.

Anything that reads `namespace.L` or a constant must load *after* `Data/Data.lua`. Options must load after the feature files whose functions they call.

### Event Loop

Core.lua creates a single hidden `Frame` and registers exactly the events listed in `namespace.EVENT_NAMES`:

```lua
namespace.EVENT_NAMES = { "PLAYER_LOGIN", "UI_ERROR_MESSAGE" }
```

The `OnEvent` handler is the only dispatcher. It runs three things in order:

1. **Diagnostics tap** — if `namespace.diagnostics.logging` is true, `namespace:LogEvent(event, ...)` records the event before anything else. The boolean guard makes the tap free when logging is off.
2. **`PLAYER_LOGIN`** — `InitSavedVariables()` then `PrintWelcome()`.
3. **`UI_ERROR_MESSAGE`** — `MatchError(messageID, message)` → if a mapping is found, `AnnounceNode(mapping)`.

`EVENT_NAMES` is exported and reused by Diagnostics' registration check, so the probe can never drift from what the dispatcher actually registers. Add events by appending to this table, never by calling `RegisterEvent` ad hoc.

### Combat Lockdown

`AnnounceNode` returns immediately if `InCombatLockdown()` is true. This is **intentional and load-bearing, not a missing feature**: the write step calls `ChatFrame_OpenChat`, which steals keyboard focus and breaks WASD movement mid-fight. The announcement is *dropped*, not queued — a stale node callout after combat ends is noise, and the node re-fires its `UI_ERROR_MESSAGE` on the next interaction once combat drops. Do not replace this with a deferred-replay queue.

### Detect → Compose → Write

The announcement pipeline is the addon's core flow, all in `Features/Core.lua`.

**Detect — `MatchError(messageID, message)`** uses a two-key strategy against one `ERROR_MAPPING` table:

- **Fast path (numeric):** locked chests fire a stable Blizzard error ID (`ERROR_ID_LOCKED_CHEST = 268`), looked up directly as `ERROR_MAPPING[messageID]`.
- **Slow path (string):** herb/mine nodes fire a generic localized *"Requires &lt;Skill&gt;"* message with no stable ID, so the lowercased message is substring-scanned against the localized skill names (`L["MATCH_HERB"]`, `L["MATCH_MINE"]`).

The two key kinds share one table but occupy disjoint namespaces (integers vs. strings); `MatchError` checks the integer key first, then iterates string keys only on miss.

**Compose — `AnnounceNode(mapping)`** runs cheap suppression gates first, then gathers data:

1. Gates, in order: `IsInInstance()` → `InCombatLockdown()` → cooldown (`GetTime() - lastAnnounceTime < ANNOUNCE_COOLDOWN`, 5s) → C_Map availability.
2. Node name from `GameTooltipTextLeft1:GetText()`, falling back to `mapping.defaultNode`.
3. Position and zone from the guarded `C_Map` chain (see below).
4. English-only article fix: `"a"` → `"an"` before a vowel-initial node name (`enUS`/`enGB` only).
5. Builds the line with `string.format(L["MSG_FORMAT"], ...)`.

**Write** opens — never sends — the chat editbox, pre-filled on the General channel:

```lua
ChatFrame_OpenChat("/1 " .. announcement, ChatFrame1)
lastAnnounceTime = now
```

A guard skips the write entirely if `ChatEdit_GetActiveWindow()` reports the player is already typing, so a draft in progress is never clobbered. `lastAnnounceTime` is stamped only after a successful open.

### Cross-Client API Guards

One codebase ships against four flavors (`## Interface: 11508, 20505, 50504, 120007` — Classic Era, TBC, MoP Classic, Retail). Capabilities that differ across flavors are resolved once, defensively:

- **`C_Map`** may be entirely absent on the earliest Classic builds. `Core.lua` aliases the three needed functions at file scope (`GetBestMapForUnit`, `GetPlayerMapPosition`, `GetMapInfo`) and `AnnounceNode` bails if any alias is nil — no hard dependency, no error.
- **`C_AddOns.GetAddOnMetadata`** vs. the legacy global `GetAddOnMetadata`: `Data.lua`'s `GetVersion` and `Diagnostics.lua` both pick `(C_AddOns and C_AddOns.X) or X`.
- **`C_EventUtils.IsEventValid`** exists only on newer clients; the diagnostics event check degrades to `"n/a"` when absent.

`Diagnostics.lua`'s API-endpoint report (`ns.DIAGNOSTIC_API_CHECKS`) lists the modern and legacy forms separately so a bug report shows exactly what a given client provides.

### Color System

`Data/Data.lua` holds the **raw hex palette only** (`C_TITLE`, `C_INFO`, …) because Data files carry no logic. `Features/Utilities.lua` derives the `COLORS` table (prefixing each with `|cff`) and exposes `namespace.GetColor(key)`, which returns the escape string; callers append the closing `|r` at the point of use. `GetColor` falls back to `TEXT` for an unknown key.

## Announcement Message Format

The sent line is assembled from a single per-locale format string with **seven positional `%s`**, filled in this fixed order by `AnnounceNode`:

```lua
-- L["MSG_FORMAT"] (enUS)
"{rt7} Come & Get It // Hey %s, I came across %s %s that I can't %s at %s, %s in %s!"
--          role ┘            │  │           │            │   │      │
--        prefix/article ─────┘  │           │            │   │      │
--        node name ─────────────┘           │            │   │      │
--        action verb ──────────────────────┘            │   │      │
--        x, y coords ──────────────────────────────────┘───┘      │
--        zone name ──────────────────────────────────────────────┘
```

Produces, e.g.:

> {rt7} Come & Get It // Hey Miners, I came across a Rich Thorium Vein that I can't mine at 25, 54 in Eastern Plaguelands!

Two non-obvious rules govern this string:

- **The `{rt7}` raid marker is baked into every locale's `MSG_FORMAT` prefix.** `Data.lua` also defines `namespace.TARGET_MARKER = "{rt7}"` as the canonical value, but nothing substitutes it at runtime today — the marker is hard-coded into each translated body. Treat `TARGET_MARKER` as the source of truth and keep all `MSG_FORMAT` bodies in sync with it; changing one place without the others double-prefixes or drifts non-English clients.
- **Argument order is coupled across all locales.** A translation may reorder the *sentence* (German moves the coordinates into a trailing parenthetical) but must keep the seven `%s` in the same logical order the code passes them. Reordering placeholders without matching the call site garbles output.

## Diagnostics Panel

`Features/Diagnostics.lua` + `Options/Options-Diagnostics.lua` provide an opt-in, developer-facing troubleshooting surface. Design constraints:

- **Opt-in and runtime-only.** `ns.diagnostics = { enabled, logging, log }` is a plain namespace table, **not** a SavedVariable — it resets every session. A single toggle (`ns:SetDiagnosticsEnabled`) gates the whole panel; turning it off also calls `ns:StopEventLog`. Every section below the toggle is an inline widget with a `hidden` function, since header widgets don't honor `hidden` directly.
- **Read-only by contract.** Reports build only on a button press and never on load or panel open. The sole state any button writes is the **Taint Log** CVar (`taintLog`, set to `2`/off `0`) — called out explicitly because it is the one exception.
- **Event-log tap.** `ns:LogEvent` (driven by Core's dispatcher) snapshots arguments to strings *immediately* — never retaining frame/table references that would leak or go stale — caps at 8 args and 255 bytes each, escapes pipes (`|` → `||`) **after** the length cut so values render verbatim instead of as clickable swatches and a truncation can't strip a separator, and keeps a 500-entry ring buffer. `ns.DIAGNOSTIC_EVENT_EXCLUDE` pre-filters firehose events (defensive — the addon registers none today).
- **Live detection context.** `BuildContextReport` prints *actual values* (resolved `mapID`, position, zone, plus the instance/combat gates) rather than existence checks, because that is what explains a "nothing happened" report.
- **Single sources of truth.** Event checks iterate `ns.EVENT_NAMES` (from Core); API checks iterate `ns.DIAGNOSTIC_API_CHECKS`. Neither list is duplicated.
- **Strings are not localized.** All diagnostics UI text lives in `ns.DiagnosticsStrings` as plain English, in the diagnostics files only — translating developer text is wasted effort. The one localized value used here is the addon's own display name (`L["ADDON_TITLE"]`), which is identity, not diagnostics copy.

## Saved Variables

A single `SavedVariables` table, `ComeAndGetItDB`, declared in the `.toc`. It is intentionally flat — one top-level key per setting:

| Field | Type | Default | Holds |
| --- | --- | --- | --- |
| `showWelcome` | boolean | `true` | Whether `PrintWelcome` prints the version/settings line on login |

Defaults live in `namespace.DEFAULT_CONFIGURATION` (`Data/Default-Settings.lua`). `InitSavedVariables` (`Features/Core.lua`) runs on `PLAYER_LOGIN` and performs an **additive merge**: it creates the table if missing, then fills only the keys that are `nil`.

There is no migration chain today. When one is added, run migrations *before* the additive merge and document each step here in version order.

> `InitSavedVariables` is the merge step: it runs on `PLAYER_LOGIN`, only fills `nil` fields, and never overrides explicit user values.

## Adding a New Tracked Node Type

To support a new gatherable/openable that the player can't use:

1. **Identify the trigger.** If the client fires a *stable numeric* UI error ID, add it as a constant in `Data/Data.lua` (mirroring `ERROR_ID_LOCKED_CHEST = 268`). If it fires only a localized *"Requires &lt;Skill&gt;"* string, you'll match a localized substring instead — no constant needed.
2. **Add an `ERROR_MAPPING` entry** in `Features/Core.lua`, keyed by the numeric ID (fast path) **or** by `L["MATCH_…"]` (substring path), with `role`, `prefix`, `defaultNode`, and `action`.
3. **Add every referenced `L` key** to `Locales/enUS.lua` first, then all other locales: the role, prefix/article, default node name, action verb, and the `MATCH_…` skill string if you matched by substring.
4. **Keep the key namespaces disjoint** — numeric keys take the fast path, string keys are lowercased and substring-scanned. Never reuse a number as a string key.
5. **Watch the line length.** The composed announcement is a chat message, not a macro, so the relevant ceiling is the **255-byte chat line**. Verbose locales (German is the canary) plus a long node and zone name can approach it — sanity-check the longest case.

## Adding a New Setting

1. Add the default to `namespace.DEFAULT_CONFIGURATION` in `Data/Default-Settings.lua`; the additive merge fills it on the next login.
2. Add a widget to `BuildGeneralOptions()` in `Options/Options-General.lua` whose `get`/`set` read and write `ComeAndGetItDB.<key>`. Guard the `get` with `ComeAndGetItDB and …`, since the panel can build before `PLAYER_LOGIN` has initialized the table.
3. Add the `name`/`desc` `L` keys to every locale.

## Adding a New Diagnostic Report

1. Add a `ns:BuildXxxReport()` builder in `Features/Diagnostics.lua` that returns a string and starts from `GetClientHeader()`. Keep it read-only and side-effect free.
2. Add the `TITLE`/`BUTTON` text to `ns.DiagnosticsStrings` as plain English (these are **not** localized).
3. In `Options/Options-Diagnostics.lua`, add a gated `SectionHeader`, an `execute` button that stores into `ns.diagnostics.xxxReport` and calls `Refresh()`, and a `ReportOutput("xxxReport", order)`.

## Adding a New Locale

Copy `Locales/enUS.lua` to `Locales/<locale>.lua`. Drop the `true` argument from `NewLocale("ComeAndGetIt", "<locale>", true)` — that flag marks the default fallback; only `enUS.lua` should set it. Translate every string. Add the file to the `.toc` immediately after `Locales/enUS.lua`.

For **Spanish**, follow the shared-`strings`-table pattern in `Locales/esMX.lua`: build one local `strings` table, then register it into both `esES` and `esMX` (`for k, v in pairs(strings) do L[k] = v end` for each). This serves both Spanish clients from one source. Do **not** add strings to `Locales/esES.lua` — it is a legacy partial that loads first and is overwritten by `esMX.lua` (see Common Pitfalls); fold any Spanish change into `esMX.lua` instead.

When translating `MSG_FORMAT`, preserve the seven positional `%s` in the logical order the code fills them (see *Announcement Message Format*) and keep the `{rt7}` marker in the prefix.

## Common Pitfalls

- **Announcing in combat**: `ChatFrame_OpenChat` steals keyboard focus and breaks movement. `AnnounceNode` deliberately *drops* the announcement when `InCombatLockdown()` is true — don't "fix" it into a deferred queue.
- **`Announcements.lua` is misnamed**: it holds only the chat-print helpers (`PrintMessage`, `PrintWelcome`). The actual node-announce logic is `AnnounceNode` in `Core.lua`. Look in Core when changing announcement behavior.
- **Editing the `{rt7}` marker in one place**: the marker is hard-coded into every locale's `MSG_FORMAT` *and* mirrored in `namespace.TARGET_MARKER`. Change them together or non-English clients double-prefix.
- **Reordering `%s` in a locale's `MSG_FORMAT`**: argument order is fixed by the `AnnounceNode` call site across all locales. Reorder the sentence freely, but not the placeholders.
- **Adding Spanish strings to `esES.lua`**: that file is dead — `esMX.lua` registers both `esES` and `esMX` and loads after it, silently overwriting anything in `esES.lua`. Put Spanish strings in `esMX.lua`'s shared `strings` table.
- **Registering an event outside `EVENT_NAMES`**: calling `RegisterEvent` directly means Diagnostics' registration check and event log silently miss it. Always append to `namespace.EVENT_NAMES` in `Core.lua`.
- **Assuming `C_Map` exists**: it is nil on early Classic builds. Use the file-scope aliases and bail like `AnnounceNode` does; don't call `C_Map.*` unguarded.
- **Putting diagnostics text in `Locales/`**: diagnostics strings are intentionally English-only and live in `ns.DiagnosticsStrings`. Locale files are for player-facing copy only.
- **Treating `ns.diagnostics` as persistent**: it is runtime-only and resets each session. Only `ComeAndGetItDB` survives a reload.

## Contributing

- **Issues**: open them on the [GitHub Issues tab](https://github.com/Gogo1951/Come-and-Get-It/issues).
- **Bug reports** should include: game version + locale, character class + level, repro steps, and the relevant chat output — ideally the drafted announcement line, or a **Detection Context** report from the Diagnostics panel.
- **Discord**: [discord.gg/eh8hKq992Q](https://discord.gg/eh8hKq992Q).
- **Pull requests**:
  - Keep each PR scoped to one change. Match the surrounding code style (vararg namespace modules, `--` section banners, present-tense intent comments).
  - Respect load order and the single-source-of-truth tables (`EVENT_NAMES`, `ERROR_MAPPING`, `DiagnosticsStrings`).
  - If you change `MSG_FORMAT` or any locale string, verify the longest composed line stays within the **255-byte chat limit** (German is the canary) and keep the seven `%s` order intact.
  - Migration discipline: add new settings as `DEFAULT_CONFIGURATION` defaults (additive merge), never by rewriting existing user values.
  - Update this document if the architecture or file map changes.
- **Commit and PR descriptions require a User Story.** Don't just say "I changed X." Frame it as who it helps and why:

  **Format:** *As a [role], I [needed / wanted] [behavior] so that [outcome]. This change [does X].*

  **Example:** *As a player who got pulled into combat the instant I clicked a vein, I wanted Come & Get It to stay silent during a fight so the chat box wouldn't steal my movement keys. This change drops the announcement when `InCombatLockdown()` is true rather than queuing it for later.*
