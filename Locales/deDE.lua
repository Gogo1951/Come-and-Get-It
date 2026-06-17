local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "deDE")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Schurken"
L["HERBALISTS"] = "Kräuterkundige"
L["MINERS"] = "Bergbauer"

L["ACTION_OPEN"] = "öffnen"
L["ACTION_PICK"] = "pflücken"
L["ACTION_MINE"] = "abbauen"

L["PREFIX_LOCKED"] = "eine verschlossene"
L["PREFIX_HERB"] = "ein"
L["PREFIX_MINE"] = "ein"

L["MATCH_HERB"] = "Kräuterkunde"
L["MATCH_MINE"] = "Bergbau"

L["MSG_FORMAT"] = "Hey %s, ich habe %s %s gefunden! Ich kann es nicht %s. (%s, %s in %s)"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden sich unter Optionen > AddOns > Come & Get It. Gefällt dir das Addon? Erzähl einem Freund davon! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Hast du ein Kraut gefunden, das du nicht pflücken kannst, eine Erzader, die du nicht abbauen kannst, oder eine verschlossene Schatztruhe und kein Schurke ist in Sicht? Klicke mit der rechten Maustaste darauf, und Come & Get It erstellt eine Nachricht, mit der du die Koordinaten teilen oder senden kannst. Ein Held zu sein war noch nie so einfach."

L["OPTIONS_WELCOME_NAME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_WELCOME_DESC"] = "Gibt die Willkommensnachricht im Chat aus, wenn du dich einloggst."

L["OPTIONS_OUTPUT_HEADER"] = "Default Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESC"] = "Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] = "Note: Local (/1) is the zone's General channel and is layer-specific — your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Lokal (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Sagen"
L["OPTIONS_OUTPUT_YELL"] = "Schreien"
L["OPTIONS_OUTPUT_PARTY"] = "Gruppe"
L["OPTIONS_OUTPUT_GUILD"] = "Gilde"

L["FEEDBACK_HEADER"] = "Feedback und Support"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"