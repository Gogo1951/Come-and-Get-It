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
    -- the bodies must stay body-only.
]]

L["MSG_FORMAT_LOCKED"] = "Ei Ladinos, encontrei algo que não consigo abrir: %s (%s, %s) em %s!"
L["MSG_FORMAT_HERB"] = "Ei Herboristas, encontrei algo que não consigo coletar: %s (%s, %s) em %s!"
L["MSG_FORMAT_MINE"] = "Ei Mineiros, encontrei algo que não consigo minerar: %s (%s, %s) em %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Come & Get It. Gostando do add-on? Conte para um amigo! (="

L["CHAT_TOO_LONG"] = "Este anúncio tem %d bytes e ultrapassa o limite de %d bytes do chat. Encurte-o antes de enviar."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_INTRO"] =
	"Encontrou uma erva que você não pode coletar, um veio de minério que você não pode minerar ou um baú de tesouro trancado sem nenhum Ladino à vista? Clique com o botão direito nele e o Come & Get It criará uma mensagem que você pode usar para compartilhar ou transmitir as coordenadas. Ser um herói nunca foi tão fácil."

L["OPTIONS_WELCOME_NAME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Mostra a mensagem de boas-vindas no chat ao entrar no jogo."

L["OPTIONS_OUTPUT_HEADER"] = "Saída"
L["OPTIONS_OUTPUT_NAME"] = "Saída padrão"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Escolha para qual canal de chat o anúncio será direcionado. O rascunho abre na sua caixa de chat para que você possa revisá-lo ou redirecioná-lo antes de enviar."
L["OPTIONS_OUTPUT_NOTE"] =
	"Local (/1) é o canal Geral da zona e é específico de cada camada. Seu anúncio alcança toda a zona, mas apenas os jogadores na sua camada atual o verão."

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
