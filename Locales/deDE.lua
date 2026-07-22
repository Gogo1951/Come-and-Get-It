local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "deDE")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

--[[
    Translator guidance. Each MSG_FORMAT_* string is one complete announcement
    body, picked by what the player could not interact with. The code fills four
    %s placeholders in this fixed order: node name, x coordinate, y coordinate,
    zone name. Reorder the sentence freely for your language, but never reorder,
    add, or drop placeholders.

    Nothing precedes the node name, so no article or adjective has to agree with
    a name whose gender and number are unknown until runtime. Keep that property:
    if your language reads better with an article, restructure the sentence so
    the article attaches to a fixed word rather than to the placeholder.

    The raid marker, add-on name, and " // " separator are prepended by the code
    -- the bodies must stay body-only. MATCH_* must equal the profession skill
    names exactly as the game client displays them in this language (they are
    substring-matched against the client's error text).
]]

L["MATCH_HERB"] = "Kräuterkunde"
L["MATCH_MINE"] = "Bergbau"

L["MSG_FORMAT_LOCKED"] = "Hey Schurken, ich habe hier etwas gefunden, das ich nicht öffnen kann: %s bei %s, %s in %s!"
L["MSG_FORMAT_HERB"] =
	"Hey Kräuterkundige, ich habe hier etwas gefunden, das ich nicht pflücken kann: %s bei %s, %s in %s!"
L["MSG_FORMAT_MINE"] = "Hey Bergleute, ich habe hier etwas gefunden, das ich nicht abbauen kann: %s bei %s, %s in %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden sich unter Optionen > AddOns > Come & Get It. Gefällt dir das Add-on? Erzähl einem Freund davon! (="

L["CHAT_TOO_LONG"] =
	"Diese Ankündigung hat %d Bytes und überschreitet das Chat-Limit von %d Bytes. Kürze sie vor dem Senden."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Hast du ein Kraut gefunden, das du nicht pflücken kannst, eine Erzader, die du nicht abbauen kannst, oder eine verschlossene Schatztruhe und kein Schurke ist in Sicht? Klicke mit der rechten Maustaste darauf, und Come & Get It erstellt eine Nachricht, mit der du die Koordinaten teilen oder senden kannst. Ein Held zu sein war noch nie so einfach."

L["OPTIONS_WELCOME_NAME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Gibt die Willkommensnachricht im Chat aus, wenn du dich einloggst."

L["OPTIONS_OUTPUT_HEADER"] = "Ausgabe"
L["OPTIONS_OUTPUT_NAME"] = "Standardausgabe"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Wähle, an welchen Chatkanal die Ankündigung gerichtet wird. Der Entwurf erscheint in deinem Chat-Eingabefeld, sodass du ihn vor dem Senden überprüfen oder umleiten kannst."
L["OPTIONS_OUTPUT_NOTE"] =
	"Hinweis: Lokal (/1) ist der Allgemein-Kanal der Zone und ist Layer-spezifisch. Deine Nachricht erreicht die ganze Zone, aber nur Spieler auf deinem aktuellen Layer sehen sie."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Lokal (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Sagen"
L["OPTIONS_OUTPUT_YELL"] = "Schreien"
L["OPTIONS_OUTPUT_PARTY"] = "Gruppe"
L["OPTIONS_OUTPUT_GUILD"] = "Gilde"

L["FEEDBACK_HEADER"] = "Feedback & Unterstützung"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
