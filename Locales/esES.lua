local L = LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esES") or LibStub("AceLocale-3.0"):NewLocale("ComeAndGetIt", "esMX")
if not L then return end

L["ROGUES"]        = "Pícaros"
L["HERBALISTS"]    = "Herboristas"
L["MINERS"]        = "Mineros"

L["ACTION_OPEN"]   = "abrir"
L["ACTION_PICK"]   = "recolectar"
L["ACTION_MINE"]   = "minar"

L["PREFIX_LOCKED"] = "un"
L["PREFIX_HERB"]   = "algunas"
L["PREFIX_MINE"]   = "una"

L["MATCH_HERB"]    = "Herboristería"
L["MATCH_MINE"]    = "Minería"

L["DEFAULT_TREASURE"] = "Cofre cerrado"
L["DEFAULT_HERB"]     = "Hierba"
L["DEFAULT_MINE"]     = "Veta de mineral"

L["MSG_FORMAT"] = "{rt7} Come & Get It // ¡Oye %s, encontré %s %s que no puedo %s en %s, %s en %s!"

L["OPTIONS_DESCRIPTION"] = "Announces herb nodes, ore veins, and treasure chests you cannot gather so nearby group members can pick them up."
L["FEEDBACK_HEADER"]     = "Feedback and Support"
L["FEEDBACK_CURSEFORGE"] = "CurseForge"
L["FEEDBACK_GITHUB"]     = "GitHub"
L["FEEDBACK_DISCORD"]    = "Discord"