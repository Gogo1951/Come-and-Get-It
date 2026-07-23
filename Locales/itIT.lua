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
    -- the bodies must stay body-only.
]]

L["MSG_FORMAT_LOCKED"] = "Ehi Ladri, ho trovato qualcosa che non posso aprire: %s (%s, %s) in %s!"
L["MSG_FORMAT_HERB"] = "Ehi Erbalisti, ho trovato qualcosa che non posso raccogliere: %s (%s, %s) in %s!"
L["MSG_FORMAT_MINE"] = "Ehi Minatori, ho trovato qualcosa che non posso estrarre: %s (%s, %s) in %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOns > Come & Get It. Ti piace l'add-on? Parlane con un amico! (="

L["CHAT_TOO_LONG"] =
	"Questo annuncio è di %d byte e supera il limite della chat di %d byte. Accorcialo prima di inviarlo."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"Hai trovato un'erba che non puoi raccogliere, un filone di minerali che non puoi estrarre o un forziere chiuso senza nessun Ladro in vista? Fai clic col tasto destro su di esso e Come & Get It creerà un messaggio che puoi usare per condividere o trasmettere le coordinate. Essere un eroe non è mai stato così facile."

L["OPTIONS_WELCOME_NAME"] = "Abilita messaggio di benvenuto"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Stampa il messaggio di benvenuto nella chat al momento dell'accesso."

L["OPTIONS_OUTPUT_HEADER"] = "Uscita"
L["OPTIONS_OUTPUT_NAME"] = "Uscita predefinita"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Scegli a quale canale di chat è indirizzato l'annuncio. La bozza si apre nella tua barra della chat così puoi rivederla o reindirizzarla prima di inviarla."
L["OPTIONS_OUTPUT_NOTE"] =
	"Locale (/1) è il canale Generale della zona ed è specifico per layer. Il tuo annuncio raggiunge l'intera zona, ma solo i giocatori sul tuo layer attuale lo vedranno."

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
