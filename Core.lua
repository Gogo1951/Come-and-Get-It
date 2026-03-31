local addonName, namespace = ...
local L = LibStub("AceLocale-3.0"):GetLocale("ComeAndGetIt")

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

local ERROR_ID_LOCKED_CHEST = namespace.ERROR_ID_LOCKED_CHEST
local ANNOUNCE_COOLDOWN     = namespace.ANNOUNCE_COOLDOWN

--------------------------------------------------------------------------------
-- Performance Aliases
--------------------------------------------------------------------------------

-- Only aliasing hot-path globals and long C_Map paths; ChatFrame_OpenChat is
-- called at most once per cooldown window so it stays unaliased.
local GetTime       = GetTime
local IsInInstance  = IsInInstance
local format        = string.format

-- C_Map may be nil on very early Classic builds; each reference is guarded at
-- the call site in AnnounceNode().
local GetBestMapForUnit    = C_Map and C_Map.GetBestMapForUnit
local GetPlayerMapPosition = C_Map and C_Map.GetPlayerMapPosition
local GetMapInfo           = C_Map and C_Map.GetMapInfo

--------------------------------------------------------------------------------
-- State
--------------------------------------------------------------------------------

local lastAnnounceTime = 0

--------------------------------------------------------------------------------
-- Error Mapping
--------------------------------------------------------------------------------

-- Maps either a numeric error ID or a localized profession-skill substring to
-- the data needed to build the announcement.  Locked chests use the integer
-- because Blizzard fires a stable error ID.  Herb and mining nodes fire a
-- generic "Requires <Skill>" message, so we match on the localized skill name.
local ERROR_MAPPING = {
    [ERROR_ID_LOCKED_CHEST] = {
        role        = L["ROGUES"],
        prefix      = L["PREFIX_LOCKED"],
        defaultNode = L["DEFAULT_TREASURE"],
        action      = L["ACTION_OPEN"],
    },
    [L["MATCH_HERB"]] = {
        role        = L["HERBALISTS"],
        prefix      = L["PREFIX_HERB"],
        defaultNode = L["DEFAULT_HERB"],
        action      = L["ACTION_PICK"],
    },
    [L["MATCH_MINE"]] = {
        role        = L["MINERS"],
        prefix      = L["PREFIX_MINE"],
        defaultNode = L["DEFAULT_MINE"],
        action      = L["ACTION_MINE"],
    },
}

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

    -- Slow path: profession errors only give us a localized message string,
    -- so we scan for a substring match against the skill name.
    local lowerMessage = string.lower(message)
    for key, mapping in pairs(ERROR_MAPPING) do
        if type(key) == "string" and string.find(lowerMessage, string.lower(key), 1, true) then
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

    local now = GetTime()
    if now - lastAnnounceTime < ANNOUNCE_COOLDOWN then
        return
    end

    -- C_Map APIs are nil on some Classic Era builds where world-map position
    -- tracking was added later.  Bail gracefully rather than error.
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

    local nodeName = GetNodeName() or mapping.defaultNode
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

    local announcement = format(
        L["MSG_FORMAT"],
        mapping.role,
        currentPrefix,
        nodeName,
        mapping.action,
        format("%.0f", position.x * 100),
        format("%.0f", position.y * 100),
        mapInfo.name
    )

    ChatFrame_OpenChat("/1 " .. announcement, ChatFrame1)
    lastAnnounceTime = now
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("UI_ERROR_MESSAGE")
eventFrame:SetScript("OnEvent", function(_, _, messageID, message)
    local mapping = MatchError(messageID, message)
    if mapping then
        AnnounceNode(mapping)
    end
end)