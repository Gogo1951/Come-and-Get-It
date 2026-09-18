# Come & Get It // Manual Test Plan

This is the manual test plan for Come & Get It, the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README-Technical.md).

## Before you start

**Run the whole list on each flavor in turn: Classic Era, WoW Forever, and TBC Anniversary.** Steps are numbered continuously so you can report "failed on step N."

Gather these once so you aren't caught short mid-run:

- **A character with neither Herbalism nor Mining, and no lockpicking.** This is the fixture that matters most: the add-on only reacts when the game tells you that you *can't* gather something. Any class works, as long as it isn't a Rogue. A bank alt or a fresh low-level character is ideal.
- **A second character on the same account**, any class and level, for the shared-settings step.
- **Herb nodes and ore veins nearby.** Any starting zone works: Peacebloom, Silverleaf, and Copper Veins are dense in Elwynn Forest, Durotar, and Teldrassil.
- **A locked treasure chest out in the world.** Battered and Tattered chests along the Wetlands and Hillsbrad coastlines are reliable.
- **A locked lockbox in your bags**, such as a Battered or Worn Lockbox from fishing or humanoid drops. It is used as a negative test.
- **A dungeon or raid entrance you can zone into.**
- **Something to fight**, any open-world mob.
- **A non-English client**, only for the optional last step. Russian is the most useful one to have.

No second player is needed, because the add-on never sends anything on its own. Unless a step says otherwise, be **out of combat and out of instances**, standing in the open world. "Trigger a draft" always means: right-click an herb, vein, or locked chest you can't gather, and wait more than five seconds between attempts.

This plan deliberately skips the Feedback & Support link boxes, the stock profile create, copy, and delete controls, and the add-on list, saved-variables, and library reports in Diagnostic Tools.

## Verify this release's changes

**WoW Forever support**

**1.** At character select, open the **AddOns** list and find Come & Get It. It must be listed with its small artwork icon beside the name. **WoW Forever is new in this release, so that is the flavor where this step earns its keep.** Failure is the add-on missing from the list, or a blank square or question mark where the icon belongs.

**Plain sent line**

**2.** On the character without Herbalism, right-click an herb node. Your chat box must open holding a draft in exactly this shape, starting with the word "Hey":

> `Hey Herbalists! Peacebloom at 42, 68 in Elwynn Forest.`

This closes the change that removed the raid marker and add-on name from the line. Failure is `{rt7}`, a cross icon, or `Come & Get It //` anywhere in the draft, or nothing happening at all.

**Locked chest detection**

**3.** Right-click the locked world chest. A draft must open reading `Hey Rogues!`, then the chest's name, your coordinates, and the zone. This closes the change to how the locked-chest error is recognized. **This step is flavor-sensitive: each client numbers its error messages differently, which is exactly what this change addresses, so a pass on one flavor proves nothing about the other two.** Failure is nothing happening while herbs and veins still work.

**4.** Right-click the locked lockbox in your bags, so the game tells you it is locked. **No draft may appear.** It raises the same error as a world chest, and the coordinates would only be your own. Failure is a draft naming your lockbox.

**Older-client fallbacks removed**

**5.** Open Options > AddOns > Come & Get It > **Diagnostic Tools**, tick **Enable Diagnostic Tools**, and click **Test WoW API Endpoints**. Every row must read `[PASS]`, including `GetGameMessageInfo` and `GameTooltip.GetItem`, and no row may end in "(legacy)". This closes the removal of the older-client fallbacks: the add-on now has no plan B, so any `[FAIL]` means it is broken on the flavor you are testing. Failure is any `[FAIL]` row, or a Lua error when you click the button.

**6.** Click **Test Detection Context**. The report must include the line `Locked-chest error string = ERR_ITEM_LOCKED`, the herb and mine match strings in quotes, and your map ID, position, and zone name matching what your world map shows. Failure is `nil` where the zone or position belongs while you are standing in a normal outdoor zone, or a Lua error.

**7.** Read the Taint Log state line, click **Turn On Taint Log**, then **Turn Off Taint Log**. The state line must read level 2 after the first click and level 0 after the second. Failure is the number not moving, or a Lua error on either click. Leave taint logging off when you are done.

**Options panel copy and layout**

**8.** Open the main Come & Get It panel and find **Default Output**. The label and its dropdown must sit side by side on one line, with **no paragraph of helper text beneath them**. Hover the dropdown: its tooltip must mention that Local (/1) only reaches players on your current layer. Below, each of the four **Feedback & Support** rows must show its name and a complete URL on one line. Failure is the dropdown stacked under its label, a leftover note under the dropdown, a tooltip with no mention of layers, or a URL cut off at the edge of its box.

When steps 1-8 pass on every flavor, this release's changes are verified. Proceed to `4 - Pre-Launch Review Prompt.md`.

## Core checks

**9.** Log in, then type `/reload`. Both times, a colored welcome line must print in the shape *"Come & Get It // Version ..."*, with no Lua error window and no red error text. Failure is any error naming Come & Get It, no welcome line, or a line containing `nil` or a stray `%s`.

**10.** Type `/cgi`. The settings must appear **docked inside the Blizzard Options window**, with Come & Get It selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **TBC Anniversary is the flavor that historically breaks this, so a tester who runs only Classic Era has not finished.**

