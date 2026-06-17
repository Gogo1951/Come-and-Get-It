local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "zhTW")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

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

L["CHAT_LOADED"] = "版本 %s。設定（包含停用此訊息的選項）可以在 選項 > 插件 > Come & Get It 下找到。喜歡這個插件嗎？告訴你的朋友吧！(="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "發現了你無法採集的草藥、無法開採的礦脈，或者是一個上鎖的寶箱，而附近卻沒有盜賊？右鍵點擊它，Come & Get It 會產生一條訊息，你可以用來分享或廣播座標。成為英雄從未如此簡單。"

L["OPTIONS_WELCOME_NAME"] = "啟用歡迎訊息"
L["OPTIONS_WELCOME_DESC"] = "登入時在聊天視窗印出歡迎訊息。"

L["OPTIONS_OUTPUT_HEADER"] = "Default Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESC"] = "Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] = "Note: Local (/1) is the zone's General channel and is layer-specific — your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "本地 (/1)"
L["OPTIONS_OUTPUT_SAY"] = "說"
L["OPTIONS_OUTPUT_YELL"] = "大喊"
L["OPTIONS_OUTPUT_PARTY"] = "隊伍"
L["OPTIONS_OUTPUT_GUILD"] = "公會"

L["FEEDBACK_HEADER"] = "回饋與支援"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"