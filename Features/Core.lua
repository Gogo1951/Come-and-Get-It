local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

--[[
    Add-on identity lives in Core (Style Guide FILE STRUCTURE); Data.lua holds no
    logic. Version is "Dev" when the @project-version@ TOC token is left
    unsubstituted in a local/dev checkout -- the packager replaces it on build.
]]
local function GetVersion()
    local getMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local version = getMetadata and getMetadata(ADDON_NAME, "Version")
    if not version or version:find("@") then
        return "Dev"
    end
    return version
end

ns.Version = GetVersion()

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

local ERROR_ID_LOCKED_CHEST = ns.ERROR_ID_LOCKED_CHEST
local ANNOUNCE_COOLDOWN = ns.ANNOUNCE_COOLDOWN

--------------------------------------------------------------------------------
-- Performance Aliases
--------------------------------------------------------------------------------

--[[
    Only aliasing hot-path globals and long C_Map paths; ChatFrame_OpenChat is
    called at most once per cooldown window so it stays unaliased.
]]
local GetTime = GetTime
local IsInInstance = IsInInstance
local InCombatLockdown = InCombatLockdown
local format = string.format

--[[
    C_Map may be nil on very early Classic builds; each reference is guarded at
    the call site in AnnounceNode().
]]
local GetBestMapForUnit = C_Map and C_Map.GetBestMapForUnit
local GetPlayerMapPosition = C_Map and C_Map.GetPlayerMapPosition
local GetMapInfo = C_Map and C_Map.GetMapInfo

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local lastAnnounceTime = 0

--------------------------------------------------------------------------------
-- Error Mapping
--------------------------------------------------------------------------------

--[[
    Maps either a numeric error ID or a localized profession-skill substring to
    the data needed to build the announcement.  Locked chests use the integer
    because Blizzard fires a stable error ID.  Herb and mining nodes fire a
    generic "Requires <Skill>" message, so we match on the localized skill name.
]]
local ERROR_MAPPING = {
    [ERROR_ID_LOCKED_CHEST] = {
        role = L["ROGUES"],
        prefix = L["PREFIX_LOCKED"],
        action = L["ACTION_OPEN"],
    },
    [L["MATCH_HERB"]] = {
        role = L["HERBALISTS"],
        prefix = L["PREFIX_HERB"],
        action = L["ACTION_PICK"],
    },
    [L["MATCH_MINE"]] = {
        role = L["MINERS"],
        prefix = L["PREFIX_MINE"],
        action = L["ACTION_MINE"],
    },
}

--[[
    Derived lowercased substring lookup for the gather slow path: every STRING
    key of ERROR_MAPPING, lowercased once here at load, mapped to its mapping
    table. The numeric locked-chest key is excluded -- it takes the fast path.
    Hoisting the lowercasing here keeps the per-UI_ERROR_MESSAGE slow path free
    of repeated string.lower on constants. See MatchError for the
    accepted-tradeoff rationale behind the substring match itself.
]]
local LOWER_MATCH = {}
for key, mapping in pairs(ERROR_MAPPING) do
    if type(key) == "string" then
        LOWER_MATCH[string.lower(key)] = mapping
    end
end

--------------------------------------------------------------------------------
-- Output Channels
--------------------------------------------------------------------------------

--[[
    Derived key→slash-command lookup, built once from the OUTPUT_CHANNELS
    manifest (Data.lua) so the announcement path stays a single hash read.
]]
local OUTPUT_COMMAND = {}
for _, channel in ipairs(ns.OUTPUT_CHANNELS) do
    OUTPUT_COMMAND[channel.key] = channel.command
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

local function GetNodeName()
    local tooltipLine = _G.GameTooltipTextLeft1
    return tooltipLine and tooltipLine:GetText()
end

