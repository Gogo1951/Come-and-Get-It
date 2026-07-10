local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Called from Core's PLAYER_LOGIN handler, after ns.db exists: the Profiles
    panel is built from AceDBOptions:GetOptionsTable(ns.db), so registering at
    file scope (before the database is created) would error.

    Child-panel order in Blizzard's settings tree is the order of the
    AddToBlizOptions calls: General (root) -> Profiles -> Diagnostic Tools last.
]]
function ns.RegisterOptionsPanels()
	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, L["ADDON_TITLE"])

	--[[
        Profiles panel. Its display name comes already localized from
        AceDBOptions, so we read the built table's own `name` field rather than a
        locale key of our own.
    ]]
	local profilesOptions = ns.BuildProfilesOptions()
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, L["ADDON_TITLE"])

	--[[
        Diagnostic Tools register last so the child panel sits at the bottom of
        the settings tree. The parent reference must match the display name above.
    ]]
	AceConfigRegistry:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, ns.DiagnosticsStrings.TAB, L["ADDON_TITLE"])
end
