std = "lua51"
max_line_length = false -- StyLua owns formatting
ignore = { "212/self", "611", "612", "613", "614", "621" } -- implicit self (house ns: methods) + whitespace — StyLua owns the latter
exclude_files = { "Includes/" } -- vendored, never linted
read_globals = {
	"C_AddOns",
	"C_CVar",
	"C_EventUtils",
	"C_Map",
	"ChatEdit_GetActiveWindow",
	"ChatFrame1",
	"ChatFrame_OpenChat",
	"ComeAndGetItDB",
	"CreateFrame",
	"GameTooltip",
	"GameTooltipTextLeft1",
	"GetBuildInfo",
	"GetGameMessageInfo",
	"GetLocale",
	"GetTime",
	"InCombatLockdown",
	"IsInInstance",
	"LibStub",
	"Settings",
	"WOW_PROJECT_ID",
	SlashCmdList = { read_only = false, other_fields = true },
}
globals = {
	"SLASH_COMEANDGETIT1",
}
