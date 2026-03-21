local addonName, namespace = ...

-- esMX (Latin American) and esES (Iberian) share identical strings for this
-- addon, so both locales load the same file.
local currentLocale = GetLocale()
if currentLocale ~= "esES" and currentLocale ~= "esMX" then return end
local L = namespace.L

L["ROGUES"]        = "Pícaros"
L["HERBALISTS"]    = "Herboristas"
L["MINERS"]        = "Mineros"

L["ACTION_OPEN"]   = "abrir"
L["ACTION_PICK"]   = "recolectar"
L["ACTION_MINE"]   = "minar"

L["PREFIX_LOCKED"]  = "un cerrado"
L["PREFIX_HERB"]    = "algunas"
L["PREFIX_MINE"]    = "un"

L["MATCH_HERB"]    = "Herboristería"
L["MATCH_MINE"]    = "Minería"

L["MSG_FORMAT"]    = "{rt7} Ven y tómalo // Oye %s, encontré %s %s que no puedo %s en %s, %s en %s!"