**11.** Close the window, then press `Esc`, choose **Options**, then **AddOns**, and select **Come & Get It**. The same docked panel must appear, with three entries under it in this order: **Come & Get It**, **Profiles**, **Diagnostic Tools**. Each must open without error. The add-on has no mini-map button, so `/cgi` and this list are every way in. Failure is a missing or blank entry, an entry in the wrong order, or a floating window, and again **TBC Anniversary is the flavor to watch**.

**12.** Pull a mob and, while still in combat, type `/cgi`. Chat must print *"As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must **not** open. Finish the fight and wait: the panel must not open by itself afterwards. Failure is the panel opening, silence, or a red `ADDON_ACTION_BLOCKED` error.

**13.** On the character without Mining, right-click an ore vein. The draft must read `Hey Miners!`, then the vein's name, two **whole-number** coordinates that match your world map within a point or two, and the zone you are standing in (the zone, not the subzone). **This step is flavor-sensitive: herbs and veins are told apart by the profession name inside the client's own error text, and the clients do not word it identically, so it must pass on every flavor along with step 2.** Failure is nothing happening, a vein addressed to Herbalists, decimals, a subzone, or `nil` anywhere in the line.

**14.** Trigger a draft and press `Esc`. The draft must vanish and **nothing may be sent**. Failure is the line going out on its own, the most serious failure in this plan.

**15.** Trigger a draft, add a word to it, and press Enter. The line must land in chat as one complete sentence with the node name, both coordinates, and the zone, including your added word. **On WoW Forever, send it for real rather than just reading the draft: that client rejects chat lines carrying raid markers, which is why the line is now plain.** Failure is the client refusing the message, a half-rendered line, or your edit being discarded.

**16.** Open the **Default Output** dropdown. It must list exactly **Local (/1)**, **Say**, **Yell**, **Party**, **Guild**, in that order. Pick **Say** and trigger a draft: the chat box must open already switched to Say, holding the message text alone. Failure is a missing or extra channel, a raw key such as `OPTIONS_OUTPUT_SAY`, the wrong channel, or `/say` sitting inside the message as words.

**17.** Set **Default Output** back to **Local (/1)** and trigger a draft in a zone that has a General channel. The chat box must open already switched to General. Failure is the box opening in Say, or `/1` sitting inside the message text.

**18.** Set **Default Output** to **Guild**, log out, and log in on your second character. The dropdown must still read **Guild**, because every character shares one profile by design. Failure is the second character showing Local (/1).

**19.** Open Options > AddOns > Come & Get It > **Profiles** and click **Reset Profile**. Click back to the main panel: **Default Output** must read **Local (/1)** and **Enable Welcome Message** must be ticked, straight away, without a `/reload`. Failure is Guild surviving the reset, or the panel showing stale values until you reload.

**20.** Pull a mob and, while in combat, right-click a node you can't gather. **Nothing must happen.** Finish the fight and stand still: **no delayed draft may appear**, because drafts attempted in combat are dropped, never queued. Failure is your chat box opening mid-fight and swallowing your movement keys, or a stale draft popping up after the fight.

**21.** Zone into a dungeon or raid and right-click anything you can't gather or open. **Nothing must happen.** Failure is a draft appearing inside an instance.

**22.** Trigger a draft, press `Esc`, and right-click the same node again straight away. The second click must produce **nothing**. Wait past five seconds and click again: a draft must open. Failure is back-to-back drafts with no pause, or the add-on staying silent for good after one use.

**23.** Click into your chat box and type a few words without sending them. With that text still in the box, right-click a node you can't gather. **Your typing must be left exactly as it was.** Failure is your half-typed message being replaced by the draft.

**24.** Type `/reload`, then open **Diagnostic Tools**. **Enable Diagnostic Tools** must be **off**, even though you ticked it in step 5, with only the warning paragraph and the toggle visible. Tick it and click **Start Event Log**. Go spam an ability that is on cooldown or out of range until the game shows red error text a dozen times, trigger one draft, then come back and click **Show Captured Events**. Read the block at the end headed *"Suppressed uncorrelated traffic, biggest first"*: your combat errors must appear there as one counted row each, in the shape `UI_ERROR_MESSAGE(56, Ability is not ready yet.) x12`, and the gather error that produced your draft must **not** be in that block. Failure is the toggle still on after the reload, no summary block, or the gather error counted in it.

**25.** Optional, on a non-English client. Open the settings panel and trigger all three draft types. Every label must render in that language, and each draft must read as one complete sentence with the node name, both coordinates, and the zone in sensible places. Some languages reorder the sentence, which is intended. If herbs and veins produce nothing while the locked chest still works, the profession names shown by **Test Detection Context** do not match what that client prints. On a Russian client, also trigger a draft on a long-named node in a long-named zone: if the line passes 255 bytes, chat must print *"This draft is N bytes, over the 255-byte chat limit. Shorten it before sending."* and the draft must still open in full. Failure is a raw key such as `OPTIONS_OUTPUT_NAME` on screen, `nil` or a stray `%s` in a draft, chests working while herbs and veins are dead, or an over-long draft cut off mid-word.

When every step passes on each of Classic Era, WoW Forever, and TBC Anniversary, manual testing is complete. Proceed to `4 - Pre-Launch Review Prompt.md`.
