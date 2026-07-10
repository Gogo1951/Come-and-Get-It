local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

--[[
    Version is "Dev" when the @project-version@ token is unreplaced (a dev copy);
    the packager substitutes the real version at build time. The @ is the signal.
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
    Lowercased lookup of ERROR_MAPPING's string keys, built once at load so the
    per-error slow path skips repeated string.lower on constants. Numeric keys
    are excluded -- they take the fast path.
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

--[[
    Bag lockboxes fire the same "Item is locked" error (ERROR_ID_LOCKED_CHEST) as
    world treasure chests, but the tooltip is then describing the carried item.
    World nodes (herbs, veins, chests) are never items, so an item on the tooltip
    is the discriminator: it means the trigger came from the bags, not the world.
    Pick one API by availability per the COMPATIBILITY rule and call exactly one.
]]
local function TooltipShowsItem()
	if TooltipUtil and TooltipUtil.GetDisplayedItem then
		local name, link = TooltipUtil.GetDisplayedItem(GameTooltip)
		return name ~= nil or link ~= nil
	end
	if GameTooltip.GetItem then
		local name, link = GameTooltip:GetItem()
		return name ~= nil or link ~= nil
	end
	return false
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
        string, so we substring-scan it for the skill name.

        ACCEPTED TRADEOFF: a substring can in theory fire on unrelated error text
        containing the skill word. Kept because no gather error has a numeric ID
        stable across the supported clients, word-boundary patterns break CJK
        locales, and the residual risk is bounded -- AnnounceNode never auto-sends
        (it opens the chat editbox; the user still presses Enter).
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

	-- A locked lockbox in the player's own bags fires the same locked error as a
	-- world chest; an item on the tooltip means it came from the bags, so drop it.
	if TooltipShowsItem() then
		return
	end

	-- English indefinite article correction: "a Arcane Crystal" → "an Arcane Crystal"
	local currentPrefix = mapping.prefix
	local currentLocale = GetLocale()
	if
		(currentLocale == "enUS" or currentLocale == "enGB")
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
	if not announcement then
		return
	end

	-- Don't clobber a draft the user is already typing in any chat editbox.
	if ChatEdit_GetActiveWindow and ChatEdit_GetActiveWindow() then
		return
	end

	--[[
        The output channel is user-configurable (Options > Output). Fall back to
        the manifest default if the saved key is missing or stale.
    ]]
	local channelKey = (ns.db and ns.db.profile.defaultOutput) or ns.DEFAULT_OUTPUT_CHANNEL
	local command = OUTPUT_COMMAND[channelKey] or OUTPUT_COMMAND[ns.DEFAULT_OUTPUT_CHANNEL]

	ChatFrame_OpenChat(command .. " " .. announcement, ChatFrame1)
	lastAnnounceTime = now
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

--[[
    Creates the AceDB-3.0 database. The third argument (true) puts every character
    on one shared "Default" profile out of the box; per-character profiles are
    opt-in via the Profiles panel. AceDB applies ns.DATABASE_DEFAULTS via
    metatables, so there is no hand-rolled merge.
]]
local function InitSavedVariables()
	ns.db = LibStub("AceDB-3.0"):New("ComeAndGetItDB", ns.DATABASE_DEFAULTS, true)

	--[[
        MIGRATION (remove after 2026-10-08): move flat ComeAndGetItDB keys into
        the AceDB profile. Pre-AceDB builds stored settings at the root of the
        saved table; lift them into the active profile once, then clear the roots
        so AceDB owns them from here on.
    ]]
	for _, key in ipairs({ "showWelcome", "defaultOutput" }) do
		if ComeAndGetItDB[key] ~= nil then
			ns.db.profile[key] = ComeAndGetItDB[key]
			ComeAndGetItDB[key] = nil
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
	"UI_ERROR_MESSAGE",
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
		ns.RegisterOptionsPanels()
		ns:PrintWelcome()
		return
	end

	if event == "UI_ERROR_MESSAGE" then
		local messageID, message = ...
		local mapping = MatchError(messageID, message)
		if mapping then
			--[[
                Diagnostics tap: capture the node-name read at match time -- the
                one input AnnounceNode depends on that the event args don't carry.
                A "GetNodeName(nil)" entry is the tooltip-read-missed signal.
            ]]
			if ns.diagnostics and ns.diagnostics.logging then
				ns:LogEvent("GetNodeName", GetNodeName())
			end
			AnnounceNode(mapping)
		end
	end
end)
