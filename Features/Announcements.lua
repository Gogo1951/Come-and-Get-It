local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Player Prints
--------------------------------------------------------------------------------

-- Format: |cff[INFO]Add-on Name|r |cff[SEPARATOR]//|r |cff[TEXT]Message|r
function ns:PrintMessage(msg)
	print(
		GetColor("INFO")
			.. L["ADDON_TITLE"]
			.. "|r "
			.. GetColor("SEPARATOR")
			.. "//"
			.. "|r "
			.. GetColor("TEXT")
			.. msg
			.. "|r"
	)
end

--------------------------------------------------------------------------------
-- Welcome Message
--------------------------------------------------------------------------------

function ns:PrintWelcome()
	if not (ns.db and ns.db.profile.showWelcome) then
		return
	end
	ns:PrintMessage(string.format(L["CHAT_LOADED"], ns.Version))
end

--------------------------------------------------------------------------------
-- Announcement Builder
--------------------------------------------------------------------------------

--[[
    Prepends the marker, add-on name, and " // " so every locale's MSG_FORMAT
    carries the BODY ONLY. A locale that re-bakes the prefix double-prefixes.
]]
function ns:BuildAnnounceMessage(formatKey, ...)
	local template = L[formatKey]
	if not template then
		return nil
	end
	local message = ns.TARGET_MARKER .. " " .. L["ADDON_TITLE"] .. " // " .. string.format(template, ...)
	-- Bodies never carry item links, so stripping stray pipes is safe here.
	return (message:gsub("|", ""))
end
