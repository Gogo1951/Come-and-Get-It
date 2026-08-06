# Come & Get It — Manual Test Plan

This is the manual test plan for Come & Get It — the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README-Technical.md).

## How to run this plan

Run the whole list on Classic Era, then again on TBC Anniversary. Do a `/reload` before starting each flavor.

Work top to bottom. Every step tells you exactly what to do, what you should see, and what failure looks like — if a step doesn't match its expected result, it failed. Steps are numbered continuously from 1 to 62 across the whole document, so a bug report only needs "failed on step N."

Some steps behave differently on the two clients and say so in the step itself. Those are not optional on either flavor — the client a step warns about is precisely the one where that step earns its keep. **A run on only one flavor is not a completed run.**

## Before you start

Gather these once so you aren't caught short mid-run:

- **Both flavors installed** — Classic Era and TBC Anniversary. The add-on ships for both, and both must be tested.
- **A character with neither Herbalism nor Mining.** This is the single most important fixture — the add-on only reacts when you *fail* to gather. Any class works; the add-on has no class-specific behavior. If your main has both professions, use a bank alt or a low-level character.
- **A second character on the same account**, for the shared-profile step. Any level, any class.
- **Somewhere with herb nodes and ore veins nearby.** Any starting or low-level zone works — Peacebloom, Silverleaf, and Copper Veins are dense in Elwynn Forest, Durotar, and Teldrassil.
- **A locked treasure chest in the world**, on a character with no lockpicking and no key. Battered and Tattered chests along the Wetlands and Hillsbrad coastlines are reliable.
- **A locked lockbox in your bags** (a Battered or Worn Lockbox, common from fishing and humanoid drops). One step uses it as a negative test — it must *not* produce an announcement.
- **A character who *does* have Herbalism or Mining at a workable skill level**, for the successful-gather negative test.
- **A dungeon or raid entrance you can zone into**, for the instance-suppression step.
- **Something to fight** — any open-world mob, for the combat-suppression steps.
- **A second player is optional.** Every draft step works solo, because the add-on never sends on its own. You only need a partner if you want to watch a Party-channel line actually land.
- **A non-English client** — only for the optional localization spot-check in steps 58–62.

Unless a step says otherwise, be **out of combat and out of instances**, standing in the open world.

## Smoke test

This plan is being run without a list of specific changes to verify, so start here: eight steps that prove the add-on loads, opens, and does the one thing it exists to do. If any of these fail, stop and report it — the rest of the plan will only produce noise.

**1.** Log in with Come & Get It enabled. No Lua error window may appear, and no red error text may print in chat. Failure is any error popup naming Come & Get It, or the add-on missing from the AddOns list entirely.

**2.** Watch your chat frame at login. A welcome line must print, coloured, in the shape *"Come & Get It // Version …"*, telling you the settings live under Options > AddOns > Come & Get It. Failure is no message, an uncoloured line, or a line containing `nil` or a stray `%s`.

**3.** Press `Esc`, choose **Options**, then **AddOns**, and select **Come & Get It**. The settings must appear **docked inside the Blizzard Options window**, with the add-on selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **This step is flavor-sensitive — TBC Anniversary is the client where the panel has historically floated free, so run it there and not just on Era.** The add-on has no slash command and no minimap button; the Options window is the only way in, so a broken dock leaves the player with no route to the settings at all.

**4.** With Come & Get It selected, look at the category list. Three entries must be reachable and must open without error: the main **Come & Get It** panel, **Profiles**, and **Diagnostic Tools**, in that order. Failure is a missing entry, an entry that opens blank, or an entry nested under the wrong parent.

**5.** Standing in the open world and out of combat, on a character without Herbalism, right-click an herb node. Your chat box must open with a complete draft in this shape:

> `{rt7} Come & Get It // Hey Herbalists, I came across something I can't pick: Peacebloom at 42, 68 in Elwynn Forest!`

The node name, both coordinates, and the zone must all be filled in. `{rt7}` appearing as literal text **while the line sits in the chat box is correct** — it only becomes a cross icon once the line is sent. Failure is nothing happening, a missing or duplicated word, a stray `%s`, the word `nil` anywhere, or two add-on names in one line.

**6.** With that draft still sitting in your chat box, press `Esc`. The draft must vanish and **nothing may be sent**. Nobody should ever see a line you didn't press Enter on. Failure is the message going out on its own — the single most serious failure in this plan.

