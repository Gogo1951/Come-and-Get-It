# Come & Get It — Manual Test Plan

This is the manual test plan for Come & Get It — the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README-Technical.md).

## How to run this plan

Run the whole list on Classic Era, then again on TBC Anniversary. Do a `/reload` before starting each flavor.

Work top to bottom. Every step tells you exactly what to do, what you should see, and what failure looks like — if a step doesn't match its expected result, it failed. Steps are numbered continuously from 1 to 63 across the whole document, so a bug report only needs "failed on step N."

Some steps behave differently on the two clients and say so in the step itself. Those are not optional on either flavor — the one a step warns about is precisely the one where it earns its keep. **A run on only one flavor is not a completed run.**

## Before you start

Gather these once so you aren't caught short mid-run:

- **Both flavors installed** — Classic Era and TBC Anniversary. The add-on ships for both and both must be tested.
- **A character with neither Herbalism nor Mining.** This is the single most important fixture — the add-on only reacts when you *fail* to gather. Any class works; the add-on has no class-specific behavior. If your main has both professions, use a bank alt or a low-level character.
- **Somewhere with herb nodes and ore veins nearby.** Any starting or low-level zone works — Peacebloom, Silverleaf, and Copper Veins are dense in Elwynn Forest, Durotar, and Teldrassil.
- **A locked treasure chest in the world**, on a character with no lockpicking and no key. Battered/Tattered chests along the Wetlands and Hillsbrad coastlines are reliable.
- **A locked lockbox in your bags** (a Battered or Worn Lockbox, common from fishing and humanoid drops). One step uses it as a negative test — it must *not* produce an announcement.
- **A dungeon or raid entrance you can zone into**, for the instance-suppression step.
- **Something to fight** — any open-world mob, for the combat-suppression step.
- **A second player is optional.** Every draft step works solo, because the add-on never sends on its own. You only need a partner if you want to watch a Party-channel line actually land.
- **A non-English client** — only for the optional localization spot-check in steps 59–63.

Unless a step says otherwise, be **out of combat and out of instances**, standing in the open world.

## Verify this release's changes

These are the changes in this build, each tied to a test that watches it work. This list was built by comparing the working copy against the last shipped build (2026.07.18.A) — not from a changelog, which dev copies don't carry.

**Announcement sentence rebuilt**

The announcement used to be assembled from fragments — a role word, an article, a verb, and a sentence skeleton stitched together at send time. It is now three complete sentences, one per node type, each filled with four values in a fixed order: node name, x, y, zone. Every one of the eleven locales was rewritten to match.

**1.** On a character without Herbalism, right-click an herb node. The draft in your chat box must read as one complete sentence in this exact shape:

> `{rt7} Come & Get It // Hey Herbalists, I came across something I can't pick: Peacebloom at 42, 68 in Elwynn Forest!`

The node name, both coordinates, and the zone must all be filled in. Failure looks like a missing or duplicated word, a stray `%s` left in the text, the word `nil` anywhere, or two add-on names in one line.

**2.** Repeat on an ore vein with a character without Mining. The sentence must say **"Hey Miners"** and **"I can't mine"**, and name the vein. Failure is the wrong audience or the wrong verb — a vein addressed to Herbalists means the two node types are crossed.

**3.** Repeat on a locked world chest. The sentence must say **"Hey Rogues"** and **"I can't open"**. Failure is the wrong audience or verb, as above.

**4.** Find a node whose name starts with a vowel — Iron Deposit, Arcane Crystal, Earthroot. The sentence must place the node name directly after the colon with **no article in front of it**: `...I can't mine: Iron Deposit at...`. Failure is a leftover article — `a Iron Deposit` or `an Iron Deposit` — which means an old fragment survived the rewrite.

**Over-length chat warning**

New in this build: the add-on now measures the draft and warns you when it won't fit.

**5.** Trigger any announcement in a zone with a long name while playing on a locale with long node names. If the finished line exceeds 255 bytes, a message must print in your chat frame reading *"This announcement is N bytes, over the 255-byte chat limit. Shorten it before sending."* The draft must still open **in full and untrimmed** so you can edit it down yourself. Failure is a silently truncated draft, a draft cut off mid-word, or no warning at all on a line you can count past 255. On an English client most lines fit comfortably — if you can't produce an overflow naturally, confirm instead that **no** warning appears on a normal-length announcement, and check this properly during the localization pass at step 62.

