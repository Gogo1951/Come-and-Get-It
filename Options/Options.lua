local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Called from Core's PLAYER_LOGIN, after ns.db exists -- the Profiles panel is
    built from the database, so file-scope registration would error. Child-panel
    order in Blizzard's tree follows the AddToBlizOptions call order.
]]
function ns.RegisterOptionsPanels()
	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])

	-- AceDBOptions supplies its own localized name, so read it off the built table.
	local profilesOptions = ns.BuildProfilesOptions()
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, L["ADDON_TITLE"])

	-- Registered last so it sits at the bottom; the parent reference must match the name above.
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, ns.DiagnosticsStrings.TAB, L["ADDON_TITLE"])
end
