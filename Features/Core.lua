local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

-- "Dev" until the packager substitutes the version token at build time; @ is the signal.
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

-- Hot-path globals only; ChatFrame_OpenChat runs once per cooldown window, so it stays unaliased.
local GetTime = GetTime
local IsInInstance = IsInInstance
local InCombatLockdown = InCombatLockdown
local format = string.format

-- C_Map is nil on early Classic builds; AnnounceNode bails if any alias is missing.
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
    Two key kinds in disjoint namespaces. Locked chests key on their own numeric
    error ID. Herb and mine both fire error 272 with a "Requires <Skill>" body,
    so the ID says a profession skill was missing but not which one -- only the
    localized skill name separates them, which is why they key on that.
]]
local ERROR_MAPPING = {
	[ERROR_ID_LOCKED_CHEST] = { formatKey = "MSG_FORMAT_LOCKED" },
	[L["MATCH_HERB"]] = { formatKey = "MSG_FORMAT_HERB" },
	[L["MATCH_MINE"]] = { formatKey = "MSG_FORMAT_MINE" },
}

-- Lowercased string keys, built once so the slow path never re-lowers constants.
local LOWER_MATCH = {}
for key, mapping in pairs(ERROR_MAPPING) do
	if type(key) == "string" then
		LOWER_MATCH[string.lower(key)] = mapping
	end
end

--------------------------------------------------------------------------------
-- Output Channels
--------------------------------------------------------------------------------

-- key -> slash command, derived once from the OUTPUT_CHANNELS manifest (Data.lua).
local OUTPUT_COMMAND = {}
for _, channel in ipairs(ns.OUTPUT_CHANNELS) do
	OUTPUT_COMMAND[channel.key] = channel.command
end

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

local function GetNodeName()
	if not GameTooltip or not GameTooltip:IsShown() then
		return nil
	end
	local tooltipLine = _G.GameTooltipTextLeft1
	return tooltipLine and tooltipLine:GetText()
end

--[[
    Bag lockboxes fire the same locked error as world chests. World nodes are
    never items, so an item on the tooltip means the trigger came from the bags.
    Pick one API by availability and call exactly one.
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
        ACCEPTED TRADEOFF: substring-scanning can fire on unrelated error text
        containing the skill word. Herb and mine share error 272, so the ID
        cannot pick between them and the skill name has to. Kept because
        word-boundary patterns break CJK locales and the risk is bounded --
        AnnounceNode never auto-sends.
    ]]
	local lowerMessage = string.lower(message)
	for lowerKey, mapping in pairs(LOWER_MATCH) do
		if string.find(lowerMessage, lowerKey, 1, true) then
			return mapping
		end
	end

	return nil
end

-- Runs before MatchError, so a suppressed error costs no string work.
local function CanAnnounce()
	if IsInInstance() then
		return false
	end

	--[[
        INTENTIONAL, not a bug: ChatFrame_OpenChat steals keyboard focus and
        breaks movement mid-fight. Drop the announcement rather than queue it --
        a stale callout after combat is noise, and the node re-fires its error on
        the next interaction. Do not replace this with a deferred-replay queue.
    ]]
	if InCombatLockdown() then
		return false
	end

	return GetTime() - lastAnnounceTime >= ANNOUNCE_COOLDOWN
end

--------------------------------------------------------------------------------
-- Announcement Logic
--------------------------------------------------------------------------------

local function AnnounceNode(mapping)
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

	-- No fallback name: stay silent rather than announce a generic node. The miss is logged.
	local nodeName = GetNodeName()
	if not nodeName or nodeName == "" then
		return
	end

	--[[
        A locked lockbox in the player's own bags fires the same locked error
        as a world chest; an item on the tooltip means it came from the bags,
        so drop it.
    ]]
	if TooltipShowsItem() then
		return
	end

	-- Decoration lives in ns:BuildAnnounceMessage (Announcements.lua); the MSG_FORMAT_* bodies are body-only.
	local announcement = ns:BuildAnnounceMessage(
		mapping.formatKey,
		nodeName,
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

	-- User-configurable; falls back to the manifest default if the saved key is stale.
	local channelKey = (ns.db and ns.db.profile.defaultOutput) or ns.DEFAULT_OUTPUT_CHANNEL
	local command = OUTPUT_COMMAND[channelKey] or OUTPUT_COMMAND[ns.DEFAULT_OUTPUT_CHANNEL]

	local messageLength = #announcement
	if messageLength > ns.CHAT_MESSAGE_MAX_LENGTH then
		ns:PrintMessage(format(L["CHAT_TOO_LONG"], messageLength, ns.CHAT_MESSAGE_MAX_LENGTH))
	end

	ChatFrame_OpenChat(command .. " " .. announcement, ChatFrame1)
	lastAnnounceTime = GetTime()
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

function ns:ApplyProfile()
	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
	for _, registryName in pairs(ns.OPTIONS_REGISTRY) do
		AceConfigRegistry:NotifyChange(registryName)
	end
end

--[[
    The third argument (true) puts every character on one shared "Default"
    profile. That is what makes Reset Profile a true factory reset here: it
    clears the one profile everybody is on, and since no setting lives in
    ns.db.global -- a scope ResetProfile does not touch -- nothing survives it.
    Per-character profiles stay available through the Profiles panel for anyone
    who wants them. AceDB applies the defaults via metatables -- no hand-rolled
    merge.
]]
local function InitSavedVariables()
	ns.db = LibStub("AceDB-3.0"):New("ComeAndGetItDB", ns.DATABASE_DEFAULTS, true)

	for _, message in ipairs({ "OnProfileChanged", "OnProfileReset", "OnProfileCopied" }) do
		ns.db.RegisterCallback(ns, message, "ApplyProfile")
	end

	--[[
        MIGRATION (remove after 2026-08-15): two cleanups of pre-existing saved
        state.

        Pre-AceDB builds stored settings at the root of ComeAndGetItDB; lift
        those into the active profile once, then clear the roots so AceDB owns
        them from here on.

        announceOnClick is a removed setting that AceDB never drops on its own,
        because a key absent from the defaults is just user data. Clear it from
        every stored profile rather than ns.db.profile alone, which would leave
        it behind in whichever profiles are not active at login. Never add a
        live setting to this sweep -- showWelcome and defaultOutput are stored
        here, so nilling them would wipe the player's choices every login.
    ]]
	for _, key in ipairs({ "showWelcome", "defaultOutput" }) do
		if ComeAndGetItDB[key] ~= nil then
			ns.db.profile[key] = ComeAndGetItDB[key]
			ComeAndGetItDB[key] = nil
		end
	end

	for _, profile in pairs(ns.db.profiles) do
		profile.announceOnClick = nil
	end
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

-- Single manifest: the dispatcher registers from it and Diagnostics reads it, so they can't drift.
ns.EVENT_NAMES = {
	"PLAYER_LOGIN",
	"UI_ERROR_MESSAGE",
}

local eventFrame = CreateFrame("Frame")
for _, eventName in ipairs(ns.EVENT_NAMES) do
	eventFrame:RegisterEvent(eventName)
end
eventFrame:SetScript("OnEvent", function(_, event, ...)
	-- Diagnostics tap: one boolean check, so it costs nothing when logging is off.
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
		if not CanAnnounce() then
			return
		end

		local messageID, message = ...
		local mapping = MatchError(messageID, message)
		if mapping then
			-- Capture the tooltip read at match time; a nil entry is the read-missed signal.
			if ns.diagnostics and ns.diagnostics.logging then
				ns:LogEvent("GetNodeName", GetNodeName())
			end
			AnnounceNode(mapping)
		end
	end
end)
