local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esES")
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
    Translator guidance. Each MSG_FORMAT_* string is one complete announcement
    body, picked by what the player could not interact with. The code fills four
    %s placeholders in this fixed order: node name, x coordinate, y coordinate,
    zone name. Reorder the sentence freely for your language, but never reorder,
    add, or drop placeholders.

    Nothing precedes the node name, so no article or adjective has to agree with
    a name whose gender and number are unknown until runtime. Keep that property:
    if your language reads better with an article, restructure the sentence so
    the article attaches to a fixed word rather than to the placeholder.

    The raid marker, add-on name, and " // " separator are prepended by the code
    -- the bodies must stay body-only. MATCH_* must equal the profession skill
    names exactly as the game client displays them in this language (they are
    substring-matched against the client's error text).
]]

L["MATCH_HERB"] = "Herboristería"
L["MATCH_MINE"] = "Minería"

L["MSG_FORMAT_LOCKED"] = "¡Pícaros! Encontré algo que no puedo abrir: %s (%s, %s) en %s."
L["MSG_FORMAT_HERB"] = "¡Herboristas! Encontré algo que no puedo recolectar: %s (%s, %s) en %s."
L["MSG_FORMAT_MINE"] = "¡Mineros! Encontré algo que no puedo minar: %s (%s, %s) en %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versión %s. Los ajustes (incluida la opción para desactivar este mensaje) se encuentran en Opciones > AddOns > Come & Get It. ¿Te gusta el add-on? ¡Cuéntaselo a un amigo! (="

L["CHAT_TOO_LONG"] =
	"Este anuncio tiene %d bytes y supera el límite de %d bytes del chat. Acórtalo antes de enviarlo."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"¿Encontraste una hierba que no puedes recolectar, una veta de mineral que no puedes minar o un cofre cerrado sin un Pícaro a la vista? Haz clic derecho y Come & Get It creará un mensaje que puedes usar para compartir o anunciar las coordenadas. Ser un héroe nunca fue tan fácil."

L["OPTIONS_WELCOME_NAME"] = "Activar mensaje de bienvenida"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Muestra el mensaje de bienvenida en el chat al iniciar sesión."

L["OPTIONS_OUTPUT_HEADER"] = "Salida"
L["OPTIONS_OUTPUT_NAME"] = "Salida predeterminada"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Elige a qué canal de chat se dirige el anuncio. El borrador se abre en tu cuadro de chat para que puedas revisarlo o redirigirlo antes de enviarlo."
L["OPTIONS_OUTPUT_NOTE"] =
	"Nota: Local (/1) es el canal General de la zona y es específico de cada capa. Tu mensaje llega a toda la zona, pero solo lo verán los jugadores que estén en tu capa actual."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Local (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Decir"
L["OPTIONS_OUTPUT_YELL"] = "Gritar"
L["OPTIONS_OUTPUT_PARTY"] = "Grupo"
L["OPTIONS_OUTPUT_GUILD"] = "Hermandad"

L["FEEDBACK_HEADER"] = "Comentarios y soporte"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
