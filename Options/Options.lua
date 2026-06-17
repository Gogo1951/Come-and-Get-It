local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(ADDON_NAME, ns.BuildGeneralOptions())
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME, L["ADDON_TITLE"])

--[[
    Diagnostic Tools register last so the child panel sits at the bottom of the
    settings tree. The parent reference must match the display name above.
]]
LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(
    ns.OPTIONS_REGISTRY.Diagnostics,
    ns.BuildDiagnosticsOptions()
)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
    ns.OPTIONS_REGISTRY.Diagnostics,
    ns.DiagnosticsStrings.TAB,
    L["ADDON_TITLE"]
)