**7.** Type `/reload`. The UI must come back with no error window and no red text, the welcome line must print again, and the settings panel must still open. Failure is an error on reload or a panel that no longer opens.

**8.** Read the last line of the main Come & Get It panel. It must show a version. In an unpackaged working copy it correctly reads **"Version Dev"**; in a packaged release build it must read a real dated version. Failure is a literal `2026.07.25.B` on screen in a release build.

When steps 1–8 pass on both flavors, the add-on is smoke-clean. Run the rest of the plan, and when it passes on both flavors, proceed to `4 - Pre-Launch Review Prompt.md`.

## Loading and the settings panel

**9.** Open the character-select or in-game **AddOns** list and find Come & Get It. Its icon must render — the small Come & Get It artwork, not a blank square or a question mark. Failure is a missing icon, which means the icon path in the TOC doesn't match the file that shipped.

**10.** Read the main panel top to bottom. You must see, in order: an intro paragraph describing the add-on, an **Enable Welcome Message** toggle, an **Output** header, a **Default Output** label with a dropdown beside it, a grey note about Local being layer-specific, a **Feedback & Support** header with four link boxes, and the version line. Every one must read as a sentence or a label in your language. Failure is a raw key showing through — text like `OPTIONS_OUTPUT_NOTE` or `FEEDBACK_HEADER` on screen instead of words — or a blank where a label belongs.

**11.** Untick **Enable Welcome Message**, then type `/reload`. Reopen the panel. The box must still be unticked. Failure is the setting reverting to ticked, which means it isn't being saved.

**12.** With the welcome message still disabled, log out fully and log back in. **No welcome line may print.** Failure is the message appearing anyway.

**13.** Re-tick **Enable Welcome Message** and `/reload`. The welcome line must print again at login. Failure is the message staying suppressed, which means the toggle only works in one direction.

**14.** Set **Default Output** to **Yell**, then log out and log in on a **different character on the same account**. The dropdown must still read **Yell**. All characters share one profile by design, so a setting made on one applies everywhere. Failure is the second character showing Local (/1) — that means settings are being stored per character instead of shared.

## Default Output setting

**15.** Open the **Default Output** dropdown. It must list exactly five entries in this order: **Local (/1)**, **Say**, **Yell**, **Party**, **Guild**. Failure is a missing channel, an extra channel, a different order, or an entry showing a raw key like `OPTIONS_OUTPUT_SAY` instead of a readable name.

**16.** On a fresh install — or right after a Reset Profile, see step 40 — the dropdown must read **Local (/1)**. Failure is any other channel selected by default.

**17.** Leave it on **Local (/1)** and trigger an announcement, standing in a zone that has a General channel. The chat box must open with the channel indicator **already switched to General**, with the message text alone sitting in the box, ready to send. Failure is the box opening in Say instead, or the channel command sitting visibly inside the message text as `/1 {rt7} Come & Get It …`, where it would be sent as words rather than routing the line.

**18.** Set **Default Output** to **Say** and trigger an announcement. The draft must open in Say. Failure is any other channel, or the `/say` command appearing as text inside the message.

**19.** Set it to **Yell** and trigger an announcement. The draft must open in Yell. Failure is any other channel.

**20.** Set it to **Party** and trigger an announcement. The chat box must open switched to Party. You do **not** need to be in a group for the draft to open — only for the send to succeed, so this step works solo. If you have a partner, group up, trigger a draft, and press Enter: the line must land in party chat. Note that there is deliberately no Raid option — in a raid the draft still opens in Party, and that is intended, not a bug. Failure is the box opening in a different channel, or the channel command appearing as text inside the message.

**21.** Set it to **Guild**, trigger an announcement to confirm the draft opens in Guild, then `/reload` and check the dropdown still reads Guild. Failure is either the wrong channel on the draft, or the setting resetting across the reload.

## Feedback & Support links

**22.** On the main panel, find the four boxes under **Feedback & Support**, labelled **Discord**, **GitHub**, **CurseForge**, and **Wago**. Each must display a complete, readable URL. Click into one, select all, and copy — the copied address must be the full link, not a fragment. Failure is an empty box, a URL cut off at the edge of the field, or a link pointing somewhere unrelated to this add-on.

