# Come & Get It // Manual Test Plan

This is the manual test plan for Come & Get It, the steps to confirm it works before a release is tagged. For what it does, see [README.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README.md); for how it works, see [README-Technical.md](https://github.com/Gogo1951/Come-and-Get-It/blob/main/README-Technical.md).

## Before you start

**Run the whole list on each flavor in turn: Classic Era, WoW Forever, TBC Anniversary, MoP Classic, and Retail.** Steps are numbered continuously so you can report "failed on step N."

Gather these once on each client so you aren't caught short mid-run:

- **A character with neither Herbalism nor Mining, and no lockpicking.** This is the fixture that matters most: the add-on only reacts when the game tells you that you *can't* gather something. Any class works, as long as it isn't a Rogue. A bank alt or a fresh low-level character is ideal.
- **A second character on the same account**, any class and level, for the shared-settings step.
- **Herb nodes and ore veins nearby.** Peacebloom, Silverleaf, and Copper Veins are dense in Elwynn Forest and Durotar on every client.
- **A locked treasure chest out in the world.** On Classic Era, WoW Forever, and TBC Anniversary, Battered and Tattered chests along the Wetlands and Hillsbrad coastlines are reliable. On MoP Classic and Retail, use any world chest the game tells you is locked.
- **A locked lockbox in your bags**, such as a Battered or Worn Lockbox from fishing or humanoid drops. It is used as a negative test.
- **A dungeon or raid entrance you can zone into.**
- **Something to fight**, any open-world mob.
- **A non-English client**, only for the optional last step.

No second player is needed, because the add-on never sends anything on its own. Unless a step says otherwise, be **out of combat and out of instances**, standing in the open world. "Trigger a draft" always means: right-click an herb, vein, or locked chest you can't gather, and wait more than five seconds between attempts.

This plan deliberately skips the Feedback & Support link boxes, the stock profile create, copy, and delete controls, the over-length chat warning (no real node and zone name comes near the 255-byte limit), and, in Diagnostic Tools, the taint-log buttons and every report except Detection Context, API Endpoints, and the Event Log.

## Verify this release's changes

**One TOC per client**

**1.** At character select, open the **AddOns** list and find Come & Get It. It must be listed with its small artwork icon beside the name, and it must not be flagged as out of date or incompatible. This closes the change that gave every client its own TOC. **MoP Classic and Retail are new to the add-on in this release, so they are where this step earns its keep, but it must pass on all five.** Failure is the add-on missing from the list, an out-of-date or incompatible warning, or a blank square or question mark where the icon belongs.

**End of Support notice**

**2.** Log in with **Enable Welcome Message** ticked, as it is by default. Directly beneath the welcome line, a second line must print:

> Come & Get It // End of Support: this add-on is now part of Tracking Eye, and this is its final release. Install Tracking Eye to keep getting updates, and then you can remove Come & Get It.

Type `/reload`: the line must print again, still directly beneath the welcome line. This closes the new End of Support notice. Failure is the line missing, the line printing above the welcome line, or `nil` or a raw key such as `CHAT_END_OF_SUPPORT` where the text belongs.

**3.** Type `/cgi`, untick **Enable Welcome Message**, and type `/reload`. The End of Support line must still print, now on its own, because it has no switch of its own. Tick the welcome message back on afterwards. Failure is the End of Support line vanishing along with the welcome line, or the welcome line still printing.

**Version line**

**4.** Type `/cgi` and look below the four Feedback & Support rows at the bottom of the main panel. A gray line must read `Version` followed by the same version the welcome line printed in step 2, such as `Version Dev` on an unpackaged copy. This closes the version line's move into the translated text. Failure is `%s`, `nil`, or a raw key such as `OPTIONS_VERSION` in its place, or no line at all.

**Flavor in Diagnostic reports**

**5.** Open **Diagnostic Tools**, tick **Enable Diagnostic Tools**, and click **Test Detection Context**. The report's first line must end with `Flavor` and `Data`, each naming the client you are on: `Vanilla` on Classic Era, `Camelot` on WoW Forever, `TBC` on TBC Anniversary, `Mists` on MoP Classic, and `Mainline` on Retail, so WoW Forever reads `Flavor Camelot // Data Camelot`. The one exception is a Season of Discovery realm, where Classic Era correctly reads `Flavor Vanilla // Data Discovery`. Further down, your position and zone name must match what your world map shows. This closes the header change that replaced the old `Project` number with the flavor. Failure is `nil` or another client's name in the header, a `Project` field, or `nil` where the zone or position belongs while you stand in a normal outdoor zone.

**New chat box calls**

**6.** Click **Test WoW API Endpoints**. Every row must read `[PASS]`, including `ChatFrameUtil.OpenChat` and `ChatFrameUtil.GetActiveWindow`, the two calls the add-on now uses to open your chat box and to check whether you are already typing in it. **This step is flavor-sensitive: each client ships its own chat code and the add-on has no fallback, so a pass on one flavor proves nothing about the others.** Failure is any `[FAIL]` row, or a Lua error when you click the button.

**7.** Close the Options window, click into your chat box, and type a few words without sending them. With that text still in the box, right-click a node you can't gather. **Your typing must be left exactly as it was.** Press `Esc` to close the chat box, then right-click the node again: now a draft must open. Failure is your half-typed message being replaced by the draft, or no draft once the box is closed.

**Skill-name matching**

**8.** More than five seconds after your last draft, right-click an herb node. Your chat box must open holding a draft in exactly this shape, starting with the word "Hey":

> `Hey Herbalists! Peacebloom at 42, 68 in Elwynn Forest.`

Press `Esc`, wait five seconds, and right-click an ore vein. The draft must read `Hey Miners!`, then the vein's name, two **whole-number** coordinates that match your world map within a point or two, and the zone you are standing in (the zone, not the subzone). This closes the change to how the add-on matches the profession name in the game's error text. **This step is flavor-sensitive: the clients do not word that error identically, and MoP Classic and Retail are new to the add-on, so a pass on one flavor proves nothing about the others.** Failure is nothing happening, a vein addressed to Herbalists, decimals, a subzone, `nil` anywhere in the line, or `{rt7}`, a cross icon, or `Come & Get It //` anywhere in the draft.

When steps 1-8 pass on every flavor, this release's changes are verified. Proceed to `4 - Pre-Launch Review Prompt.md`.

## Core checks

**9.** Log in, then type `/reload`. Both times, a colored welcome line must print in the shape *"Come & Get It // Version ..."*, with no Lua error window and no red error text. Failure is any error naming Come & Get It, no welcome line, or a line containing `nil` or a stray `%s`.

**10.** Type `/cgi`. The settings must appear **docked inside the Blizzard Options window**, with Come & Get It selected in the category list on the left. Failure looks like either nothing happening at all, or a standalone window floating free of the Options frame. **TBC Anniversary is the flavor that historically breaks this, so a tester who runs only Classic Era has not finished.**

**11.** Close the window, then press `Esc`, choose **Options**, then **AddOns**, and select **Come & Get It**. The same docked panel must appear, with three entries under it in this order: **Come & Get It**, **Profiles**, **Diagnostic Tools**. Each must open without error. The add-on has no mini-map button, so `/cgi` and this list are every way in. Failure is a missing or blank entry, an entry in the wrong order, or a floating window, and again **TBC Anniversary is the flavor to watch**.

**12.** Pull a mob and, while still in combat, type `/cgi`. Chat must print *"As a safety precaution, the Options Interface cannot be opened during combat."* and the panel must **not** open. Finish the fight and wait: the panel must not open by itself afterwards. Failure is the panel opening, silence, or a red `ADDON_ACTION_BLOCKED` error.

**13.** Right-click the locked world chest. A draft must open reading `Hey Rogues!`, then the chest's name, your coordinates, and the zone. **This step is flavor-sensitive: each client numbers its error messages differently, so a pass on one flavor proves nothing about the others.** Failure is nothing happening while herbs and veins still work.

**14.** Right-click the locked lockbox in your bags, so the game tells you it is locked. **No draft may appear.** It raises the same error as a world chest, and the coordinates would only be your own. Failure is a draft naming your lockbox.

**15.** Trigger a draft and press `Esc`. The draft must vanish and **nothing may be sent**. Right-click the same node again straight away: it must produce **nothing**. Wait past five seconds and click again: a draft must open. Failure is the line going out on its own, the most serious failure in this plan, back-to-back drafts with no pause, or the add-on staying silent for good after one use.

**16.** Trigger a draft, add a word to it, and press Enter. The line must land in chat as one complete sentence with the node name, both coordinates, and the zone, including your added word. **On WoW Forever, watch that the line actually goes out: that client rejects chat lines carrying raid markers, which is why the line is plain.** Failure is the client refusing the message, a half-rendered line, or your edit being discarded.

**17.** Open the **Default Output** dropdown. It must list exactly **Local (/1)**, **Say**, **Yell**, **Party**, **Guild**, in that order. Pick **Say** and trigger a draft: the chat box must open already switched to Say, holding the message text alone. Set it back to **Local (/1)** and trigger a draft in a zone that has a General channel: the chat box must open already switched to General. Failure is a missing or extra channel, a raw key such as `OPTIONS_OUTPUT_SAY`, the wrong channel, or `/say` or `/1` sitting inside the message as words.

**18.** Set **Default Output** to **Guild**, log out, and log in on your second character. The dropdown must still read **Guild**, because every character shares one profile by design. Then log back in on your first character for the rest of the plan. Failure is the second character showing Local (/1).

**19.** On the main panel, untick **Enable Welcome Message**. Then open Options > AddOns > Come & Get It > **Profiles** and click **Reset Profile**. Click back to the main panel: **Default Output** must read **Local (/1)** and **Enable Welcome Message** must be ticked, straight away, without a `/reload`. Failure is Guild or the unticked box surviving the reset, or the panel showing stale values until you reload.

**20.** Pull a mob and, while in combat, right-click a node you can't gather. **Nothing must happen.** Finish the fight and stand still: **no delayed draft may appear**, because drafts attempted in combat are dropped, never queued. Failure is your chat box opening mid-fight and swallowing your movement keys, or a stale draft popping up after the fight.

**21.** Zone into a dungeon or raid and right-click anything you can't gather or open. **Nothing must happen.** Failure is a draft appearing inside an instance.

**22.** Type `/reload`, then open **Diagnostic Tools**. **Enable Diagnostic Tools** must be **off**, even though you ticked it in step 5, with only the warning paragraph and the toggle visible. Tick it and click **Start Event Log**. Pull a mob and, during the fight, spam an ability that is on cooldown or out of range until the game shows red error text a dozen times. **On WoW Forever and Retail, keep the spamming mid-fight: their engine withholds some combat information from add-ons, and the log must cope with that without a Lua error.** After the fight, trigger one draft, then come back and click **Show Captured Events**. Read the block at the end headed *"Suppressed uncorrelated traffic, biggest first"*: your combat errors must appear there as one counted row each, in the shape `UI_ERROR_MESSAGE(56, Ability is not ready yet.) x12`, and the gather error that produced your draft must **not** be in that block. Failure is the toggle still on after the reload, a Lua error during the fight, no summary block, or the gather error counted in it.

**23.** Optional, on a non-English client. Log in: the End of Support line must print in that language. Open the settings panel and trigger all three draft types. Every label must render in that language, and each draft must read as one complete sentence with the node name, both coordinates, and the zone in sensible places. Some languages reorder the sentence, which is intended. If herbs and veins produce nothing while the locked chest still works, the profession names shown by **Test Detection Context** do not match what that client prints. Failure is a raw key such as `OPTIONS_OUTPUT_NAME` on screen, an End of Support line still in English, `nil` or a stray `%s` in a draft, or chests working while herbs and veins are dead.

When every step passes on each of Classic Era, WoW Forever, TBC Anniversary, MoP Classic, and Retail, manual testing is complete. Proceed to `4 - Pre-Launch Review Prompt.md`.
