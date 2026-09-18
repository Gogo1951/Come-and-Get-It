local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "ptBR")
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

L["MATCH_HERB"] = "Herborismo"
L["MATCH_MINE"] = "Mineração"

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

L["MSG_FORMAT_LOCKED"] = "Ei Ladinos! %s (%s, %s) em %s."
L["MSG_FORMAT_HERB"] = "Ei Herboristas! %s (%s, %s) em %s."
L["MSG_FORMAT_MINE"] = "Ei Mineiros! %s (%s, %s) em %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Come & Get It. Gostando do add-on? Conte para um amigo! (="

L["CHAT_TOO_LONG"] = "Este rascunho tem %d bytes e ultrapassa o limite de %d bytes do chat. Encurte-o antes de enviar."

L["CHAT_OPTIONS_IN_COMBAT"] =
	"Como medida de segurança, a interface de opções não pode ser aberta durante o combate."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Achou uma erva que não consegue colher, um veio de minério que não consegue minerar ou um baú do tesouro trancado sem nenhum Ladino por perto? Clique nele com o botão direito e o Come & Get It cria uma mensagem que você pode usar para compartilhar ou divulgar as coordenadas. Ser herói nunca foi tão fácil."

L["OPTIONS_WELCOME_NAME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Mostra a mensagem de boas-vindas no chat ao entrar no jogo."

L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre a interface de opções deste add-on."

L["OPTIONS_OUTPUT_HEADER"] = "Saída"
L["OPTIONS_OUTPUT_NAME"] = "Saída padrão"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Escolhe o canal de chat em que o seu rascunho abre; Local (/1) alcança toda a zona, mas só os jogadores na sua camada atual."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Local (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Falar"
L["OPTIONS_OUTPUT_YELL"] = "Gritar"
L["OPTIONS_OUTPUT_PARTY"] = "Grupo"
L["OPTIONS_OUTPUT_GUILD"] = "Guilda"

L["FEEDBACK_HEADER"] = "Feedback e suporte"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
