local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Player Prints
--------------------------------------------------------------------------------

-- Format: |cff[INFO]Add-on Name|r |cff[SEPARATOR]//|r |cff[TEXT]Message|r
function ns:PrintMessage(msg)
    print(GetColor("INFO") .. L["ADDON_TITLE"] .. "|r "
        .. GetColor("SEPARATOR") .. "//" .. "|r "
        .. GetColor("TEXT") .. msg .. "|r")
end

--------------------------------------------------------------------------------
-- Welcome Message
--------------------------------------------------------------------------------

function ns:PrintWelcome()
    if not ComeAndGetItDB.showWelcome then return end
    ns:PrintMessage(string.format(L["CHAT_LOADED"], ns.Version))
end

--------------------------------------------------------------------------------
-- Announcement Builder
--------------------------------------------------------------------------------

--[[
    Centralizes message decoration (Style Guide MESSAGES): the raid marker, the
    add-on name, and the " // " separator are prepended here so every locale's
    MSG_FORMAT carries the message BODY ONLY. formatKey is a locale key; the
    varargs fill its %s slots via string.format.
]]
function ns:BuildAnnounceMessage(formatKey, ...)
    return ns.TARGET_MARKER .. " " .. L["ADDON_TITLE"] .. " // " .. string.format(L[formatKey], ...)
end
