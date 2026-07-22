local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    All settings live under `profile` so they follow the active profile; AceDB
    applies them via metatables. No `global` subtable -- that is reserved for a
    minimap position, and this add-on has no minimap button.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		showWelcome = true,
		defaultOutput = ns.DEFAULT_OUTPUT_CHANNEL,
	},
}
