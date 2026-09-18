local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "itIT")
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

L["MATCH_HERB"] = "Erbalismo"
L["MATCH_MINE"] = "Estrazione"

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

L["MSG_FORMAT_LOCKED"] = "Ehi Ladri! %s (%s, %s) in %s."
L["MSG_FORMAT_HERB"] = "Ehi Erbalisti! %s (%s, %s) in %s."
L["MSG_FORMAT_MINE"] = "Ehi Minatori! %s (%s, %s) in %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOns > Come & Get It. Ti piace l'add-on? Parlane con un amico! (="

L["CHAT_TOO_LONG"] =
	"Questa bozza è di %d byte e supera il limite della chat di %d byte. Accorciala prima di inviarla."

L["CHAT_OPTIONS_IN_COMBAT"] =
	"Per motivi di sicurezza, l'interfaccia delle opzioni non può essere aperta durante il combattimento."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Hai trovato un'erba che non puoi raccogliere, una vena di minerale che non puoi estrarre o un forziere del tesoro chiuso a chiave senza un Ladro in vista? Cliccaci sopra col tasto destro e Come & Get It crea un messaggio che puoi usare per condividere o diffondere le coordinate. Essere un eroe non è mai stato così facile."

L["OPTIONS_WELCOME_NAME"] = "Abilita messaggio di benvenuto"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Stampa il messaggio di benvenuto nella chat al momento dell'accesso."

L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre l'interfaccia delle opzioni per questo add-on."

L["OPTIONS_OUTPUT_HEADER"] = "Uscita"
L["OPTIONS_OUTPUT_NAME"] = "Uscita predefinita"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Sceglie il canale di chat in cui si apre la tua bozza; Locale (/1) raggiunge l'intera zona, ma solo i giocatori sul tuo layer attuale."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Locale (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Dire"
L["OPTIONS_OUTPUT_YELL"] = "Urlare"
L["OPTIONS_OUTPUT_PARTY"] = "Gruppo"
L["OPTIONS_OUTPUT_GUILD"] = "Gilda"

L["FEEDBACK_HEADER"] = "Feedback e supporto"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