**Tooltip guard**

**6.** Mouse over an herb node so its tooltip appears, then move your cursor **off** it so the tooltip disappears, and immediately right-click the node again. Either you get a correct draft naming that node, or you get nothing at all. Failure is a draft naming **a different object** — the last thing your tooltip happened to show — which means the add-on read a stale tooltip.

**Suppression gate ordering**

**7.** Pull a mob, and while still in combat right-click an herb or vein you can't gather. **Nothing must happen** — no chat box opening, no draft, no error. Then kill the mob, leave combat, and stand still without touching the node. **No delayed draft may appear.** Failure is either the chat box stealing your keys mid-fight, or a stale announcement popping up seconds after the fight ends — announcements in combat are dropped on purpose, never queued.

**Live panel refresh on profile change**

New in this build: changing profiles now repaints an options panel that's already on screen, instead of leaving it showing stale values until a reload.

**8.** Open Options → AddOns → Come & Get It. Change **Default Output** to Yell and untick **Enable Welcome Message**. Now click **Profiles** in the list on the left, then **Reset Profile**. Click back to the Come & Get It panel. Default Output must read **Local (/1)** and the welcome toggle must be **ticked** again. Failure is the panel still showing Yell and an unticked box — that means the refresh hook isn't firing and the reset only *looks* like it did nothing.

**9.** Still in the Profiles panel, create a new profile named `Test`, then switch back to `Default`, without reloading. The General panel's values must follow whichever profile is active each time you look at it. Failure is values frozen from whichever profile was active when you first opened the window.

**Saved-variable cleanup**

**10.** Open Options → AddOns → Come & Get It → **Diagnostic Tools**, tick **Enable Diagnostic Tools**, then click **Dump Saved Variables**. Read the output. There must be **no `announceOnClick` key** anywhere in it — that setting was removed and is now swept out of every stored profile at login. Failure is `announceOnClick` still listed under any profile.

**11.** In that same dump, check whether a **`global`** section exists. Everything this add-on saves belongs under `profiles`. If you had previously turned the welcome message **off** and it has come **back on** by itself in this build, look for `showWelcome` sitting under `global` — your old choice is parked in a scope the login cleanup doesn't read. Failure is exactly that: a `showWelcome` value under `global` that the add-on is ignoring, while the welcome message you disabled reappears at login.

**Packaging surfaces**

**12.** Open Options → AddOns → Come & Get It and read the last line of the panel. It must show a version. In an unpackaged working copy it correctly reads **"Version Dev"**; in a packaged release build it must read a real dated version. Failure is a literal `@project-version@` on screen in a release build.

**13.** Open the character-select or in-game **AddOns** list and find Come & Get It. Its icon must render — the small Come & Get It artwork, not a blank square or a question mark. Failure is a missing icon, which means the icon path in the TOC doesn't match the file that shipped.

When steps 1–13 pass on both flavors, this release's changes are verified — proceed to `4 - Pre-Launch Review Prompt.md`.

## Loading and the settings panel

**14.** Log in with the add-on enabled. No Lua error window may appear, and no red error text may print in chat. Failure is any error popup naming Come & Get It, or the add-on missing from the AddOns list entirely.

**15.** Watch your chat frame at login. A welcome line must print, coloured, in the shape *"Come & Get It // Version …"*, telling you where the settings live. Failure is no message, an uncoloured line, or a line with `nil` in it.

**16.** Press `Esc`, choose **Options**, then **AddOns**, and select **Come & Get It**. The settings must appear **docked inside the Blizzard Options window**, with the add-on selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **This step is flavor-sensitive — TBC Anniversary is the client where the panel has historically floated free, so this step must be run there and not just on Era.** The add-on has no slash command and no minimap button; the Options window is the only way in, which is why this step matters more here than in most add-ons.