local function MatchError(messageID, message)
    -- Fast path: locked chests fire a known numeric ID.
    if ERROR_MAPPING[messageID] then
        return ERROR_MAPPING[messageID]
    end

    if not message then
        return nil
    end

    --[[
        Slow path: gather errors carry only a localized "Requires <skill>"
        string, so we substring-scan it for the skill name (L["MATCH_HERB"] /
        L["MATCH_MINE"]).

        ACCEPTED TRADEOFF: a plain substring can in theory fire on unrelated
        error text that contains the skill word. We keep it because there is no
        safer signal that holds across all four clients -- the gather error has
        no numeric ID stable across them (it would drift like
        ERROR_ID_LOCKED_CHEST in Data.lua) and no ERR_* global is verified to
        carry this exact string identically on Classic Era / TBC / MoP / Retail
        (Retail's per-expansion professions make it doubtful). Lua word-boundary
        patterns are out too: they break CJK locales (koKR/zhCN/zhTW). Residual
        risk is bounded by AnnounceNode below, which only fires with a live
        tooltip node name and never auto-sends (it opens the chat editbox; the
        user still presses Enter). Revisit only if a stable per-client gather
        signal is verified in-game.
    ]]
    local lowerMessage = string.lower(message)
    for lowerKey, mapping in pairs(LOWER_MATCH) do
        if string.find(lowerMessage, lowerKey, 1, true) then
            return mapping
        end
    end

    return nil
end

--------------------------------------------------------------------------------
-- Announcement Logic
--------------------------------------------------------------------------------

local function AnnounceNode(mapping)
    if IsInInstance() then
        return
    end

    --[[
        INTENTIONAL — by design, not a bug. Do not "fix" by announcing in
        combat. AnnounceNode() opens the chat editbox (ChatFrame_OpenChat),
        which steals keyboard focus and breaks WASD movement mid-fight. We
        deliberately drop the announcement entirely while in combat rather than
        queue it, since a stale node callout after combat ends is noise. Nodes
        are re-detected on the next gather/loot error once combat drops.
    ]]
    if InCombatLockdown() then
        return
    end

    local now = GetTime()
    if now - lastAnnounceTime < ANNOUNCE_COOLDOWN then
        return
    end

    --[[
        C_Map APIs are nil on some Classic Era builds where world-map position
        tracking was added later.  Bail gracefully rather than error.
    ]]
    if not GetBestMapForUnit or not GetPlayerMapPosition or not GetMapInfo then
        return
    end

    local mapID = GetBestMapForUnit("player")
    if not mapID then
        return
    end

    local position = GetPlayerMapPosition(mapID, "player")
    if not position then
        return
    end

    local mapInfo = GetMapInfo(mapID)
    if not mapInfo or not mapInfo.name then
        return
    end

    --[[
        No fallback name: if the tooltip read comes back nil/empty we stay
        silent rather than announce a generic node. The miss is logged in the
        UI_ERROR_MESSAGE handler below (GetNodeName tap) so reports can surface
        it instead of it hiding behind a vague message.
    ]]
    local nodeName = GetNodeName()
    if not nodeName or nodeName == "" then
        return
    end

    -- English indefinite article correction: "a Arcane Crystal" → "an Arcane Crystal"
    local currentPrefix = mapping.prefix
    local currentLocale = GetLocale()
    if (currentLocale == "enUS" or currentLocale == "enGB")
        and currentPrefix == "a"
        and string.find(nodeName, "^[AEIOUaeiou]")
    then
        currentPrefix = "an"
    end

    --[[
        Message decoration (marker, add-on name, " // " separator) is centralized
        in ns:BuildAnnounceMessage (Announcements.lua); MSG_FORMAT is the locale
        body only.
    ]]
    local announcement = ns:BuildAnnounceMessage(
        "MSG_FORMAT",
        mapping.role,
        currentPrefix,
        nodeName,
        mapping.action,
        format("%.0f", position.x * 100),
        format("%.0f", position.y * 100),
        mapInfo.name
    )

    -- Don't clobber a draft the user is already typing in any chat editbox.
    if ChatEdit_GetActiveWindow and ChatEdit_GetActiveWindow() then
        return
    end

    --[[
        The output channel is user-configurable (Options > Default Output).
        Fall back to the manifest default if the saved key is missing or stale.
    ]]
    local channelKey = (ComeAndGetItDB and ComeAndGetItDB.defaultOutput) or ns.DEFAULT_OUTPUT_CHANNEL
    local command = OUTPUT_COMMAND[channelKey] or OUTPUT_COMMAND[ns.DEFAULT_OUTPUT_CHANNEL]

    ChatFrame_OpenChat(command .. " " .. announcement, ChatFrame1)
    lastAnnounceTime = now
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

local function InitSavedVariables()
    ComeAndGetItDB = ComeAndGetItDB or {}
    for key, value in pairs(ns.DEFAULT_CONFIGURATION) do
        if ComeAndGetItDB[key] == nil then
            ComeAndGetItDB[key] = value
        end
    end
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

--[[
    Single event manifest, shared with Diagnostics (ns.EVENT_NAMES) so its event
    log and registration checks can never drift from what the dispatcher
    registers.
]]
ns.EVENT_NAMES = {
    "PLAYER_LOGIN",
    "UI_ERROR_MESSAGE"
}

local eventFrame = CreateFrame("Frame")
for _, eventName in ipairs(ns.EVENT_NAMES) do
    eventFrame:RegisterEvent(eventName)
end
eventFrame:SetScript("OnEvent", function(_, event, ...)
    --[[
        Diagnostics event-log tap. Guarded by a single boolean so it costs
        nothing when logging is off; runs before the real handler.
    ]]
    if ns.diagnostics and ns.diagnostics.logging then
        ns:LogEvent(event, ...)
    end

    if event == "PLAYER_LOGIN" then
        InitSavedVariables()
        ns:PrintWelcome()
        return
    end

    if event == "UI_ERROR_MESSAGE" then
        local messageID, message = ...
        local mapping = MatchError(messageID, message)
        if mapping then
            --[[
                Diagnostics tap for the node-name read: capture GetNodeName() at
                the instant a gather error matches — the one input AnnounceNode
                depends on that the raw event args don't carry. Logged only for
                matched errors so the log stays signal-rich, and gated on the
                same flag as the dispatcher tap above. A "GetNodeName(nil)" entry
                is the tooltip-read-missed signal we want reports to surface.
            ]]
            if ns.diagnostics and ns.diagnostics.logging then
                ns:LogEvent("GetNodeName", GetNodeName())
            end
            AnnounceNode(mapping)
        end
    end
end)
