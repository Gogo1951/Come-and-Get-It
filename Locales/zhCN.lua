local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "zhCN")
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

L["ROGUES"] = "潜行者"
L["HERBALISTS"] = "草药师"
L["MINERS"] = "矿工"

L["ACTION_OPEN"] = "打开"
L["ACTION_PICK"] = "采集"
L["ACTION_MINE"] = "开采"

L["PREFIX_LOCKED"] = "上锁的"
L["PREFIX_HERB"] = "一些"
L["PREFIX_MINE"] = "一个"

L["MATCH_HERB"] = "草药学"
L["MATCH_MINE"] = "采矿"

L["MSG_FORMAT"] = "嘿 %s，我发现了%s%s，但我无法%s！坐标：%s, %s 于 %s"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Come & Get It 下找到。喜欢这个插件吗？告诉你的朋友吧！(="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"发现了你无法采集的草药、无法开采的矿脉，或者是一个上锁的宝箱，而附近却没有潜行者？右键点击它，Come & Get It 会生成一条消息，你可以用来分享或广播坐标。成为英雄从未如此简单。"

L["OPTIONS_WELCOME_NAME"] = "启用欢迎消息"
L["OPTIONS_WELCOME_DESCRIPTION"] = "登录时在聊天窗口打印欢迎消息。"

L["OPTIONS_OUTPUT_HEADER"] = "输出"
L["OPTIONS_OUTPUT_NAME"] = "默认输出"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"选择将消息发送到哪个聊天频道。草稿会出现在你的聊天输入框中，你可以在发送前检查，或更改目标频道。"
L["OPTIONS_OUTPUT_NOTE"] =
	"注意：本地 (/1) 是该区域的综合频道，且因分层而异：你的消息会传遍整个区域，但只有与你处于同一层的玩家才能看到。"

L["OPTIONS_OUTPUT_CHANNEL1"] = "本地 (/1)"
L["OPTIONS_OUTPUT_SAY"] = "说"
L["OPTIONS_OUTPUT_YELL"] = "大喊"
L["OPTIONS_OUTPUT_PARTY"] = "小队"
L["OPTIONS_OUTPUT_GUILD"] = "公会"

L["FEEDBACK_HEADER"] = "反馈与支持"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
