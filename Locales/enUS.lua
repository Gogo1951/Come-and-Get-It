local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "enUS", true)
if not L then return end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Rogues"
L["HERBALISTS"] = "Herbalists"
L["MINERS"] = "Miners"

L["ACTION_OPEN"] = "open"
L["ACTION_PICK"] = "pick"
L["ACTION_MINE"] = "mine"

L["PREFIX_LOCKED"] = "a locked"
L["PREFIX_HERB"] = "some"
L["PREFIX_MINE"] = "a"

L["MATCH_HERB"] = "Herbalism"
L["MATCH_MINE"] = "Mining"

L["MSG_FORMAT"] = "Hey %s, I came across %s %s that I can't %s at %s, %s in %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Come & Get It. Enjoying the addon? Tell a friend about it! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Found an herb you can't pick, a mineral vein you can't mine, or a locked treasure chest with no Rogue in sight? Right-click it, and Come & Get It creates a message you can use to share or broadcast the coordinates. Being a hero has never been so easy."

L["OPTIONS_WELCOME_NAME"] = "Enable Welcome Message"
L["OPTIONS_WELCOME_DESC"] = "Print the welcome message in chat when you log in."

L["OPTIONS_OUTPUT_HEADER"] = "Default Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESC"] = "Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] = "Note: Local (/1) is the zone's General channel and is layer-specific — your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Local (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Say"
L["OPTIONS_OUTPUT_YELL"] = "Yell"
L["OPTIONS_OUTPUT_PARTY"] = "Party"
L["OPTIONS_OUTPUT_GUILD"] = "Guild"

L["FEEDBACK_HEADER"] = "Feedback and Support"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