**17.** With Come & Get It selected, look at the category list. Three entries must be reachable and must open without error: the main **Come & Get It** panel, **Profiles**, and **Diagnostic Tools**, in that order. Failure is a missing entry, an entry that opens blank, or an entry nested under the wrong parent.

**18.** On the main panel, untick **Enable Welcome Message**, then type `/reload`. Reopen the panel. The box must still be unticked. Failure is the setting reverting to ticked, which means it isn't being saved.

**19.** With the welcome message still disabled, log out fully and log back in. **No welcome line may print.** Failure is the message appearing anyway.

**20.** Re-tick **Enable Welcome Message** and `/reload`. The welcome line must print again at login. Failure is the message staying suppressed, which means the toggle only works in one direction.

## Default Output setting

**21.** On the main panel, open the **Default Output** dropdown. It must list exactly five entries in this order: **Local (/1)**, **Say**, **Yell**, **Party**, **Guild**. Failure is a missing channel, an extra channel, a different order, or an entry showing a raw key like `OPTIONS_OUTPUT_SAY` instead of a readable name.

**22.** On a fresh install (or right after a Reset Profile), the dropdown must read **Local (/1)**. Failure is any other channel selected by default.

**23.** Leave it on **Local (/1)** and trigger an announcement, standing in a zone that has a General channel. The chat box must open with the channel indicator already switched to General — the message text alone sits in the box, ready to send to that channel. Failure is the box opening in Say instead, or the channel command sitting visibly inside the message text as `/1 {rt7} Come & Get It …`, where it will be sent as words rather than routing the line.

**24.** Set **Default Output** to **Say** and trigger an announcement. The draft must open in Say. Failure is any other channel.

**25.** Set it to **Yell** and trigger an announcement. The draft must open in Yell. Failure is any other channel.

**26.** Set it to **Party** and trigger an announcement. The chat box must open switched to Party. You do not need to be in a group for the draft to open — only for the send to succeed, so this step works solo. Failure is the box opening in a different channel, or the channel command appearing as text inside the message.

**27.** Set it to **Guild**, trigger an announcement to confirm it opens in Guild, then `/reload` and check the dropdown still reads Guild. Failure is either the wrong channel on the draft, or the setting resetting across the reload.

## The core announcement

**28.** On a character without Herbalism, right-click a herb node. Your chat box must open with a complete draft naming that herb. Failure is nothing happening, or a draft naming the wrong object.

**29.** On a character without Mining, right-click an ore vein. Your chat box must open with a complete draft naming that vein. Failure is nothing happening, or a draft naming the wrong object.

**30.** Right-click a locked world chest you cannot open. Your chat box must open with a complete draft naming that chest. Failure is nothing happening, or a draft naming the wrong object.

**31.** Open your world map and read your coordinates, then trigger any announcement. The two numbers in the draft must be **whole numbers** and must match your map position within a point or two. Failure is decimals in the draft, obviously wrong numbers, or coordinates that don't move when you do.

**32.** Check the zone name at the end of the draft. It must be the zone you are standing in, spelled as the game spells it. Failure is a wrong zone, a subzone where the zone belongs, or `nil`.

**33.** With a draft sitting in your chat box, press `Esc`. The draft must vanish and **nothing may be sent**. Nobody should ever see a line you didn't press Enter on. Failure is the message going out on its own — the single most serious failure in this plan.

**34.** Trigger a fresh draft, edit the text (add a word, delete a word), and press Enter. The edited line must send to the chosen channel and read correctly in chat, with the `{rt7}` cross icon rendering as an icon rather than as the literal text `{rt7}`. Failure is the raw `{rt7}` showing as text, a broken or half-rendered line, or the edit being discarded.

## When it must stay silent

**35.** Enter combat with any mob and right-click a node you can't gather. **Nothing must happen.** Failure is your chat box opening mid-fight and swallowing your movement keys.

**36.** Zone into any dungeon or raid and right-click a node you can't gather. **Nothing must happen.** Failure is a draft appearing inside an instance.

**37.** Trigger an announcement, press `Esc` to dismiss it, then immediately right-click the same node again. The second attempt within about five seconds must produce **nothing**. Wait past five seconds and try again — it must work. Failure is either back-to-back drafts with no cooldown, or the add-on going permanently silent after one use.