**23.** Type junk into one of those boxes and press Enter, then click to another panel and back. The box must show its original URL again. These are display fields you copy from, never fields you edit. Failure is your typed text sticking, which means the field is writable when it shouldn't be.

## The core announcement

**24.** On a character without Herbalism, right-click an herb node. The draft must say **"Hey Herbalists"** and **"I can't pick"**, and name that herb. Failure is nothing happening, a draft naming the wrong object, or the wrong audience or verb.

**25.** On a character without Mining, right-click an ore vein. The draft must say **"Hey Miners"** and **"I can't mine"**, and name that vein. Failure is the wrong audience or verb — a vein addressed to Herbalists means the two node types are crossed.

**26.** Right-click a locked world chest you cannot open. The draft must say **"Hey Rogues"** and **"I can't open"**, and name that chest. Failure is the wrong audience or verb, as above.

**27.** Open your world map and read your coordinates, then trigger any announcement. The two numbers in the draft must be **whole numbers** and must match your map position within a point or two. Move a good distance, wait past the cooldown, and trigger again — the numbers must change. Failure is decimals in the draft, obviously wrong numbers, or coordinates that don't move when you do.

**28.** Check the zone name at the end of the draft. It must be the zone you are standing in, spelled as the game spells it — the zone, not a subzone. Failure is a wrong zone, a subzone where the zone belongs, or `nil`.

**29.** Find a node whose name starts with a vowel — Iron Deposit, Arcane Crystal, Earthroot. The sentence must place the node name directly after the colon with **no article in front of it**: `…I can't mine: Iron Deposit at…`. Failure is a leftover article — `a Iron Deposit` or `an Iron Deposit`.

**30.** Trigger a fresh draft, edit the text (add a word, delete a word), and press Enter. The edited line must send to the chosen channel and read correctly in chat, with the `{rt7}` cross now rendering **as an icon** rather than as literal text. Failure is the raw `{rt7}` showing as text in the sent line, a broken or half-rendered line, or the edit being discarded.

**31.** Watch for the over-length warning. If a finished line exceeds 255 bytes, a message must print in your chat frame reading *"This announcement is N bytes, over the 255-byte chat limit. Shorten it before sending."* — and the draft must still open **in full and untrimmed** so you can edit it down yourself. Failure is a silently truncated draft, a draft cut off mid-word, or no warning at all on a line you can count past 255. On an English client most lines fit comfortably; if you can't produce an overflow naturally, confirm instead that **no** warning appears on a normal-length announcement, and check the overflow properly at step 61.

## When it must stay silent

**32.** Pull a mob, and while still in combat right-click a node you can't gather. **Nothing must happen** — no chat box opening, no draft, no error. Failure is your chat box opening mid-fight and swallowing your movement keys.

**33.** Now kill the mob, leave combat, and stand still without touching the node again. **No delayed draft may appear.** Announcements attempted in combat are dropped on purpose, never queued. Failure is a stale announcement popping up seconds after the fight ends.

**34.** Zone into any dungeon or raid and right-click a node you can't gather. **Nothing must happen.** Failure is a draft appearing inside an instance.

**35.** Trigger an announcement, press `Esc` to dismiss it, then immediately right-click the same node again. The second attempt within about five seconds must produce **nothing**. Wait past five seconds and try again — it must work. Failure is either back-to-back drafts with no cooldown, or the add-on going permanently silent after one use.

**36.** Click into your chat box and start typing something — anything, don't send it. With that text still in the box, right-click a node you can't gather. **Your typing must be left completely alone** — no overwrite, no draft, no lost text. Failure is your half-typed message being replaced by the announcement.

**37.** With a locked lockbox in your bags, right-click it so the client tells you it's locked. **No announcement may appear.** A lockbox is not a world node, and its coordinates would just be your own. Failure is a draft naming your lockbox — check this on **both flavors**, because the clients don't necessarily read the tooltip through the same game function, and only the one a client provides is ever exercised there. Step 52 tells you which one your client has.

**38.** On a character who *does* have the relevant profession at a high enough skill, gather a node normally. It must gather with **no draft and no announcement**. Failure is the add-on firing on a successful gather.

**39.** Right-click empty ground, a mailbox, an unlocked container, or any object that isn't an herb, a vein, or a locked chest. **Nothing must happen.** Failure is a spurious draft naming an unrelated object.

## Profiles panel

