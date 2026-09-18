local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "zhTW")
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

L["MATCH_HERB"] = "草藥學"
L["MATCH_MINE"] = "採礦"

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

L["MSG_FORMAT_LOCKED"] = "盜賊們！%s，座標 %s, %s（%s）。"
L["MSG_FORMAT_HERB"] = "草藥學家們！%s，座標 %s, %s（%s）。"
L["MSG_FORMAT_MINE"] = "礦工們！%s，座標 %s, %s（%s）。"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"版本 %s。設定（包含停用此訊息的選項）可以在 選項 > 插件 > Come & Get It 下找到。喜歡這個插件嗎？告訴你的朋友吧！(="

L["CHAT_TOO_LONG"] = "此草稿為 %d 位元組，超過了 %d 位元組的聊天上限。請在傳送前縮短。"

L["CHAT_OPTIONS_IN_COMBAT"] = "出於安全考量，戰鬥中無法開啟選項介面。"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"發現了採不了的草藥、挖不了的礦脈，或是一個上了鎖的寶箱，附近卻沒有盜賊？右鍵點擊它，Come & Get It 就會產生一則訊息，供你分享或廣播座標。當英雄從未如此輕鬆。"

L["OPTIONS_WELCOME_NAME"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_DESCRIPTION"] = "登入時在聊天視窗印出歡迎訊息。"

L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟此插件的選項介面。"

L["OPTIONS_OUTPUT_HEADER"] = "輸出"
L["OPTIONS_OUTPUT_NAME"] = "預設輸出"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"選擇草稿要開啟的聊天頻道；本地 (/1) 涵蓋整個區域，但只有與你同層的玩家能看到。"

L["OPTIONS_OUTPUT_CHANNEL1"] = "本地 (/1)"
L["OPTIONS_OUTPUT_SAY"] = "說"
L["OPTIONS_OUTPUT_YELL"] = "大喊"
L["OPTIONS_OUTPUT_PARTY"] = "隊伍"
L["OPTIONS_OUTPUT_GUILD"] = "公會"

L["FEEDBACK_HEADER"] = "回饋與支援"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
