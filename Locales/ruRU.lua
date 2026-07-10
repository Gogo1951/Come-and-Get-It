local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "ruRU")
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

--[[
    Translator guidance. MSG_FORMAT is the announcement body; the code fills its
    seven %s placeholders in this fixed order: role (ROGUES / HERBALISTS /
    MINERS), prefix (PREFIX_*), node name, action verb (ACTION_*), x coordinate,
    y coordinate, zone name. Reorder the sentence freely for your language, but
    never reorder, add, or drop placeholders. PREFIX_* is the article/quantity
    word placed directly before the node name; ACTION_* is the verb the player
    cannot perform. The raid marker, add-on name, and " // " separator are
    prepended by the code -- MSG_FORMAT must stay body-only. MATCH_* must equal
    the profession skill names exactly as the game client displays them in this
    language (they are substring-matched against the client's error text).
]]

L["ROGUES"] = "Разбойники"
L["HERBALISTS"] = "Травники"
L["MINERS"] = "Рудокопы"

L["ACTION_OPEN"] = "открыть"
L["ACTION_PICK"] = "собрать"
L["ACTION_MINE"] = "добыть"

L["PREFIX_LOCKED"] = "запертый"
L["PREFIX_HERB"] = "немного"
L["PREFIX_MINE"] = "какую-то"

L["MATCH_HERB"] = "Травничество"
L["MATCH_MINE"] = "Горное дело"

L["MSG_FORMAT"] = "Эй, %s, я нашел %s %s, но не могу %s! Координаты: %s, %s в %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Версия %s. Настройки (включая возможность отключить это сообщение) находятся в меню Настройки > Модификации > Come & Get It. Нравится аддон? Расскажи другу! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Нашли траву, которую не можете собрать, рудную жилу, которую не можете добыть, или запертый сундук с сокровищами, а разбойника поблизости нет? Кликните по нему правой кнопкой мыши, и Come & Get It создаст сообщение, которое можно использовать, чтобы поделиться координатами или объявить их. Быть героем еще никогда не было так просто."

L["OPTIONS_WELCOME_NAME"] = "Включить приветственное сообщение"
L["OPTIONS_WELCOME_DESC"] =
	"Выводит приветственное сообщение в чат при входе в игру."

L["OPTIONS_OUTPUT_NAME"] = "Вывод по умолчанию"
L["OPTIONS_OUTPUT_DESC"] =
	"Выберите, в какой канал чата будет адресовано объявление. Черновик откроется в поле ввода чата, чтобы вы могли проверить его или перенаправить перед отправкой."
L["OPTIONS_OUTPUT_NOTE"] =
	"Примечание: Локальный (/1) относится к общему каналу зоны и зависит от слоя: ваше сообщение дойдет до всей зоны, но увидят его только игроки на вашем текущем слое."

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
