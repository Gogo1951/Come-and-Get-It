local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "ruRU")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Skill Names
--------------------------------------------------------------------------------

--[[
    Not display copy. MATCH_* must equal the profession skill names exactly as
    the game client displays them in this language: they are substring-matched
    against the client's error text, so a loose or stylized translation silently
    stops the add-on from detecting anything at all.
]]

L["MATCH_HERB"] = "Травничество"
L["MATCH_MINE"] = "Горное дело"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

--[[
    Translator guidance. Each MSG_FORMAT_* string is one complete announcement
    body, picked by what the player could not interact with. The code fills four
    %s placeholders in this fixed order: node name, x coordinate, y coordinate,
    zone name. Reorder the sentence freely for your language, but never reorder,
    add, or drop placeholders.

    The greeting closes on "!" so the node name starts a fresh clause with nothing
    in front of it. That is load-bearing, not stylistic: no article or adjective
    has to agree with a name whose gender and number are unknown until runtime, and
    English dodges a/an ("an Iron Deposit" vs "a Gold Vein") for free. If your
    language reads better with an article, attach it to a fixed word rather than to
    the placeholder.

    The raid marker, add-on name, and " // " separator are prepended by the code
    -- the bodies must stay body-only.
]]

L["MSG_FORMAT_LOCKED"] = "Эй, Разбойники! %s (%s, %s) в %s."
L["MSG_FORMAT_HERB"] = "Эй, Травники! %s (%s, %s) в %s."
L["MSG_FORMAT_MINE"] = "Эй, Рудокопы! %s (%s, %s) в %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Версия %s. Настройки (включая возможность отключить это сообщение) находятся в меню Настройки > Модификации > Come & Get It. Нравится аддон? Расскажи другу! (="

L["CHAT_TOO_LONG"] =
	"Это объявление занимает %d байт и превышает лимит чата в %d байт. Сократите его перед отправкой."

L["CHAT_OPTIONS_IN_COMBAT"] =
	"В целях безопасности окно настроек нельзя открыть во время боя."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"Нашли траву, которую не можете собрать, рудную жилу, которую не можете добыть, или запертый сундук с сокровищами, а Разбойника поблизости нет? Кликните по нему правой кнопкой мыши, и Come & Get It создаст сообщение, которое можно использовать, чтобы поделиться координатами или объявить их. Быть героем еще никогда не было так просто."

L["OPTIONS_WELCOME_NAME"] = "Включить приветственное сообщение"
L["OPTIONS_WELCOME_DESCRIPTION"] =
	"Выводит приветственное сообщение в чат при входе в игру."

L["OPTIONS_COMMANDS_HEADER"] = "/Команды"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Открывает окно настроек этого аддона."

L["OPTIONS_OUTPUT_HEADER"] = "Вывод"
L["OPTIONS_OUTPUT_NAME"] = "Вывод по умолчанию"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Выберите, в какой канал чата будет адресовано объявление. Черновик откроется в поле ввода чата, чтобы вы могли проверить его или перенаправить перед отправкой."
L["OPTIONS_OUTPUT_NOTE"] =
	"Локальный (/1) относится к общему каналу зоны и зависит от слоя. Ваше объявление дойдет до всей зоны, но увидят его только игроки на вашем текущем слое."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Локальный (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Сказать"
L["OPTIONS_OUTPUT_YELL"] = "Кричать"
L["OPTIONS_OUTPUT_PARTY"] = "Группа"
L["OPTIONS_OUTPUT_GUILD"] = "Гильдия"

L["FEEDBACK_HEADER"] = "Обратная связь и поддержка"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
