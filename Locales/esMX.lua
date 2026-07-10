local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esMX")
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

L["CHAT_LOADED"] =
	"Versión %s. Los ajustes (incluida la opción para desactivar este mensaje) se encuentran en Opciones > AddOns > Come & Get It. ¿Te gusta el add-on? ¡Cuéntaselo a un amigo! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"¿Encontraste una hierba que no puedes recolectar, una veta de mineral que no puedes minar o un cofre cerrado sin un Pícaro a la vista? Haz clic derecho y Come & Get It creará un mensaje que puedes usar para compartir o anunciar las coordenadas. Ser un héroe nunca fue tan fácil."

L["OPTIONS_WELCOME_NAME"] = "Activar mensaje de bienvenida"
L["OPTIONS_WELCOME_DESC"] = "Muestra el mensaje de bienvenida en el chat al iniciar sesión."

L["OPTIONS_OUTPUT_NAME"] = "Salida predeterminada"
L["OPTIONS_OUTPUT_DESC"] =
	"Elige a qué canal de chat se dirige el anuncio. El borrador se abre en tu cuadro de chat para que puedas revisarlo o redirigirlo antes de enviarlo."
L["OPTIONS_OUTPUT_NOTE"] =
	"Nota: Local (/1) es el canal General de la zona y es específico de cada capa: tu mensaje llega a toda la zona, pero solo lo verán los jugadores que estén en tu capa actual."

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
