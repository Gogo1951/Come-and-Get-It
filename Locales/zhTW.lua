local addonName, namespace = ...
if GetLocale() ~= "zhTW" then return end
local L = namespace.L

L["ROGUES"]        = "盜賊"
L["HERBALISTS"]    = "草藥學家"
L["MINERS"]        = "礦工"

L["ACTION_OPEN"]   = "打開"
L["ACTION_PICK"]   = "採集"
L["ACTION_MINE"]   = "採礦"

L["PREFIX_LOCKED"]  = "上鎖的"
L["PREFIX_HERB"]    = "一些"
L["PREFIX_MINE"]    = "一個"

L["MATCH_HERB"]    = "草藥學"
L["MATCH_MINE"]    = "採礦"

L["DEFAULT_TREASURE"] = "寶箱"
L["DEFAULT_HERB"]     = "草藥"
L["DEFAULT_MINE"]     = "礦脈"

L["MSG_FORMAT"]    = "{rt7} 快來拿 // 嘿 %s，我發現了%s%s，但我無法%s！座標：%s, %s 於 %s"