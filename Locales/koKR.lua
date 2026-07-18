local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "koKR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

--[[
    Translator guidance. MSG_FORMAT is the announcement body; the code fills its
    seven %s placeholders in this fixed order: role (ROGUES / HERBALISTS /
    MINERS), prefix (PREFIX_*), node name, action verb (ACTION_*), x coordinate,
    y coordinate, zone name. Reorder the sentence freely for your language, but
    never reorder, add, or drop placeholders. PREFIX_* is the article/quantity
    word placed directly before the node name; ACTION_* is the verb the player
    cannot perform. The raid marker, add-on name, and " // " separator are
    prepended by the code -- MSG_FORMAT must stay body-only. MATCH_* must equal
    the profession skill names exactly as the game client displays them in this
    language (they are substring-matched against the client's error text).
]]

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

L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지를 비활성화하는 옵션 포함)은 설정 > 애드온 > Come & Get It 에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"채집할 수 없는 약초, 캘 수 없는 광맥, 또는 근처에 도적이 없는 잠긴 보물 상자를 발견하셨나요? 우클릭하면 Come & Get It이 좌표를 공유하거나 알릴 수 있는 메시지를 생성합니다. 영웅이 되는 것이 이렇게 쉬운 적은 없었습니다."

L["OPTIONS_WELCOME_NAME"] = "환영 메시지 활성화"
L["OPTIONS_WELCOME_DESCRIPTION"] = "로그인 시 채팅창에 환영 메시지를 출력합니다."

L["OPTIONS_OUTPUT_HEADER"] = "출력"
L["OPTIONS_OUTPUT_NAME"] = "기본 출력"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"공지를 어느 채팅 채널로 보낼지 선택합니다. 초안이 채팅 입력창에 표시되므로 보내기 전에 검토하거나 다른 채널로 변경할 수 있습니다."
L["OPTIONS_OUTPUT_NOTE"] =
	"참고: 지역 (/1)은 현재 지역의 공개 채널이며 레이어별로 분리됩니다. 메시지는 지역 전체에 전달되지만, 현재 레이어에 있는 플레이어만 볼 수 있습니다."

L["OPTIONS_OUTPUT_CHANNEL1"] = "지역 (/1)"
L["OPTIONS_OUTPUT_SAY"] = "말하기"
L["OPTIONS_OUTPUT_YELL"] = "외치기"
L["OPTIONS_OUTPUT_PARTY"] = "파티"
L["OPTIONS_OUTPUT_GUILD"] = "길드"

L["FEEDBACK_HEADER"] = "피드백 및 지원"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
