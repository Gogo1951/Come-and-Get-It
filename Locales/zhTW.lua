local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "zhTW")
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

L["ROGUES"] = "盜賊"
L["HERBALISTS"] = "草藥學家"
L["MINERS"] = "礦工"

L["ACTION_OPEN"] = "打開"
L["ACTION_PICK"] = "採集"
L["ACTION_MINE"] = "採礦"

L["PREFIX_LOCKED"] = "上鎖的"
L["PREFIX_HERB"] = "一些"
L["PREFIX_MINE"] = "一個"

L["MATCH_HERB"] = "草藥學"
L["MATCH_MINE"] = "採礦"

L["MSG_FORMAT"] = "嘿 %s，我發現了%s%s，但我無法%s！座標：%s, %s 於 %s"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"版本 %s。設定（包含停用此訊息的選項）可以在 選項 > 插件 > Come & Get It 下找到。喜歡這個插件嗎？告訴你的朋友吧！(="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"發現了你無法採集的草藥、無法開採的礦脈，或者是一個上鎖的寶箱，而附近卻沒有盜賊？右鍵點擊它，Come & Get It 會產生一條訊息，你可以用來分享或廣播座標。成為英雄從未如此簡單。"

L["OPTIONS_WELCOME_NAME"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_DESC"] = "登入時在聊天視窗印出歡迎訊息。"

L["OPTIONS_OUTPUT_NAME"] = "預設輸出"
L["OPTIONS_OUTPUT_DESC"] =
	"選擇將訊息傳送到哪個聊天頻道。草稿會出現在你的聊天輸入框中，你可以在傳送前檢查，或更改目標頻道。"
L["OPTIONS_OUTPUT_NOTE"] =
	"注意：本地 (/1) 是該區域的綜合頻道，且會因分層而異：你的訊息會傳遍整個區域，但只有與你處於同一層的玩家才能看到。"

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
