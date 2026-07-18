local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

-- Blizzard's "Item is locked" error. Herb/mine have no fixed ID; Core matches those by substring.
ns.ERROR_ID_LOCKED_CHEST = 268

ns.ANNOUNCE_COOLDOWN = 5

--------------------------------------------------------------------------------
-- Target Marker
--------------------------------------------------------------------------------

--[[
    {rt1} Star, {rt2} Circle, {rt3} Diamond, {rt4} Triangle,
    {rt5} Moon, {rt6} Square, {rt7} Cross, {rt8} Skull

    Applied at send time by ns:BuildAnnounceMessage (Features/Announcements.lua),
    so changing it here takes effect everywhere without touching locale files.
]]
ns.TARGET_MARKER = "{rt7}" -- Cross

--------------------------------------------------------------------------------
-- Output Channels
--------------------------------------------------------------------------------

--[[
    Single source of truth for output channels: Core derives its key -> command
    lookup and Options derives the dropdown from this one table, so the list, its
    order, and the command mapping can't drift. Array order is dropdown order;
    keys are saved to the DB and never localized. Adding a channel is one row
    here plus its OPTIONS_OUTPUT_* locale string.
]]
ns.OUTPUT_CHANNELS = {
	{ key = "channel1", command = "/1", labelKey = "OPTIONS_OUTPUT_CHANNEL1" },
	{ key = "say", command = "/say", labelKey = "OPTIONS_OUTPUT_SAY" },
	{ key = "yell", command = "/yell", labelKey = "OPTIONS_OUTPUT_YELL" },
	{ key = "party", command = "/party", labelKey = "OPTIONS_OUTPUT_PARTY" },
	{ key = "guild", command = "/guild", labelKey = "OPTIONS_OUTPUT_GUILD" },
}

-- Fallback when ns.db.profile.defaultOutput is unset or holds a stale key.
ns.DEFAULT_OUTPUT_CHANNEL = "channel1"

--------------------------------------------------------------------------------
-- URLs
--------------------------------------------------------------------------------

ns.URL_CURSEFORGE = "https://www.curseforge.com/wow/addons/come-get-it"
ns.URL_GITHUB = "https://github.com/Gogo1951/Come-and-Get-It"
ns.URL_DISCORD = "https://discord.gg/eh8hKq992Q"
ns.URL_WAGO = "https://addons.wago.io/addons/come-and-get-it"

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

-- Stable AceConfig registry names; referenced by NotifyChange, never built inline or localized.
ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	Profiles = ADDON_NAME .. "_Profiles",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

-- Raw hex only; the derived COLORS table and ns.GetColor live in Features/Utilities.lua.
ns.PALETTE = {
	TITLE = "FFD100", -- Gold: Titles, Headers, Section Names, Field Titles
	INFO = "00BBFF", -- Blue: Interactions, Toggles, Links, Keybinds, Slash Commands
	BODY = "FFFFFF", -- White: Descriptions, Options Body Text
	HELP = "CCCCCC", -- Silver: Pro Tips, Helper Text
	TEXT = "FFFFFF", -- White: Messages, Values, Spell Names
	ON = "33CC33", -- Green: On
	OFF = "CC3333", -- Red: Off
	SEPARATOR = "AAAAAA", -- Gray: Separators, Dividers
	MUTED = "808080", -- Dark Gray: Meta-data, Version Numbers
}
