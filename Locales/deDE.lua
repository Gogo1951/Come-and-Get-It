local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "deDE")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Skill Names
--------------------------------------------------------------------------------

--[[
    Not display copy. MATCH_* must equal the profession skill names exactly as
    the game client displays them in this language: they are substring-matched
    against the client's error text, so a loose or stylized translation silently
    stops the add-on from detecting anything at all.
]]

L["MATCH_HERB"] = "Kräuterkunde"
L["MATCH_MINE"] = "Bergbau"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

--[[
    Translator guidance. Each MSG_FORMAT_* string is the complete line sent to
    chat, picked by what the player could not interact with. The code fills four
    %s placeholders in this fixed order: node name, x coordinate, y coordinate,
    zone name. Reorder the sentence freely for your language, but never reorder,
    add, or drop placeholders.

    The greeting closes on "!" so the node name starts a fresh clause with nothing
    in front of it. That is load-bearing, not stylistic: no article or adjective
    has to agree with a name whose gender and number are unknown until runtime, and
    English dodges a/an ("an Iron Deposit" vs "a Gold Vein") for free. If your
    language reads better with an article, attach it to a fixed word rather than to
    the placeholder.

    Don't add a raid marker or the add-on name: WoW Forever blocks raid markers
    in chat, and the line reads as the player talking.
]]

L["MSG_FORMAT_LOCKED"] = "Hey Schurken! %s bei %s, %s in %s."
L["MSG_FORMAT_HERB"] = "Hey Kräuterkundige! %s bei %s, %s in %s."
L["MSG_FORMAT_MINE"] = "Hey Bergleute! %s bei %s, %s in %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) finden sich unter Optionen > AddOns > Come & Get It. Gefällt dir das Add-on? Erzähl einem Freund davon! (="

L["CHAT_TOO_LONG"] =
	"Dieser Entwurf hat %d Bytes und überschreitet das Chat-Limit von %d Bytes. Kürze ihn vor dem Senden."

L["CHAT_OPTIONS_IN_COMBAT"] =
	"Aus Sicherheitsgründen kann die Optionsoberfläche während des Kampfes nicht geöffnet werden."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Ein Kraut gefunden, das du nicht pflücken kannst, eine Erzader, die du nicht abbauen kannst, oder eine verschlossene Schatztruhe, und kein Schurke in Sicht? Rechtsklicke darauf, und Come & Get It erstellt eine Nachricht, mit der du die Koordinaten teilen oder verbreiten kannst. Ein Held zu sein war noch nie so einfach."

L["OPTIONS_WELCOME_NAME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Gibt die Willkommensnachricht im Chat aus, wenn du dich einloggst."

L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet die Optionsoberfläche für dieses Add-on."

L["OPTIONS_OUTPUT_HEADER"] = "Ausgabe"
L["OPTIONS_OUTPUT_NAME"] = "Standardausgabe"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Legt fest, in welchem Chatkanal dein Entwurf geöffnet wird; Lokal (/1) erreicht die ganze Zone, aber nur Spieler auf deinem aktuellen Layer."

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
