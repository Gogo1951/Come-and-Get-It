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
-- End of Support
--------------------------------------------------------------------------------

function ns:PrintEndOfSupport()
	ns:PrintMessage(L["CHAT_END_OF_SUPPORT"])
end

--------------------------------------------------------------------------------
-- Announcement Builder
--------------------------------------------------------------------------------

--[[
    Returns the locale body as the whole draft line: no raid marker, no add-on
    name prefix. WoW Forever blocks raid-marker tokens in chat, so the line
    stays plain on every client.
]]
function ns:BuildAnnounceMessage(formatKey, ...)
	local template = L[formatKey]
	if not template then
		return nil
	end
	local message = string.format(template, ...)
	-- Bodies never carry item links, so stripping stray pipes is safe here.
	return (message:gsub("|", ""))
end
