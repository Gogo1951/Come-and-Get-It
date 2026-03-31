local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "enUS", true)
if not L then return end

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"]        = "Rogues"
L["HERBALISTS"]    = "Herbalists"
L["MINERS"]        = "Miners"

L["ACTION_OPEN"]   = "open"
L["ACTION_PICK"]   = "pick"
L["ACTION_MINE"]   = "mine"

L["PREFIX_LOCKED"] = "a locked"
L["PREFIX_HERB"]   = "some"
L["PREFIX_MINE"]   = "a"

L["MATCH_HERB"]    = "Herbalism"
L["MATCH_MINE"]    = "Mining"

L["DEFAULT_TREASURE"] = "Treasure Chest"
L["DEFAULT_HERB"]     = "Herb"
L["DEFAULT_MINE"]     = "Mineral Vein"

L["MSG_FORMAT"] = "{rt7} Come & Get It // Hey %s, I came across %s %s that I can't %s at %s, %s in %s!"

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Announces herb nodes, ore veins, and treasure chests you cannot gather so nearby group members can pick them up."

L["FEEDBACK_HEADER"]     = "Feedback and Support"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"]     = "GitHub"
L["FEEDBACK_DISCORD"]    = "Discord"