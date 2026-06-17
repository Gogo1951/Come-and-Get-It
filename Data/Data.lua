local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--[[
    Blizzard UI error ID for "Item is locked" — fired when a player interacts
    with a lockbox they cannot open.  Professions (herb/mine) don't use a fixed
    ID; they return a localized message string instead, so those are matched by
    substring in Core.
]]
ns.ERROR_ID_LOCKED_CHEST = 268

ns.ANNOUNCE_COOLDOWN = 5

--------------------------------------------------------------------------------
-- Target Marker
--------------------------------------------------------------------------------

--[[
    Single source of truth for the sent-message raid target marker.
    {rt1} Star, {rt2} Circle, {rt3} Diamond, {rt4} Triangle,
    {rt5} Moon, {rt6} Square, {rt7} Cross, {rt8} Skull

    Decoration is centralized: ns:BuildAnnounceMessage (Features/Announcements.lua)
    prepends this marker, the add-on name, and " // " at send time. Every locale's
    MSG_FORMAT must therefore be the message BODY ONLY -- a locale that re-bakes
    the marker/name/separator will double-prefix. This constant is the canonical
    marker; changing it takes effect everywhere without editing locale files.
]]
ns.TARGET_MARKER = "{rt7}" -- Cross

--------------------------------------------------------------------------------
-- Output Channels
--------------------------------------------------------------------------------

--[[
    Ordered manifest of chat channels the announcement draft can target. Each
    entry pairs a stable key (saved to ComeAndGetItDB.defaultOutput, never
    localized) with the slash command Core hands to ChatFrame_OpenChat and the
    locale key Options resolves for the dropdown label. Array order is dropdown
    order. This is the single source of truth: Core derives its key→command
    lookup from it and Options derives the dropdown values/sorting, so the list,
    its order, and the command mapping can never drift apart. Adding a channel
    is one row here plus its OPTIONS_OUTPUT_* locale string.

    Local (/1) is the zone General channel, which is layer-specific in Classic:
    the draft reaches the whole zone but only players on the caller's layer.
]]
ns.OUTPUT_CHANNELS = {
    {key = "channel1", command = "/1",     labelKey = "OPTIONS_OUTPUT_CHANNEL1"},
    {key = "say",      command = "/say",   labelKey = "OPTIONS_OUTPUT_SAY"},
    {key = "yell",     command = "/yell",  labelKey = "OPTIONS_OUTPUT_YELL"},
    {key = "party",    command = "/party", labelKey = "OPTIONS_OUTPUT_PARTY"},
    {key = "guild",    command = "/guild", labelKey = "OPTIONS_OUTPUT_GUILD"}
}

-- Fallback when ComeAndGetItDB.defaultOutput is unset or holds a stale key.
ns.DEFAULT_OUTPUT_CHANNEL = "channel1"

--------------------------------------------------------------------------------
-- URLs
--------------------------------------------------------------------------------

ns.URL_CURSEFORGE = "https://www.curseforge.com/wow/addons/come-get-it"
ns.URL_GITHUB = "https://github.com/Gogo1951/Come-and-Get-It"
ns.URL_DISCORD = "https://discord.gg/eh8hKq992Q"

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

--[[
    Stable AceConfig registry names, derived from the add-on name. Referenced by
    NotifyChange across the options files; never built inline, never localized.
]]
ns.OPTIONS_REGISTRY = {
    Diagnostics = ADDON_NAME .. "_Diagnostics"
}

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    Raw hex palette only. The derived COLORS table and ns.GetColor live in
    Features/Utilities.lua — Data files hold no logic.
]]
ns.C_TITLE = "FFD100"
ns.C_INFO = "00BBFF"
ns.C_BODY = "CCCCCC"
ns.C_TEXT = "FFFFFF"
ns.C_ON = "33CC33"
ns.C_OFF = "CC3333"
ns.C_SEPARATOR = "AAAAAA"
ns.C_MUTED = "808080"
