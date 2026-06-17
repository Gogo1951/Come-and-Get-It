local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    One key per setting. Core's saved-variable init applies these as an additive
    merge: nil fields are filled, existing user values are never overwritten.
]]
ns.DEFAULT_CONFIGURATION = {
    showWelcome = true,
    defaultOutput = ns.DEFAULT_OUTPUT_CHANNEL
}
