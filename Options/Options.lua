local _, ns = ...
local L = ns.L

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Called from Core's PLAYER_LOGIN, after ns.db exists -- the Profiles panel is
    built from the database, so file-scope registration would error. Child-panel
    order in Blizzard's tree follows the AddToBlizOptions call order.
]]
function ns.RegisterOptionsPanels()
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	-- Captured handles route ns:OpenOptionsPanel; a lookup by title returns nil on TBC Anniversary.
	local mainPanel, mainCategoryID = AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])
	ns.optionsFrames = { main = mainPanel, categoryID = mainCategoryID }

	-- AceDBOptions supplies its own localized name, so read it off the built table.
	local profilesOptions = ns.BuildProfilesOptions()
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, L["ADDON_TITLE"])

	-- Registered last so it sits at the bottom; the parent reference must match the name above.
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, ns.DiagnosticsStrings.TAB, L["ADDON_TITLE"])
end

--------------------------------------------------------------------------------
-- Opening the Panel
--------------------------------------------------------------------------------

--[[
    Blizzard's Settings panel is protected in combat; opening it there fires
    ADDON_ACTION_BLOCKED naming this add-on. The gate runs before any route,
    refuses with a print every time, and returns rather than queueing.
]]
function ns:OpenOptionsPanel()
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_OPTIONS_IN_COMBAT"])
		return
	end
	if not ns.optionsFrames then
		return
	end
	if Settings and Settings.OpenToCategory and ns.optionsFrames.categoryID then
		Settings.OpenToCategory(ns.optionsFrames.categoryID)
		return
	end
	if InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(ns.optionsFrames.main)
		-- Called twice for Classic compatibility
		InterfaceOptionsFrame_OpenToCategory(ns.optionsFrames.main)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

-- The combat gate lives inside ns:OpenOptionsPanel; a second check here would drift.
SLASH_COMEANDGETIT1 = "/cgi"
SlashCmdList["COMEANDGETIT"] = function()
	ns:OpenOptionsPanel()
end
