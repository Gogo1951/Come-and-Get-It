local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

-- Raw palette is ns.PALETTE (Data/Data.lua). GetColor returns the escape; callers append |r.

local COLOR_PREFIX = "|cff"

local COLORS = {
	TITLE = COLOR_PREFIX .. ns.PALETTE.TITLE,
	INFO = COLOR_PREFIX .. ns.PALETTE.INFO,
	BODY = COLOR_PREFIX .. ns.PALETTE.BODY,
	HELP = COLOR_PREFIX .. ns.PALETTE.HELP,
	TEXT = COLOR_PREFIX .. ns.PALETTE.TEXT,
	ON = COLOR_PREFIX .. ns.PALETTE.ON,
	OFF = COLOR_PREFIX .. ns.PALETTE.OFF,
	SEPARATOR = COLOR_PREFIX .. ns.PALETTE.SEPARATOR,
	MUTED = COLOR_PREFIX .. ns.PALETTE.MUTED,
}

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end
