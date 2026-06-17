local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "itIT")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

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

L["CHAT_LOADED"] = "Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOn > Come & Get It. Ti piace l'addon? Parlane con un amico! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Hai trovato un'erba che non puoi raccogliere, un filone di minerali che non puoi estrarre o un forziere chiuso senza nessun Ladro in vista? Fai clic col tasto destro su di esso e Come & Get It creerà un messaggio che puoi usare per condividere o trasmettere le coordinate. Essere un eroe non è mai stato così facile."

L["OPTIONS_WELCOME_NAME"] = "Abilita Messaggio di Benvenuto"
L["OPTIONS_WELCOME_DESC"] = "Stampa il messaggio di benvenuto nella chat al momento dell'accesso."

L["OPTIONS_OUTPUT_HEADER"] = "Default Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESC"] = "Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] = "Note: Local (/1) is the zone's General channel and is layer-specific — your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Locale (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Dire"
L["OPTIONS_OUTPUT_YELL"] = "Urlare"
L["OPTIONS_OUTPUT_PARTY"] = "Gruppo"
L["OPTIONS_OUTPUT_GUILD"] = "Gilda"

L["FEEDBACK_HEADER"] = "Feedback e Supporto"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"