**40.** Open Options → AddOns → Come & Get It → **Profiles**. The panel must load with a current profile shown — normally **Default**, shared by all your characters. Failure is a blank panel or a Lua error on opening it.

**41.** Change **Default Output** to **Guild** and untick the welcome message, then click **Reset Profile** in the Profiles panel. Both settings must return to their install values (Local (/1), welcome ticked), and the main panel must show the reset values as soon as you click back to it, **without a `/reload`**. Failure is settings surviving the reset, or the panel showing stale values until you reload.

**42.** Create a new profile called `Test`. Change **Default Output** to Say while on `Test`, then switch back to **Default**. Default must still hold its own value, unaffected by what you did on `Test`, and the main panel must show each profile's values the moment you switch — no reload needed. Failure is one profile's change leaking into the other, or values frozen from whichever profile was active when you first opened the window.

**43.** With `Test` active, use **Copy From** and copy from `Default`. The `Test` profile must take on Default's settings, visible immediately in the main panel. Failure is nothing changing, or an error.

**44.** With `Test` still active, `/reload`. The Profiles panel must still show `Test` as the current profile, with its settings intact. Failure is the profile snapping back to Default across the reload.

**45.** Switch back to **Default** and delete `Test`. The deletion must succeed with no error, and `Test` must be gone from the profile list. Failure is an error, or the profile reappearing after a `/reload`.

## Diagnostic Tools panel

**46.** Log in fresh and open Options → AddOns → Come & Get It → **Diagnostic Tools**. Only two things may be visible: the warning paragraph and the **Enable Diagnostic Tools** toggle, which must be **off**. Failure is the toggle being on by default, or any of the report buttons visible before you enable anything.

**47.** Tick **Enable Diagnostic Tools**. Nine sections must appear below it, without needing to reopen the panel: Event Log, Event Registration, API Endpoints, Detection Context, Other Add-ons, Saved Variables, Library Versions, Taint Log, and External Tools — the last of which is two hint lines mentioning `/console scriptErrors 1` and `/etrace`. Failure is nothing appearing, a missing section, or the panel needing a reopen to show them.

**48.** Click **Show Captured Events** before starting a log. The output box must read **(no events captured)** under a header line naming the add-on, its version, and your client. Failure is an error or an empty box with no explanation.

**49.** Click **Start Event Log**, go trigger an announcement in the world, and also pick a fight — spam an ability off cooldown or out of range a few times so the game shows red error text that has nothing to do with gathering. Come back and click **Show Captured Events**. The gather error must appear as a full timestamped `UI_ERROR_MESSAGE` line with a `GetNodeName` line naming the node you clicked, while the unrelated combat errors must **not** appear as individual lines — they belong in the counted summary at the end of the report, one row per error in the shape `UI_ERROR_MESSAGE(56, Ability is not ready yet.) x12`. Failure is an empty log after you demonstrably fired a gather error, the gather error itself landing in the summary instead of a full line, or combat spam flooding the log as individual entries.

**50.** Click **Stop Event Log**, then **Show Captured Events** again. The output must return to **(no events captured)**. Failure is the old entries persisting after a stop.

**51.** Click **Test Event Registration**. Both listed events — `PLAYER_LOGIN` and `UI_ERROR_MESSAGE` — must show `[PASS]`, and the summary line must read that all events register on this client. Failure is any `[FAIL]`. An `IsEventValid: n/a` is **not** a failure — that check simply doesn't exist on every client.

**52.** Click **Test WoW API Endpoints**. Read the list. Failure is a `[FAIL]` on **both** halves of a modern/legacy pair — for example both `C_Map.GetBestMapForUnit` and its fallback failing, or both `TooltipUtil.GetDisplayedItem` and `GameTooltip.GetItem`. A `[FAIL]` on one half while its partner passes is **expected and correct**: each client provides only one of the two. The tooltip pair is the one that decides how step 37 behaves on this client.

**53.** Click **Test Detection Context** while standing in the open world. It must print your live map ID, your actual position, and your current zone name — matching what your map shows — plus `IsInInstance() = false` and `InCombatLockdown() = false`, and the herb and mine match strings in quotes. Failure is `nil` where a zone or position should be while you're standing in a normal outdoor zone.

**54.** Click **List Installed Add-ons**, **Dump Saved Variables**, and **List Library Versions** in turn. Each must fill its output box with readable text rather than an empty box or an error. In the Saved Variables dump, `showWelcome` and `defaultOutput` must appear under a profile and must match what the settings panel is currently showing. Failure is any button producing nothing, or stored values that disagree with the panel.

