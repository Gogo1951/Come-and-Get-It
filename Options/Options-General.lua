local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local OptionsHeader = ns.OptionsHeader
local OptionsDesc = ns.OptionsDesc
local OptionsSpacer = ns.OptionsSpacer
local OptionsRowLabel = ns.OptionsRowLabel

--------------------------------------------------------------------------------
-- Output Channel Dropdown
--------------------------------------------------------------------------------

-- Derived from the OUTPUT_CHANNELS manifest (Data.lua); labels resolved once at load.
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
			descIntro = OptionsDesc(L["OPTIONS_INTRO"], 1),

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

			-- /Commands
			spacerCommands0 = OptionsSpacer(7),
			headerCommands = OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 8),
			spacerCommands1 = OptionsSpacer(9),
			descCommands = OptionsDesc(
				GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
				10
			),

			-- Output
			spacerOutput0 = OptionsSpacer(12),
			headerOutput = OptionsHeader(L["OPTIONS_OUTPUT_HEADER"], 13),
			spacerOutput1 = OptionsSpacer(14),

			-- Default Output (label and dropdown share one line)
			labelOutput = OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_OUTPUT_NAME"] .. "|r", 15),
			outputChannel = {
				type = "select",
				name = "",
				desc = L["OPTIONS_OUTPUT_DESCRIPTION"],
				style = "dropdown",
				width = ns.OPTIONS_CONTROL_WIDTH,
				order = 16,
				values = OUTPUT_VALUES,
				sorting = OUTPUT_SORTING,
				get = function()
					return (ns.db and ns.db.profile.defaultOutput) or ns.DEFAULT_OUTPUT_CHANNEL
				end,
				set = function(_, value)
					ns.db.profile.defaultOutput = value
				end,
			},
			spacerOutput2 = OptionsSpacer(17),

			descOutputNote = {
				type = "description",
				name = GetColor("HELP") .. L["OPTIONS_OUTPUT_NOTE"] .. "|r",
				fontSize = "medium",
				order = 18,
			},

			spacerFeedback0 = OptionsSpacer(20),
			headerFeedback = OptionsHeader(L["FEEDBACK_HEADER"], 21),
			spacerFeedback1 = OptionsSpacer(22),

			labelDiscord = OptionsRowLabel(GetColor("TITLE") .. L["FEEDBACK_DISCORD"] .. "|r", 23),
			feedbackDiscord = {
				type = "input",
				name = "",
				order = 24,
				width = ns.OPTIONS_CONTROL_WIDTH,
				get = function()
					return ns.URL_DISCORD
				end,
				set = function() end,
			},
			spacerDiscord = OptionsSpacer(25),

			labelGitHub = OptionsRowLabel(GetColor("TITLE") .. L["FEEDBACK_GITHUB"] .. "|r", 26),
			feedbackGitHub = {
				type = "input",
				name = "",
				order = 27,
				width = ns.OPTIONS_CONTROL_WIDTH,
				get = function()
					return ns.URL_GITHUB
				end,
				set = function() end,
			},
			spacerGitHub = OptionsSpacer(28),

			labelCurseForge = OptionsRowLabel(GetColor("TITLE") .. L["FEEDBACK_CURSEFORGE"] .. "|r", 29),
			feedbackCurseForge = {
				type = "input",
				name = "",
				order = 30,
				width = ns.OPTIONS_CONTROL_WIDTH,
				get = function()
					return ns.URL_CURSEFORGE
				end,
				set = function() end,
			},
			spacerCurseForge = OptionsSpacer(31),

			labelWago = OptionsRowLabel(GetColor("TITLE") .. L["FEEDBACK_WAGO"] .. "|r", 32),
			feedbackWago = {
				type = "input",
				name = "",
				order = 33,
				width = ns.OPTIONS_CONTROL_WIDTH,
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
