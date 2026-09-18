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

L["MSG_FORMAT_LOCKED"] = "潜行者们！%s，坐标 %s, %s（%s）。"
L["MSG_FORMAT_HERB"] = "草药师们！%s，坐标 %s, %s（%s）。"
L["MSG_FORMAT_MINE"] = "矿工们！%s，坐标 %s, %s（%s）。"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"版本 %s。设置（包括禁用此消息的选项）可以在 选项 > 插件 > Come & Get It 下找到。喜欢这个插件吗？告诉你的朋友吧！(="

L["CHAT_TOO_LONG"] = "此草稿为 %d 字节，超过了 %d 字节的聊天上限。请在发送前缩短。"

L["CHAT_OPTIONS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开选项界面。"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"发现了采不了的草药、挖不了的矿脉，或是一个上了锁的宝箱，附近却没有潜行者？右键点击它，Come & Get It 就会生成一条消息，供你分享或广播坐标。当英雄从未如此轻松。"

L["OPTIONS_WELCOME_NAME"] = "启用欢迎消息"
L["OPTIONS_WELCOME_DESCRIPTION"] = "登录时在聊天窗口打印欢迎消息。"

L["OPTIONS_COMMANDS_HEADER"] = "/命令"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开此插件的选项界面。"

L["OPTIONS_OUTPUT_HEADER"] = "输出"
L["OPTIONS_OUTPUT_NAME"] = "默认输出"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"选择草稿要打开的聊天频道；本地 (/1) 覆盖整个区域，但只有与你同层的玩家能看到。"

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
