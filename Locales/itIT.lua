local addonName, namespace = ...
if GetLocale() ~= "itIT" then return end
local L = namespace.L

L["ROGUES"]        = "Ladri"
L["HERBALISTS"]    = "Erbalisti"
L["MINERS"]        = "Minatori"

L["ACTION_OPEN"]   = "aprire"
L["ACTION_PICK"]   = "raccogliere"
L["ACTION_MINE"]   = "estrarre"

L["PREFIX_LOCKED"]  = "un"
L["PREFIX_HERB"]    = "un po' di"
L["PREFIX_MINE"]    = "un"

L["MATCH_HERB"]    = "Erbalismo"
L["MATCH_MINE"]    = "Estrazione"

L["DEFAULT_TREASURE"] = "Forziere Chiuso"
L["DEFAULT_HERB"]     = "Erba"
L["DEFAULT_MINE"]     = "Filone di Minerali"

L["MSG_FORMAT"]    = "{rt7} Venite a prenderlo // Ehi %s, ho trovato %s %s che non posso %s alle %s, %s in %s!"