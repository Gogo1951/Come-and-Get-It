local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local OptionsHeader = ns.OptionsHeader
local OptionsDesc = ns.OptionsDesc
local OptionsSpacer = ns.OptionsSpacer

--------------------------------------------------------------------------------
-- Output Channel Dropdown
--------------------------------------------------------------------------------

-- Derived from the OUTPUT_CHANNELS manifest (Data.lua); labels localized at display time.
local OUTPUT_VALUES = {}
local OUTPUT_SORTING = {}
for index, channel in ipairs(ns.OUTPUT_CHANNELS) do
	OUTPUT_VALUES[channel.key] = L[channel.labelKey]
	OUTPUT_SORTING[index] = channel.key
end

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

function ns.BuildGeneralOptions()
	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = {
			descIntro = OptionsDesc(L["OPTIONS_DESCRIPTION"], 1),

			spacerWelcome0 = OptionsSpacer(5),
			welcomeToggle = {
				type = "toggle",
				name = L["OPTIONS_WELCOME_NAME"],
				desc = L["OPTIONS_WELCOME_DESCRIPTION"],
				width = "full",
				order = 6,
				get = function()
					return ns.db and ns.db.profile.showWelcome
				end,
				set = function(_, v)
					ns.db.profile.showWelcome = v
				end,
			},

			-- Output
			spacerOutput0 = OptionsSpacer(10),
			headerOutput = OptionsHeader(L["OPTIONS_OUTPUT_HEADER"], 11),
			spacerOutput1 = OptionsSpacer(12),

			-- Default Output (label and dropdown share one line)
			labelOutput = {
				type = "description",
				name = GetColor("TITLE") .. L["OPTIONS_OUTPUT_NAME"] .. "|r",
				fontSize = "medium",
				width = "double",
				order = 13,
			},
			outputChannel = {
				type = "select",
				name = "",
				desc = L["OPTIONS_OUTPUT_DESCRIPTION"],
				style = "dropdown",
				order = 14,
				values = OUTPUT_VALUES,
				sorting = OUTPUT_SORTING,
				get = function()
					return (ns.db and ns.db.profile.defaultOutput) or ns.DEFAULT_OUTPUT_CHANNEL
				end,
				set = function(_, value)
					ns.db.profile.defaultOutput = value
				end,
			},
			spacerOutput2 = OptionsSpacer(15),

			descOutputNote = {
				type = "description",
				name = GetColor("HELP") .. L["OPTIONS_OUTPUT_NOTE"] .. "|r",
				fontSize = "medium",
				order = 16,
			},

			spacerFeedback0 = OptionsSpacer(20),
			headerFeedback = OptionsHeader(L["FEEDBACK_HEADER"], 21),
			spacerFeedback1 = OptionsSpacer(22),

			labelDiscord = OptionsDesc(GetColor("TITLE") .. L["FEEDBACK_DISCORD"] .. "|r", 23),
			feedbackDiscord = {
				type = "input",
				name = "",
				order = 24,
				width = "double",
				get = function()
					return ns.URL_DISCORD
				end,
				set = function() end,
			},
			spacerDiscord = OptionsSpacer(25),

			labelGitHub = OptionsDesc(GetColor("TITLE") .. L["FEEDBACK_GITHUB"] .. "|r", 26),
			feedbackGitHub = {
				type = "input",
				name = "",
				order = 27,
				width = "double",
				get = function()
					return ns.URL_GITHUB
				end,
				set = function() end,
			},
			spacerGitHub = OptionsSpacer(28),

			labelCurseForge = OptionsDesc(GetColor("TITLE") .. L["FEEDBACK_CURSEFORGE"] .. "|r", 29),
			feedbackCurseForge = {
				type = "input",
				name = "",
				order = 30,
				width = "double",
				get = function()
					return ns.URL_CURSEFORGE
				end,
				set = function() end,
			},
			spacerCurseForge = OptionsSpacer(31),

			labelWago = OptionsDesc(GetColor("TITLE") .. L["FEEDBACK_WAGO"] .. "|r", 32),
			feedbackWago = {
				type = "input",
				name = "",
				order = 33,
				width = "double",
				get = function()
					return ns.URL_WAGO
				end,
				set = function() end,
			},

			-- Version
			spaceVersion0 = {
				type = "description",
				name = " ",
				width = "full",
				order = 998,
			},
			versionLine = {
				type = "description",
				name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
				fontSize = "medium",
				order = 999,
			},
		},
	}
end
