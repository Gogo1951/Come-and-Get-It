local addonName, namespace = ...
if GetLocale() ~= "frFR" then return end
local L = namespace.L

L["ROGUES"]        = "Voleurs"
L["HERBALISTS"]    = "Herboristes"
L["MINERS"]        = "Mineurs"

L["ACTION_OPEN"]   = "ouvrir"
L["ACTION_PICK"]   = "cuillir"
L["ACTION_MINE"]   = "miner"

L["PREFIX_LOCKED"]  = "un verrouillé"
L["PREFIX_HERB"]    = "quelques"
L["PREFIX_MINE"]    = "un"

L["MATCH_HERB"]    = "Herboristerie"
L["MATCH_MINE"]    = "Minage"

L["MSG_FORMAT"]    = "{rt7} Venez le chercher // Hé %s, j'ai trouvé %s %s que je ne peux pas %s à %s, %s dans %s !"
