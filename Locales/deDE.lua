local addonName, namespace = ...
if GetLocale() ~= "deDE" then return end
local L = namespace.L

L["ROGUES"]        = "Schurken"
L["HERBALISTS"]    = "Kräuterkundige"
L["MINERS"]        = "Bergbauer"

L["ACTION_OPEN"]   = "öffnen"
L["ACTION_PICK"]   = "pflücken"
L["ACTION_MINE"]   = "abbauen"

L["PREFIX_LOCKED"]  = "ein verschlossenes"
L["PREFIX_HERB"]    = "ein"
L["PREFIX_MINE"]    = "ein"

L["MATCH_HERB"]    = "Kräuterkunde"
L["MATCH_MINE"]    = "Bergbau"

L["MSG_FORMAT"]    = "{rt7} Kommt und holt es // Hey %s, ich habe %s %s gefunden! Ich kann es nicht %s. (%s, %s in %s)"
