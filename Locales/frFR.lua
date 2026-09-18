local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "frFR")
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

L["MATCH_HERB"] = "Herboristerie"
L["MATCH_MINE"] = "Minage"

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

L["MSG_FORMAT_LOCKED"] = "Hé, Voleurs ! %s (%s, %s) dans %s."
L["MSG_FORMAT_HERB"] = "Hé, Herboristes ! %s (%s, %s) dans %s."
L["MSG_FORMAT_MINE"] = "Hé, Mineurs ! %s (%s, %s) dans %s."

--------------------------------------------------------------------------------
-- Chat
--------------------------------------------------------------------------------

L["CHAT_LOADED"] =
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent sous Options > AddOns > Come & Get It. Vous aimez l'add-on ? Parlez-en à un ami ! (="

L["CHAT_TOO_LONG"] =
	"Ce brouillon fait %d octets et dépasse la limite de %d octets du chat. Raccourcissez-le avant de l'envoyer."

L["CHAT_OPTIONS_IN_COMBAT"] =
	"Par mesure de sécurité, l'interface des options ne peut pas être ouverte pendant le combat."

--------------------------------------------------------------------------------
-- Options Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Vous avez trouvé une herbe que vous ne pouvez pas cueillir, un filon de minerai que vous ne pouvez pas miner ou un coffre au trésor verrouillé, sans aucun Voleur en vue ? Faites un clic droit dessus, et Come & Get It crée un message que vous pouvez utiliser pour partager ou diffuser les coordonnées. Être un héros n'a jamais été aussi facile."

L["OPTIONS_WELCOME_NAME"] = "Activer le message de bienvenue"
L["OPTIONS_WELCOME_DESCRIPTION"] = "Affiche le message de bienvenue dans le chat lors de la connexion."

L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_COMMAND"] = "/cgi"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre l'interface des options de cet add-on."

L["OPTIONS_OUTPUT_HEADER"] = "Sortie"
L["OPTIONS_OUTPUT_NAME"] = "Sortie par défaut"
L["OPTIONS_OUTPUT_DESCRIPTION"] =
	"Choisit le canal de chat dans lequel votre brouillon s'ouvre ; Local (/1) atteint toute la zone, mais seulement les joueurs de votre strate actuelle."

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
