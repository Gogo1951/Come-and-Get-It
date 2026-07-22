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

L["MATCH_HERB"] = "Herboristerie"
L["MATCH_MINE"] = "Minage"

L["MSG_FORMAT_LOCKED"] = "Hé, Voleurs ! J'ai trouvé quelque chose que je ne peux pas ouvrir : %s (%s, %s) dans %s."
L["MSG_FORMAT_HERB"] =
	"Hé, Herboristes ! J'ai trouvé quelque chose que je ne peux pas cueillir : %s (%s, %s) dans %s."
L["MSG_FORMAT_MINE"] = "Hé, Mineurs ! J'ai trouvé quelque chose que je ne peux pas miner : %s (%s, %s) dans %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent sous Options > AddOns > Come & Get It. Vous aimez l'add-on ? Parlez-en à un ami ! (="

L["CHAT_TOO_LONG"] =
	"Cette annonce fait %d octets et dépasse la limite de %d octets du chat. Raccourcissez-la avant de l'envoyer."

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
	"Remarque : Local (/1) est le canal Général de la zone et dépend de la strate. Votre message atteint toute la zone, mais seuls les joueurs présents sur votre strate actuelle le verront."

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
