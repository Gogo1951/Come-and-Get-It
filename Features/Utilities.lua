local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    Derived color tables and accessor. The raw hex palette lives in
    Data/Data.lua (Data files hold no logic). GetColor returns the prefixed
    escape string; callers append |r at point of use.
]]

local COLOR_PREFIX = "|cff"

local COLORS = {
    TITLE = COLOR_PREFIX .. ns.C_TITLE,
    INFO = COLOR_PREFIX .. ns.C_INFO,
    BODY = COLOR_PREFIX .. ns.C_BODY,
    TEXT = COLOR_PREFIX .. ns.C_TEXT,
    ON = COLOR_PREFIX .. ns.C_ON,
    OFF = COLOR_PREFIX .. ns.C_OFF,
    SEPARATOR = COLOR_PREFIX .. ns.C_SEPARATOR,
    MUTED = COLOR_PREFIX .. ns.C_MUTED
}

function ns.GetColor(key)
    return COLORS[key] or COLORS.TEXT
end
