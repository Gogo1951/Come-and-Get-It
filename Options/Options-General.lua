local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local OptionsHeader = ns.OptionsHeader
local OptionsDesc = ns.OptionsDesc
local OptionsSpacer = ns.OptionsSpacer

--------------------------------------------------------------------------------
-- Output Channel Dropdown
--------------------------------------------------------------------------------

--[[
    Dropdown values/sorting are derived once from the OUTPUT_CHANNELS manifest
    (Data.lua) so the channel list, its order, and Core's command lookup all
    trace back to one definition. Keys are stable and saved to the DB; labels
    are localized here at display time.
]]
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
                desc = L["OPTIONS_WELCOME_DESC"],
                width = "full",
                order = 6,
                get = function() return ComeAndGetItDB and ComeAndGetItDB.showWelcome end,
                set = function(_, v)
                    ComeAndGetItDB = ComeAndGetItDB or {}
                    ComeAndGetItDB.showWelcome = v
                end
            },

            -- Default Output
            spacerOutput0 = OptionsSpacer(10),
            headerOutput = OptionsHeader(L["OPTIONS_OUTPUT_HEADER"], 11),
            spacerOutput1 = OptionsSpacer(12),
            outputChannel = {
                type = "select",
                name = L["OPTIONS_OUTPUT_NAME"],
                desc = L["OPTIONS_OUTPUT_DESC"],
                width = "double",
                order = 13,
                values = OUTPUT_VALUES,
                sorting = OUTPUT_SORTING,
                get = function()
                    return (ComeAndGetItDB and ComeAndGetItDB.defaultOutput)
                        or ns.DEFAULT_OUTPUT_CHANNEL
                end,
                set = function(_, value)
                    ComeAndGetItDB = ComeAndGetItDB or {}
                    ComeAndGetItDB.defaultOutput = value
                end
            },
            spacerOutput2 = OptionsSpacer(14),
            descOutputNote = {
                type = "description",
                name = GetColor("BODY") .. L["OPTIONS_OUTPUT_NOTE"] .. "|r",
                fontSize = "medium",
                order = 15
            },

            spacerFeedback0 = OptionsSpacer(20),
            headerFeedback = OptionsHeader(L["FEEDBACK_HEADER"], 21),
            spacerFeedback1 = OptionsSpacer(22),

            feedbackCurseForge = {
                type = "input",
                name = L["FEEDBACK_CURSEFORGE"],
                order = 23,
                width = "double",
                get = function() return ns.URL_CURSEFORGE end,
                set = function() end
            },
            feedbackGitHub = {
                type = "input",
                name = L["FEEDBACK_GITHUB"],
                order = 24,
                width = "double",
                get = function() return ns.URL_GITHUB end,
                set = function() end
            },
            feedbackDiscord = {
                type = "input",
                name = L["FEEDBACK_DISCORD"],
                order = 25,
                width = "double",
                get = function() return ns.URL_DISCORD end,
                set = function() end
            },

            -- Version
            spaceVersion0 = {
                type = "description",
                name = " ",
                width = "full",
                order = 998
            },
            versionLine = {
                type = "description",
                name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
                fontSize = "medium",
                order = 999
            }
        }
    }
end
