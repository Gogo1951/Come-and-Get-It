local addonName, namespace = ...
if GetLocale() ~= "ptBR" then return end
local L = namespace.L

L["ROGUES"]        = "Ladinos"
L["HERBALISTS"]    = "Herboristas"
L["MINERS"]        = "Mineiros"

L["ACTION_OPEN"]   = "abrir"
L["ACTION_PICK"]   = "coletar"
L["ACTION_MINE"]   = "minerar"

L["PREFIX_LOCKED"]  = "um"
L["PREFIX_HERB"]    = "alguma"
L["PREFIX_MINE"]    = "um"

L["MATCH_HERB"]    = "Herborismo"
L["MATCH_MINE"]    = "Mineração"

L["DEFAULT_TREASURE"] = "Baú Trancado"
L["DEFAULT_HERB"]     = "Erva"
L["DEFAULT_MINE"]     = "Veio de Minério"

L["MSG_FORMAT"]    = "{rt7} Venham Pegar // Ei %s, encontrei %s %s que não consigo %s em %s, %s em %s!"