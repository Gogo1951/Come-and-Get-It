local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "ptBR")
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

L["ROGUES"] = "Ladinos"
L["HERBALISTS"] = "Herboristas"
L["MINERS"] = "Mineiros"

L["ACTION_OPEN"] = "abrir"
L["ACTION_PICK"] = "coletar"
L["ACTION_MINE"] = "minerar"

L["PREFIX_LOCKED"] = "um"
L["PREFIX_HERB"] = "alguma"
L["PREFIX_MINE"] = "um"

L["MATCH_HERB"] = "Herborismo"
L["MATCH_MINE"] = "Mineração"

L["MSG_FORMAT"] = "Ei %s, encontrei %s %s que não consigo %s em %s, %s em %s!"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Versão %s. As configurações (incluindo a opção de desativar esta mensagem) podem ser encontradas em Opções > AddOns > Come & Get It. Gostando do add-on? Conte para um amigo! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Encontrou uma erva que você não pode coletar, um veio de minério que você não pode minerar ou um baú de tesouro trancado sem nenhum Ladino à vista? Clique com o botão direito nele e o Come & Get It criará uma mensagem que você pode usar para compartilhar ou transmitir as coordenadas. Ser um herói nunca foi tão fácil."

L["OPTIONS_WELCOME_NAME"] = "Ativar mensagem de boas-vindas"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Mostra a mensagem de boas-vindas no chat ao entrar no jogo."

L["OPTIONS_OUTPUT_HEADER"] = "Saída"
L["OPTIONS_OUTPUT_NAME"] = "Saída padrão"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Escolha para qual canal de chat o anúncio será direcionado. O rascunho abre na sua caixa de chat para que você possa revisá-lo ou redirecioná-lo antes de enviar."
L["OPTIONS_OUTPUT_NOTE"] =
	"Observação: Local (/1) é o canal Geral da zona e é específico de cada camada: sua mensagem alcança toda a zona, mas apenas os jogadores na sua camada atual a verão."

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