**38.** Click into your chat box and start typing something — anything, don't send it. With that text still in the box, right-click a node you can't gather. **Your typing must be left completely alone** — no overwrite, no draft, no lost text. Failure is your half-typed message being replaced by the announcement.

**39.** With a locked lockbox in your bags, right-click it (or attempt to open it) so the client tells you it's locked. **No announcement may appear.** A lockbox is not a world node and must never be broadcast. Failure is a draft naming your lockbox — check this on **both flavors**, because the two clients read the tooltip through different game functions and only one of them is exercised on each.

**40.** On a character who *does* have the relevant profession at a high enough skill, gather a node normally. It must gather with **no draft and no announcement**. Failure is the add-on firing on a successful gather.

**41.** Right-click empty ground, a mailbox, or any object that isn't a herb, vein, or locked chest. **Nothing must happen.** Failure is a spurious draft naming an unrelated object.

## Profiles panel

**42.** Open Options → AddOns → Come & Get It → **Profiles**. The panel must load with a current profile shown — normally **Default**, shared by all your characters. Failure is a blank panel or a Lua error on opening it.

**43.** Change **Default Output** to **Guild** and untick the welcome message, then click **Reset Profile** in the Profiles panel. Both settings must return to their install values (Local (/1), welcome ticked), and the General panel must show the reset values as soon as you click back to it, **without a `/reload`**. Failure is settings surviving the reset, or the panel showing stale values until you reload.

**44.** Create a new profile called `Test`. Change **Default Output** to Say while on `Test`, then switch back to **Default**. Default must still hold its own value, unaffected by what you did on `Test`. Failure is one profile's change leaking into the other.

**45.** With `Test` active, use **Copy From** and copy from `Default`. The `Test` profile must take on Default's settings, visible immediately in the General panel. Failure is nothing changing, or an error.

**46.** With `Test` still active, `/reload`. The Profiles panel must still show `Test` as the current profile, with its settings intact. Failure is the profile snapping back to Default across the reload. When you're done, switch back to **Default** and delete `Test`.

## Diagnostic Tools panel

**47.** Log in fresh and open Options → AddOns → Come & Get It → **Diagnostic Tools**. Only two things may be visible: the warning paragraph and the **Enable Diagnostic Tools** toggle, which must be **off**. Failure is the toggle being on by default, or any of the report buttons visible before you enable anything.

**48.** Tick **Enable Diagnostic Tools**. Sections must appear below it: Event Log, Event Registration, API Endpoints, Detection Context, Other Add-ons, Saved Variables, Library Versions, Taint Log, and External Tools. Failure is nothing appearing, or the panel needing a reopen to show them.

**49.** Click **Show Captured Events** before starting a log. The output box must read **(no events captured)** under a header line. Failure is an error or an empty box with no explanation.

**50.** Click **Start Event Log**, then go trigger an announcement in the world, then come back and click **Show Captured Events**. The output must list timestamped entries including a `UI_ERROR_MESSAGE` line and a `GetNodeName` line naming the node you clicked. Failure is an empty log after you demonstrably fired an error.

**51.** Click **Stop Event Log**, then **Show Captured Events** again. The output must return to **(no events captured)**. Failure is the old entries persisting after a stop.

**52.** Click **Test Event Registration**. Every listed event must show `[PASS]`, and the summary line must read that all events register on this client. Failure is any `[FAIL]`. An `IsEventValid: n/a` is **not** a failure — that check simply doesn't exist on every client.

**53.** Click **Test WoW API Endpoints**. Read the list. Failure is a `[FAIL]` on **both** halves of a modern/legacy pair — for example both `C_Map.GetBestMapForUnit` and its fallback failing. A `[FAIL]` on one half while its partner passes is **expected and correct**: each client provides only one of the two.

**54.** Click **Test Detection Context** while standing in the open world. It must print a live map ID, your actual position, and your current zone name — matching what your map shows — plus `IsInInstance() = false` and `InCombatLockdown() = false`. Failure is `nil` where a zone or position should be while you're standing in a normal outdoor zone.

