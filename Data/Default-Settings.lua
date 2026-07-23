local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    Come & Get It is a Simple add-on: every setting lives under `profile`, and
    Core puts all characters on one shared "Default" profile, so settings are
    account-wide in practice and Reset Profile restores every one of them to its
    install value. Nothing goes in `global` -- AceDB's ResetProfile does not
    touch that scope, so a setting parked there would survive a reset and make
    the Profiles panel lie. AceDB applies these via metatables.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		showWelcome = true,
		defaultOutput = ns.DEFAULT_OUTPUT_CHANNEL,
	},
}
