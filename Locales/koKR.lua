local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "koKR")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "도적"
L["HERBALISTS"] = "약초채집가"
L["MINERS"] = "광부"

L["ACTION_OPEN"] = "열기"
L["ACTION_PICK"] = "채집"
L["ACTION_MINE"] = "채광"

L["PREFIX_LOCKED"] = "잠긴"
L["PREFIX_HERB"] = "약간의"
L["PREFIX_MINE"] = "하나의"

L["MATCH_HERB"] = "약초채집"
L["MATCH_MINE"] = "채광"

L["MSG_FORMAT"] = "저기요 %s님, 제가 %s %s(을)를 발견했는데 %s 할 수 없네요! 위치: %s, %s (%s)"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "버전 %s. 설정(이 메시지를 비활성화하는 옵션 포함)은 설정 > 애드온 > Come & Get It 에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "채집할 수 없는 약초, 캘 수 없는 광맥, 또는 근처에 도적이 없는 잠긴 보물 상자를 발견하셨나요? 우클릭하면 Come & Get It이 좌표를 공유하거나 알릴 수 있는 메시지를 생성합니다. 영웅이 되는 것이 이렇게 쉬운 적은 없었습니다."

L["OPTIONS_WELCOME_NAME"] = "환영 메시지 활성화"
L["OPTIONS_WELCOME_DESC"] = "로그인 시 채팅창에 환영 메시지를 출력합니다."

L["OPTIONS_OUTPUT_HEADER"] = "Default Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESC"] = "Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] = "Note: Local (/1) is the zone's General channel and is layer-specific — your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "지역 (/1)"
L["OPTIONS_OUTPUT_SAY"] = "말하기"
L["OPTIONS_OUTPUT_YELL"] = "외치기"
L["OPTIONS_OUTPUT_PARTY"] = "파티"
L["OPTIONS_OUTPUT_GUILD"] = "길드"

L["FEEDBACK_HEADER"] = "피드백 및 지원"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"