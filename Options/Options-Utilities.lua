local _, ns = ...
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Standard Helpers
--------------------------------------------------------------------------------

-- Dot-defined (no self) so callers use dot invocation, matching the panel builders.

function ns.OptionsHeader(text, order)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order }
end

function ns.OptionsDesc(text, order)
	return { type = "description", name = text, fontSize = "medium", order = order }
end

function ns.OptionsSpacer(order)
	return { type = "description", name = " ", order = order }
end