**55.** Read the Taint Log state line, then click **Turn On Taint Log**. The state line must change to level 2. Click **Turn Off Taint Log** — it must return to level 0. Failure is the number not moving. **Leave taint logging off when you're done.**

**56.** Untick **Enable Diagnostic Tools**. Everything below the toggle must disappear immediately, and any running event log must stop. Failure is sections staying on screen, or the log continuing to capture after the gate is closed.

**57.** Tick it back on, then `/reload` and reopen the panel. The toggle must be **off** again — diagnostics is deliberately a session-only setting that never persists. Failure is diagnostics still enabled after a reload.

## Flavor differences to watch

Do not skim these. Each one behaves differently on the two clients, and a plan run on only the forgiving flavor will pass while the add-on is broken for half its users.

- **Options panel docking (step 3)** — correct on Classic Era; **TBC Anniversary is the client where the panel has historically floated free** of the Options window instead of docking inside it. Because this add-on has no slash command and no minimap button, a broken dock means there is no way to reach the settings at all.
- **Locked lockbox in bags (step 37)** — the clients don't necessarily read the tooltip through the same game function, and each client only ever exercises the one it provides. A lockbox correctly ignored on Era proves nothing about Anniversary. Run it on both, and read step 52 to see which function your client is using.
- **Herb and ore detection (steps 24–25)** — the add-on tells herb from ore by the profession name inside the client's error text, not by an error code, and the two clients don't word gathering failures identically. Detection working on one flavor is not evidence it works on the other. Both node types must be confirmed on both clients.
- **API Endpoints report (step 52)** — expect roughly half of each modern/legacy pair to read `[FAIL]` on any given client. That is the report doing its job, not a defect. Only a pair failing on *both* halves is a real failure.
- **Event Registration report (step 51)** — `IsEventValid: n/a` is normal on the client that lacks that check. Only `[FAIL]` counts.

## Localization spot-check

Optional, and only worth running on a non-English client. The add-on ships eleven locales and every announcement is assembled from translated text, so this is where sentence-level breakage shows up.

**58.** Log in on a non-English client and open the settings panel. Every label, description, and note must render in that language. Failure is a raw key showing through — text like `OPTIONS_OUTPUT_NOTE` or `MSG_FORMAT_HERB` appearing on screen instead of a sentence.

**59.** Trigger all three announcement types (herb, ore, chest). Each must read as one complete, grammatical sentence with the node name, both coordinates, and the zone all present and in sensible places. Failure is `nil` anywhere in the line, a stray `%s`, a value appearing twice, or the coordinates and zone swapped so the sentence claims a zone at a position.

**60.** This is the highest-risk localization check. Open **Diagnostic Tools → Test Detection Context** and read the herb and mine match strings: each must be the profession name spelled **exactly** as this client spells it. Then right-click **both** an herb node and an ore vein you can't gather. Both must produce a draft. If the locked chest works but herbs and ore produce **nothing at all**, those two strings don't match what the client actually prints — detection dies silently with no error to warn you. Failure is exactly that pattern: chests fine, herbs and ore dead.

**61.** Run this on **ruRU** specifically — Cyrillic costs about twice the bytes per character, so it overflows the 255-byte chat limit long before German or French do. Trigger an announcement on a long-named node in a long-named zone. If the line exceeds the limit, the over-length warning from step 31 must print, and the draft must still open in full and untrimmed. Failure is a draft cut off mid-word, a broken character at the cut point, or no warning on a line that plainly can't be sent.

**62.** Read the translated sentences alongside the English ones. Some languages reorder the sentence so the node name, coordinates, or zone land in a different position — this is **intentional and correct**, and a translator should not "fix" it. Failure is only when the sentence is genuinely ungrammatical or the values are attached to the wrong parts of it.

## Sign-off

Manual testing is complete when **every step passes on both Classic Era and TBC Anniversary**. A single flavor is half a run. Once both rows below are filled in and passing, the add-on is ready for `4 - Pre-Launch Review Prompt.md`.

| Flavor | Tester | Date | Result | Failed steps |
| --- | --- | --- | --- | --- |
| Classic Era | | | ☐ Pass ☐ Fail | |
| TBC Anniversary | | | ☐ Pass ☐ Fail | |
