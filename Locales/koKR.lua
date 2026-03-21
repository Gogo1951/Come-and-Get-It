local addonName, namespace = ...
if GetLocale() ~= "koKR" then return end
local L = namespace.L

L["ROGUES"]        = "도적"
L["HERBALISTS"]    = "약초채집가"
L["MINERS"]        = "채광사"

L["ACTION_OPEN"]   = "열기"
L["ACTION_PICK"]   = "채집"
L["ACTION_MINE"]   = "채광"

L["PREFIX_LOCKED"]  = "잠긴"
L["PREFIX_HERB"]    = ""
L["PREFIX_MINE"]    = ""

L["MATCH_HERB"]    = "약초채집"
L["MATCH_MINE"]    = "채광"

L["MSG_FORMAT"]    = "{rt7} 와서 가져가세요 // 저기요 %s님, %s %s(을)를 발견했는데 %s 할 수 없네요! 위치: %s, %s (%s)"
