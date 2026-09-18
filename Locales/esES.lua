local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esES")
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

L["MATCH_HERB"] = "Herboristería"
L["MATCH_MINE"] = "Minería"

--------------------------------------------------------------------------------
-- Announcement Strings
--------------------------------------------------------------------------------

--[[
    Translator guidance. Each MSG_FORMAT_* string is the complete line sent to
    chat, picked by what the player could not interact with. The code fills four
    %s placeholders in this fixed order: node name, x coordinate, y coordinate,
    zone name. Reorder the sentence freely for your language, but never reorder,
    add, or drop placeholders.

    The greeting closes on "!" so the node name starts a fresh clause with nothing
    in front of it. That is load-bearing, not stylistic: no article or adjective
    has to agree with a name whose gender and number are unknown until runtime, and
    English dodges a/an ("an Iron Deposit" vs "a Gold Vein") for free. If your
    language reads better with an article, attach it to a fixed word rather than to
    the placeholder.

    Don't add a raid marker or the add-on name: WoW Forever blocks raid markers
    in chat, and the line reads as the player talking.
]]

L["MSG_FORMAT_LOCKED"] = "¡Ey, Pícaros! %s (%s, %s) en %s."
L["MSG_FORMAT_HERB"] = "¡Ey, Herboristas! %s (%s, %s) en %s."
L["MSG_FORMAT_MINE"] = "¡Ey, Mineros! %s (%s, %s) en %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versión %s. Los ajustes (incluida la opción para desactivar este mensaje) se encuentran en Opciones > AddOns > Come & Get It. ¿Te gusta el add-on? ¡Cuéntaselo a un amigo! (="

L["CHAT_TOO_LONG"] =
	"Este borrador tiene %d bytes y supera el límite de %d bytes del chat. Acórtalo antes de enviarlo."

L["CHAT_OPTIONS_IN_COMBAT"] = "Como medida de seguridad, la interfaz de opciones no se puede abrir durante el combate."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"¿Has encontrado una hierba que no puedes recoger, una veta de mineral que no puedes extraer o un cofre del tesoro cerrado con llave sin ningún Pícaro a la vista? Haz clic derecho encima y Come & Get It crea un mensaje que puedes usar para compartir o difundir las coordenadas. Ser un héroe nunca ha sido tan fácil."

L["OPTIONS_WELCOME_NAME"] = "Activar mensaje de bienvenida"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Muestra el mensaje de bienvenida en el chat al iniciar sesión."

L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre la interfaz de opciones de este add-on."

L["OPTIONS_OUTPUT_HEADER"] = "Salida"
L["OPTIONS_OUTPUT_NAME"] = "Salida predeterminada"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Elige el canal de chat en el que se abre tu borrador; Local (/1) llega a toda la zona, pero solo a los jugadores de tu capa actual."

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
