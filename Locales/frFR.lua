local addonName, namespace = ...
if GetLocale() ~= "frFR" then return end
local L = namespace.L

L["ROGUES"]        = "Voleurs"
L["HERBALISTS"]    = "Herboristes"
L["MINERS"]        = "Mineurs"

L["ACTION_OPEN"]   = "ouvrir"
L["ACTION_PICK"]   = "cueillir"
L["ACTION_MINE"]   = "miner"

L["PREFIX_LOCKED"]  = "un"
L["PREFIX_HERB"]    = "quelques"
L["PREFIX_MINE"]    = "un"

L["MATCH_HERB"]    = "Herboristerie"
L["MATCH_MINE"]    = "Minage"

L["DEFAULT_TREASURE"] = "Coffre verrouillé"
L["DEFAULT_HERB"]     = "Herbe"
L["DEFAULT_MINE"]     = "Filon de minerai"

L["MSG_FORMAT"]    = "{rt7} Venez vous servir // Hé %s, j'ai trouvé %s %s que je ne peux pas %s à %s, %s dans %s !"