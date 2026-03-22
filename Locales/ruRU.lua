local addonName, namespace = ...
if GetLocale() ~= "ruRU" then return end
local L = namespace.L

L["ROGUES"]        = "Разбойники"
L["HERBALISTS"]    = "Травники"
L["MINERS"]        = "Рудокопы"

L["ACTION_OPEN"]   = "открыть"
L["ACTION_PICK"]   = "собрать"
L["ACTION_MINE"]   = "добыть"

L["PREFIX_LOCKED"]  = "запертый"
L["PREFIX_HERB"]    = "немного"
L["PREFIX_MINE"]    = "какую-то"

L["MATCH_HERB"]    = "Травничество"
L["MATCH_MINE"]    = "Горное дело"

L["DEFAULT_TREASURE"] = "Сундук с сокровищами"
L["DEFAULT_HERB"]     = "Трава"
L["DEFAULT_MINE"]     = "Рудная жила"

L["MSG_FORMAT"]    = "{rt7} Забирайте // Эй, %s, я нашел %s %s, но не могу %s! Координаты: %s, %s в %s."