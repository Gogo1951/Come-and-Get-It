local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "enUS", true)
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
    -- the bodies must stay body-only. MATCH_* must equal the profession skill
    names exactly as the game client displays them in this language (they are
    substring-matched against the client's error text).
]]

L["MATCH_HERB"] = "Herbalism"
L["MATCH_MINE"] = "Mining"

L["MSG_FORMAT_LOCKED"] = "Hey Rogues, I came across something I can't open: %s at %s, %s in %s!"
L["MSG_FORMAT_HERB"] = "Hey Herbalists, I came across something I can't pick: %s at %s, %s in %s!"
L["MSG_FORMAT_MINE"] = "Hey Miners, I came across something I can't mine: %s at %s, %s in %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Come & Get It. Enjoying the add-on? Tell a friend about it! (="

L["CHAT_TOO_LONG"] = "This announcement is %d bytes, over the %d-byte chat limit. Shorten it before sending."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Found an herb you can't pick, a mineral vein you can't mine, or a locked treasure chest with no Rogue in sight? Right-click it, and Come & Get It creates a message you can use to share or broadcast the coordinates. Being a hero has never been so easy."

L["OPTIONS_WELCOME_NAME"] = "Enable Welcome Message"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Prints the welcome message in chat when you log in."

L["OPTIONS_OUTPUT_HEADER"] = "Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] =
	"Note: Local (/1) is the zone's General channel, and it is layer-specific. Your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Local (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Say"
L["OPTIONS_OUTPUT_YELL"] = "Yell"
L["OPTIONS_OUTPUT_PARTY"] = "Party"
L["OPTIONS_OUTPUT_GUILD"] = "Guild"

L["FEEDBACK_HEADER"] = "Feedback & Support"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
