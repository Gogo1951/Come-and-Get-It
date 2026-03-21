local addonName, namespace = ...
if GetLocale() ~= "zhCN" then return end
local L = namespace.L

L["ROGUES"]        = "盗贼"
L["HERBALISTS"]    = "草药师"
L["MINERS"]        = "矿工"

L["ACTION_OPEN"]   = "打开"
L["ACTION_PICK"]   = "采集"
L["ACTION_MINE"]   = "挖掘"

L["PREFIX_LOCKED"]  = "上锁的"
L["PREFIX_HERB"]    = ""
L["PREFIX_MINE"]    = ""

L["MATCH_HERB"]    = "草药学"
L["MATCH_MINE"]    = "采矿"

L["MSG_FORMAT"]    = "{rt7} 快来拿 // 嘿 %s，我发现了一个 %s %s，但我无法 %s！坐标：%s, %s 在 %s"
