local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. One key per setting, all under `profile` so every setting
    follows the active profile. AceDB applies these via metatables — there is no
    hand-rolled merge and no per-scope copy step. There is no `global` subtable:
    it is reserved for a minimap position, and this add-on has no minimap button.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		showWelcome = true,
		defaultOutput = ns.DEFAULT_OUTPUT_CHANNEL,
	},
}
