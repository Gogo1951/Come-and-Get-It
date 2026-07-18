local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "frFR")
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

L["ROGUES"] = "Voleurs"
L["HERBALISTS"] = "Herboristes"
L["MINERS"] = "Mineurs"

L["ACTION_OPEN"] = "ouvrir"
L["ACTION_PICK"] = "cueillir"
L["ACTION_MINE"] = "miner"

L["PREFIX_LOCKED"] = "un"
L["PREFIX_HERB"] = "quelques"
L["PREFIX_MINE"] = "un"

L["MATCH_HERB"] = "Herboristerie"
L["MATCH_MINE"] = "Minage"

L["MSG_FORMAT"] = "Hé %s, j'ai trouvé %s %s que je ne peux pas %s à %s, %s dans %s !"

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent sous Options > AddOns > Come & Get It. Vous aimez l'add-on ? Parlez-en à un ami ! (="

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Vous avez trouvé une herbe que vous ne pouvez pas cueillir, un filon de minerai que vous ne pouvez pas miner ou un coffre au trésor verrouillé sans aucun voleur en vue ? Faites un clic droit dessus, et Come & Get It créera un message que vous pourrez utiliser pour partager ou diffuser les coordonnées. Être un héros n'a jamais été aussi facile."

L["OPTIONS_WELCOME_NAME"] = "Activer le message de bienvenue"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Affiche le message de bienvenue dans le chat lors de la connexion."

L["OPTIONS_OUTPUT_HEADER"] = "Sortie"
L["OPTIONS_OUTPUT_NAME"] = "Sortie par défaut"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Choisissez le canal de chat auquel l'annonce est adressée. Le brouillon s'affiche dans votre barre de chat pour que vous puissiez le vérifier ou le rediriger avant de l'envoyer."
L["OPTIONS_OUTPUT_NOTE"] =
	"Remarque : Local (/1) est le canal Général de la zone et dépend de la strate : votre message atteint toute la zone, mais seuls les joueurs présents sur votre strate actuelle le verront."

L["OPTIONS_OUTPUT_CHANNEL1"] = "Local (/1)"
L["OPTIONS_OUTPUT_SAY"] = "Dire"
L["OPTIONS_OUTPUT_YELL"] = "Crier"
L["OPTIONS_OUTPUT_PARTY"] = "Groupe"
L["OPTIONS_OUTPUT_GUILD"] = "Guilde"

L["FEEDBACK_HEADER"] = "Commentaires et assistance"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"] = "GitHub"
L["FEEDBACK_DISCORD"] = "Discord"
L["FEEDBACK_WAGO"] = "Wago"