**55.** Click **List Installed Add-ons**, **Dump Saved Variables**, and **List Library Versions** in turn. Each must fill its output box with readable text rather than an empty box or an error. Failure is any button producing nothing.

**56.** Read the Taint Log state line, then click **Turn On Taint Log**. The state line must change to level 2. Click **Turn Off Taint Log** — it must return to level 0. Failure is the number not moving. **Leave taint logging off when you're done.**

**57.** Untick **Enable Diagnostic Tools**. Everything below the toggle must disappear immediately, and any running event log must stop. Failure is sections staying on screen, or the log continuing to capture after the gate is closed.

**58.** With diagnostics enabled, `/reload`, then reopen the panel. The toggle must be **off** again — diagnostics is deliberately a session-only setting that never persists. Failure is diagnostics still enabled after a reload.

## Flavor differences to watch

Do not skim these. Each one behaves differently on the two clients, and a plan run on only the forgiving flavor will pass while the add-on is broken for half its users.

- **Options panel docking (step 16)** — correct on Classic Era; **TBC Anniversary is the client where the panel has historically floated free** of the Options window instead of docking inside it. Because this add-on has no slash command and no minimap button, a broken dock means there is no way to reach the settings at all.
- **Locked lockbox in bags (step 39)** — the two clients read the tooltip through different game functions, and each client only ever exercises one of them. A lockbox correctly ignored on Era proves nothing about Anniversary. Run it on both.
- **Herb and ore detection (steps 28–29)** — the two clients don't report gathering failures identically, and the add-on identifies herb versus ore from the profession name in the error text rather than from an error code. Detection working on one flavor is not evidence it works on the other. Both node types must be confirmed on both clients.
- **API Endpoints report (step 53)** — expect roughly half of each modern/legacy pair to read `[FAIL]` on any given client. That is the report doing its job, not a defect. Only a pair failing on *both* halves is a real failure.
- **Event Registration report (step 52)** — `IsEventValid: n/a` is normal on the client that lacks that check. Only `[FAIL]` counts.

## Localization spot-check

Every locale file was rewritten this release, so this section matters more than usual. Run it on a non-English client.

**59.** Log in on a non-English client and open the settings panel. Every label, description, and note must render in that language. Failure is a raw key showing through — text like `OPTIONS_OUTPUT_NOTE` or `MSG_FORMAT_HERB` appearing on screen instead of a sentence.

**60.** Trigger all three announcement types (herb, ore, chest). Each must read as one complete, grammatical sentence with the node name, both coordinates, and the zone all present and in sensible places. Failure is `nil` anywhere in the line, a stray `%s`, a value appearing twice, or the coordinates and zone swapped so the sentence claims a zone at a position.

**61.** This is the highest-risk localization check. On the non-English client, right-click **both** a herb node and an ore vein you can't gather. Both must produce a draft. If the locked chest works but herbs and ore produce **nothing at all**, the profession names in that locale file don't match what the client actually prints — detection dies silently with no error to warn you. Failure is exactly that pattern: chests fine, herbs and ore dead.

**62.** Run this on **ruRU** specifically — Cyrillic costs about twice the bytes per character, so it overflows the chat limit long before German or French do. Trigger an announcement on a long-named node in a long-named zone. If the line exceeds the limit, the over-length warning from step 5 must print, and the draft must still open in full and untrimmed. Failure is a draft cut off mid-word, a broken character at the cut point, or no warning on a line that plainly can't be sent.

**63.** Read the translated sentences alongside the English ones. Some languages reorder the sentence so the node name, coordinates, or zone land in a different position — this is **intentional and correct**, and a translator should not "fix" it. Failure is only when the sentence is genuinely ungrammatical or the values are attached to the wrong parts of it.

## Sign-off

Manual testing is complete when **every step passes on both Classic Era and TBC Anniversary**. A single flavor is half a run. Once both rows below are filled in and passing, the add-on is ready for `4 - Pre-Launch Review Prompt.md`.

| Flavor | Tester | Date | Result | Failed steps |
| --- | --- | --- | --- | --- |
| Classic Era | | | ☐ Pass ☐ Fail | |
| TBC Anniversary | | | ☐ Pass ☐ Fail | |
