local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "koKR")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Skill Names
--------------------------------------------------------------------------------

--[[
    Not display copy. MATCH_* must equal the profession skill names exactly as
    the game client displays them in this language: they are substring-matched
    against the client's error text, so a loose or stylized translation silently
    stops the add-on from detecting anything at all.
]]

L["MATCH_HERB"] = "약초채집"
L["MATCH_MINE"] = "채광"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

--[[
    Translator guidance. Each MSG_FORMAT_* string is the complete line sent to
    chat, picked by what the player could not interact with. The code fills four
    %s placeholders in this fixed order: node name, x coordinate, y coordinate,
    zone name. Reorder the sentence freely for your language, but never reorder,
    add, or drop placeholders.

    The greeting closes on "!" so the node name starts a fresh clause with nothing
    in front of it. That is load-bearing, not stylistic: no article or adjective
    has to agree with a name whose gender and number are unknown until runtime, and
    English dodges a/an ("an Iron Deposit" vs "a Gold Vein") for free. If your
    language reads better with an article, attach it to a fixed word rather than to
    the placeholder.

    Don't add a raid marker or the add-on name: WoW Forever blocks raid markers
    in chat, and the line reads as the player talking.
]]

L["MSG_FORMAT_LOCKED"] = "도적 여러분! %s, 위치 %s, %s (%s)."
L["MSG_FORMAT_HERB"] = "약초채집가 여러분! %s, 위치 %s, %s (%s)."
L["MSG_FORMAT_MINE"] = "광부 여러분! %s, 위치 %s, %s (%s)."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"버전 %s. 설정(이 메시지를 비활성화하는 옵션 포함)은 설정 > 애드온 > Come & Get It에서 찾을 수 있습니다. 애드온이 마음에 드시나요? 친구에게 알려주세요! (="

L["CHAT_TOO_LONG"] =
	"이 초안은 %d바이트로 채팅 제한인 %d바이트를 초과합니다. 보내기 전에 줄여주세요."

L["CHAT_OPTIONS_IN_COMBAT"] = "안전을 위해 전투 중에는 설정 창을 열 수 없습니다."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"채집할 수 없는 약초, 캘 수 없는 광맥, 아니면 주변에 도적도 없는데 잠겨 있는 보물 상자를 발견하셨나요? 우클릭하면 Come & Get It이 좌표를 공유하거나 널리 알릴 수 있는 메시지를 만들어 줍니다. 영웅이 되는 일이 이렇게 쉬웠던 적은 없습니다."

L["OPTIONS_WELCOME_NAME"] = "환영 메시지 활성화"
L["OPTIONS_WELCOME_DESCRIPTION"] = "로그인 시 채팅창에 환영 메시지를 출력합니다."

L["OPTIONS_COMMANDS_HEADER"] = "/명령어"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "이 애드온의 설정 창을 엽니다."

L["OPTIONS_OUTPUT_HEADER"] = "출력"
L["OPTIONS_OUTPUT_NAME"] = "기본 출력"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"초안이 열릴 채팅 채널을 선택합니다. 지역 (/1)은 지역 전체에 전달되지만, 현재 레이어의 플레이어만 볼 수 있습니다."

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
