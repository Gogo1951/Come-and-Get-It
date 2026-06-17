local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esMX")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Come & Get It"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

L["ROGUES"] = "Pícaros"
L["HERBALISTS"] = "Herboristas"
L["MINERS"] = "Mineros"

L["ACTION_OPEN"] = "abrir"
L["ACTION_PICK"] = "recolectar"
L["ACTION_MINE"] = "minar"

L["PREFIX_LOCKED"] = "un"
L["PREFIX_HERB"] = "algunas"
L["PREFIX_MINE"] = "una"

L["MATCH_HERB"] = "Herboristería"
L["MATCH_MINE"] = "Minería"

L["MSG_FORMAT"] = "¡Oye %s, encontré %s %s que no puedo %s en %s, %s en %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Versión %s. Los ajustes (incluida la opción para desactivar este mensaje) se encuentran en Opciones > AddOns > Come & Get It. ¿Te gusta el addon? ¡Cuéntaselo a un amigo! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "¿Encontraste una hierba que no puedes recolectar, una veta de mineral que no puedes minar o un cofre cerrado sin un Pícaro a la vista? Haz clic derecho y Come & Get It creará un mensaje que puedes usar para compartir o anunciar las coordenadas. Ser un héroe nunca fue tan fácil."

L["OPTIONS_WELCOME_NAME"] = "Activar mensaje de bienvenida"
L["OPTIONS_WELCOME_DESC"] = "Mostrar el mensaje de bienvenida en el chat al iniciar sesión."

L["OPTIONS_OUTPUT_HEADER"] = "Default Output"
L["OPTIONS_OUTPUT_NAME"] = "Default Output"
L["OPTIONS_OUTPUT_DESC"] = "Choose which chat channel the announcement is addressed to. The draft opens in your chat box so you can review or redirect it before sending."
L["OPTIONS_OUTPUT_NOTE"] = "Note: Local (/1) is the zone's General channel and is layer-specific — your message reaches the whole zone, but only players on your current layer will see it."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Local (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Decir"
L["OPTIONS_OUTPUT_YELL"] = "Gritar"
L["OPTIONS_OUTPUT_PARTY"] = "Grupo"
L["OPTIONS_OUTPUT_GUILD"] = "Hermandad"

L["FEEDBACK_HEADER"] = "Comentarios y soporte"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"