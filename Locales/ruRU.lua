local addonName, namespace = ...
if GetLocale() ~= "ruRU" then return end
local L = namespace.L

L["ROGUES"]        = "Разбойники"
L["HERBALISTS"]    = "Травники"
L["MINERS"]        = "Шахтеры"

L["ACTION_OPEN"]   = "открыть"
L["ACTION_PICK"]   = "собрать"
L["ACTION_MINE"]   = "выкопать"

L["PREFIX_LOCKED"]  = "запертый"
L["PREFIX_HERB"]    = "куст"
L["PREFIX_MINE"]    = "жилу"

L["MATCH_HERB"]    = "Травничество"
L["MATCH_MINE"]    = "Горное дело"

L["MSG_FORMAT"]    = "{rt7} Забирайте // Эй, %s, я нашел %s %s, не могу %s! Координаты: %s, %s в %s."
