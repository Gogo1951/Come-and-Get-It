local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "zhCN")
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

L["MATCH_HERB"] = "草药学"
L["MATCH_MINE"] = "采矿"

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

L["MSG_FORMAT_LOCKED"] = "潜行者们！我发现了一个我打不开的东西：%s，坐标 %s, %s（%s）！"
L["MSG_FORMAT_HERB"] = "草药师们！我发现了一个我无法采集的东西：%s，坐标 %s, %s（%s）！"
L["MSG_FORMAT_MINE"] = "矿工们！我发现了一个我无法开采的东西：%s，坐标 %s, %s（%s）！"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Come & Get It 下找到。喜欢这个插件吗？告诉你的朋友吧！(="

L["CHAT_TOO_LONG"] = "此通告为 %d 字节，超过了 %d 字节的聊天上限。请在发送前缩短。"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"发现了你无法采集的草药、无法开采的矿脉，或者是一个上锁的宝箱，而附近却没有潜行者？右键点击它，Come & Get It 会生成一条消息，你可以用来分享或广播坐标。成为英雄从未如此简单。"

L["OPTIONS_WELCOME_NAME"] = "启用欢迎消息"
L["OPTIONS_WELCOME_DESCRIPTION"] = "登录时在聊天窗口打印欢迎消息。"

L["OPTIONS_OUTPUT_HEADER"] = "输出"
L["OPTIONS_OUTPUT_NAME"] = "默认输出"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"选择将通告定向到哪个聊天频道。草稿会出现在你的聊天输入框中，你可以在发送前检查，或更改目标频道。"
L["OPTIONS_OUTPUT_NOTE"] =
	"本地 (/1) 是该区域的综合频道，且因分层而异。你的通告会传遍整个区域，但只有与你处于同一层的玩家才能看到。"

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
