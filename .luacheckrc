std = "lua51"
max_line_length = false -- StyLua owns formatting
ignore = { "212/self", "611", "612", "613", "614", "621" } -- implicit self (house ns: methods) + whitespace — StyLua owns the latter
exclude_files = { "Includes/", ".claude/" } -- vendored or session-local, never linted
read_globals = {
	"C_AddOns",
	"C_CVar",
	"C_EventUtils",
	"C_Map",
	"C_Seasons",
	"ChatFrame1",
	"ChatFrameUtil",
	"ComeAndGetItDB",
	"CreateFrame",
	"Enum",
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
	SlashCmdList = { read_only = false, other_fields = true },
}
globals = {
	"SLASH_COMEANDGETIT1",
}
