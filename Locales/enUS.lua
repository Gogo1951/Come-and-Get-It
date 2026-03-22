local addonName, namespace = ...

--------------------------------------------------------------------------------
-- Locale Bootstrap
--------------------------------------------------------------------------------

-- Every locale falls back to enUS via __index, so new keys added here
-- automatically appear in all languages until a translation is provided.

namespace.L = setmetatable({}, { __index = function(table, key)
    return key
end })

local L = namespace.L

--------------------------------------------------------------------------------
-- English (enUS / enGB)
--------------------------------------------------------------------------------

L["ROGUES"]        = "Rogues"
L["HERBALISTS"]    = "Herbalists"
L["MINERS"]        = "Miners"

L["ACTION_OPEN"]   = "open"
L["ACTION_PICK"]   = "pick"
L["ACTION_MINE"]   = "mine"

L["PREFIX_LOCKED"]  = "a locked"
L["PREFIX_HERB"]    = "some"
L["PREFIX_MINE"]    = "a"

L["MATCH_HERB"]    = "Herbalism"
L["MATCH_MINE"]    = "Mining"

L["DEFAULT_TREASURE"] = "Treasure Chest"
L["DEFAULT_HERB"]     = "Herb"
L["DEFAULT_MINE"]     = "Mineral Vein"

L["MSG_FORMAT"]    = "{rt7} Come & Get It // Hey %s, I came across %s %s that I can't %s at %s, %s in %s!"