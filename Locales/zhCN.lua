local addonName, namespace = ...
if GetLocale() ~= "zhCN" then return end
local L = namespace.L

L["ROGUES"]        = "潜行者"
L["HERBALISTS"]    = "草药师"
L["MINERS"]        = "矿工"

L["ACTION_OPEN"]   = "打开"
L["ACTION_PICK"]   = "采集"
L["ACTION_MINE"]   = "开采"

L["PREFIX_LOCKED"]  = "上锁的"
L["PREFIX_HERB"]    = "一些"
L["PREFIX_MINE"]    = "一个"

L["MATCH_HERB"]    = "草药学"
L["MATCH_MINE"]    = "采矿"

L["DEFAULT_TREASURE"] = "宝箱"
L["DEFAULT_HERB"]     = "草药"
L["DEFAULT_MINE"]     = "矿脉"

L["MSG_FORMAT"]    = "{rt7} 快来拿 // 嘿 %s，我发现了%s%s，但我无法%s！坐标：%s, %s 于 %s"