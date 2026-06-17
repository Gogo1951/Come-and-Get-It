local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "ruRU")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

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

L["CHAT_LOADED"] = "Версия %s. Настройки (включая возможность отключить это сообщение) находятся в меню Настройки > Модификации > Come & Get It. Нравится аддон? Расскажи другу! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Нашли траву, которую не можете собрать, рудную жилу, которую не можете добыть, или запертый сундук с сокровищами, а разбойника поблизости нет? Кликните по нему правой кнопкой мыши, и Come & Get It создаст сообщение, которое можно использовать, чтобы поделиться координатами или объявить их. Быть героем еще никогда не было так просто."

L["OPTIONS_WELCOME_NAME"] = "Включить приветственное сообщение"
L["OPTIONS_WELCOME_DESC"] = "Выводить приветственное сообщение в чат при входе в игру."

L["OPTIONS_OUTPUT_HEADER"] = "Default Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESC"] = "Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] = "Note: Local (/1) is the zone's General channel and is layer-specific — your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Локальный (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Сказать"
L["OPTIONS_OUTPUT_YELL"] = "Кричать"
L["OPTIONS_OUTPUT_PARTY"] = "Группа"
L["OPTIONS_OUTPUT_GUILD"] = "Гильдия"

L["FEEDBACK_HEADER"] = "Обратная связь и поддержка"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"