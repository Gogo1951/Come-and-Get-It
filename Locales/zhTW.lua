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
    Translator guidance. Each MSG_FORMAT_* string is one complete announcement
    body, picked by what the player could not interact with. The code fills four
    %s placeholders in this fixed order: node name, x coordinate, y coordinate,
    zone name. Reorder the sentence freely for your language, but never reorder,
    add, or drop placeholders.

    Nothing precedes the node name, so no article or adjective has to agree with
    a name whose gender and number are unknown until runtime. Keep that property:
    if your language reads better with an article, restructure the sentence so
    the article attaches to a fixed word rather than to the placeholder.

    The raid marker, add-on name, and " // " separator are prepended by the code
    -- the bodies must stay body-only.
]]

L["MSG_FORMAT_LOCKED"] = "盜賊們！我發現了一個我打不開的東西：%s，座標 %s, %s（%s）！"
L["MSG_FORMAT_HERB"] = "草藥學家們！我發現了一個我無法採集的東西：%s，座標 %s, %s（%s）！"
L["MSG_FORMAT_MINE"] = "礦工們！我發現了一個我無法開採的東西：%s，座標 %s, %s（%s）！"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"版本 %s。設定（包含停用此訊息的選項）可以在 選項 > 插件 > Come & Get It 下找到。喜歡這個插件嗎？告訴你的朋友吧！(="

L["CHAT_TOO_LONG"] = "此通告為 %d 位元組，超過了 %d 位元組的聊天上限。請在傳送前縮短。"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"發現了你無法採集的草藥、無法開採的礦脈，或者是一個上鎖的寶箱，而附近卻沒有盜賊？右鍵點擊它，Come & Get It 會產生一條訊息，你可以用來分享或廣播座標。成為英雄從未如此簡單。"

L["OPTIONS_WELCOME_NAME"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_DESCRIPTION"] = "登入時在聊天視窗印出歡迎訊息。"

L["OPTIONS_OUTPUT_HEADER"] = "輸出"
L["OPTIONS_OUTPUT_NAME"] = "預設輸出"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"選擇將通告定向到哪個聊天頻道。草稿會出現在你的聊天輸入框中，你可以在傳送前檢查，或更改目標頻道。"
L["OPTIONS_OUTPUT_NOTE"] =
	"本地 (/1) 是該區域的綜合頻道，且會因分層而異。你的通告會傳遍整個區域，但只有與你處於同一層的玩家才能看到。"

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
