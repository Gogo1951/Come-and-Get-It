local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "itIT")
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
    Translator guidance. MSG_FORMAT is the announcement body; the code fills its
    seven %s placeholders in this fixed order: role (ROGUES / HERBALISTS /
    MINERS), prefix (PREFIX_*), node name, action verb (ACTION_*), x coordinate,
    y coordinate, zone name. Reorder the sentence freely for your language, but
    never reorder, add, or drop placeholders. PREFIX_* is the article/quantity
    word placed directly before the node name; ACTION_* is the verb the player
    cannot perform. The raid marker, add-on name, and " // " separator are
    prepended by the code -- MSG_FORMAT must stay body-only. MATCH_* must equal
    the profession skill names exactly as the game client displays them in this
    language (they are substring-matched against the client's error text).
]]

L["ROGUES"] = "Ladri"
L["HERBALISTS"] = "Erbalisti"
L["MINERS"] = "Minatori"

L["ACTION_OPEN"] = "aprire"
L["ACTION_PICK"] = "raccogliere"
L["ACTION_MINE"] = "estrarre"

L["PREFIX_LOCKED"] = "un"
L["PREFIX_HERB"] = "un po' di"
L["PREFIX_MINE"] = "un"

L["MATCH_HERB"] = "Erbalismo"
L["MATCH_MINE"] = "Estrazione"

L["MSG_FORMAT"] = "Ehi %s, ho trovato %s %s che non posso %s alle %s, %s in %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOns > Come & Get It. Ti piace l'add-on? Parlane con un amico! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Hai trovato un'erba che non puoi raccogliere, un filone di minerali che non puoi estrarre o un forziere chiuso senza nessun Ladro in vista? Fai clic col tasto destro su di esso e Come & Get It creerà un messaggio che puoi usare per condividere o trasmettere le coordinate. Essere un eroe non è mai stato così facile."

L["OPTIONS_WELCOME_NAME"] = "Abilita messaggio di benvenuto"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Stampa il messaggio di benvenuto nella chat al momento dell'accesso."

L["OPTIONS_OUTPUT_HEADER"] = "Uscita"
L["OPTIONS_OUTPUT_NAME"] = "Uscita predefinita"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Scegli a quale canale di chat è indirizzato l'annuncio. La bozza si apre nella tua barra della chat così puoi rivederla o reindirizzarla prima di inviarla."
L["OPTIONS_OUTPUT_NOTE"] =
	"Nota: Locale (/1) è il canale Generale della zona ed è specifico per layer: il tuo messaggio raggiunge l'intera zona, ma solo i giocatori sul tuo layer attuale lo vedranno."

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
