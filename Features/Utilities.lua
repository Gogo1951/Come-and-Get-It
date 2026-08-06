local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

-- Raw palette is ns.PALETTE (Data/Data.lua). GetColor returns the escape; callers append |r.

local COLOR_PREFIX = "|cff"

local COLORS = {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = COLOR_PREFIX .. hex
end

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end
