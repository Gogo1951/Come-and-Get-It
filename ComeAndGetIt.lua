local addonName, addonTable = ...
local L = {
    enUS = {
        ROGUES = "Rogues",
        HERBALISTS = "Herbalists",
        MINERS = "Miners",
        ACTION_OPEN = "open",
        ACTION_PICK = "pick",
        ACTION_MINE = "mine",
        PREFIX_LOCKED = "a locked",
        PREFIX_HERB = "some",
        PREFIX_MINE = "a",
        MATCH_HERB = "Herbalism",
        MATCH_MINE = "Mining",
        MSG_FORMAT = "{rt7} Come & Get It // Hey %s, I came across %s %s that I can't %s at %s, %s in %s!"
    },
    deDE = {
        ROGUES = "Schurken",
        HERBALISTS = "Kräuterkundige",
        MINERS = "Bergbauer",
        ACTION_OPEN = "öffnen",
        ACTION_PICK = "pflücken",
        ACTION_MINE = "abbauen",
        PREFIX_LOCKED = "ein verschlossenes",
        PREFIX_HERB = "ein",
        PREFIX_MINE = "ein",
        MATCH_HERB = "Kräuterkunde",
        MATCH_MINE = "Bergbau",
        MSG_FORMAT = "{rt7} Kommt und holt es // Hey %s, ich habe %s %s gefunden! Ich kann es nicht %s. (%s, %s in %s)"
    },
    frFR = {
        ROGUES = "Voleurs",
        HERBALISTS = "Herboristes",
        MINERS = "Mineurs",
        ACTION_OPEN = "ouvrir",
        ACTION_PICK = "cuillir",
        ACTION_MINE = "miner",
        PREFIX_LOCKED = "un verrouillé",
        PREFIX_HERB = "quelques",
        PREFIX_MINE = "un",
        MATCH_HERB = "Herboristerie",
        MATCH_MINE = "Minage",
        MSG_FORMAT = "{rt7} Venez le chercher // Hé %s, j'ai trouvé %s %s que je ne peux pas %s à %s, %s dans %s !"
    },
    esES = {
        ROGUES = "Pícaros",
        HERBALISTS = "Herboristas",
        MINERS = "Mineros",
        ACTION_OPEN = "abrir",
        ACTION_PICK = "recolectar",
        ACTION_MINE = "minar",
        PREFIX_LOCKED = "un cerrado",
        PREFIX_HERB = "algunas",
        PREFIX_MINE = "un",
        MATCH_HERB = "Herboristería",
        MATCH_MINE = "Minería",
        MSG_FORMAT = "{rt7} Ven y tómalo // Oye %s, encontré %s %s que no puedo %s en %s, %s en %s!"
    },
    ruRU = {
        ROGUES = "Разбойники",
        HERBALISTS = "Травники",
        MINERS = "Шахтеры",
        ACTION_OPEN = "открыть",
        ACTION_PICK = "собрать",
        ACTION_MINE = "выкопать",
        PREFIX_LOCKED = "запертый",
        PREFIX_HERB = "куст",
        PREFIX_MINE = "жилу",
        MATCH_HERB = "Травничество",
        MATCH_MINE = "Горное дело",
        MSG_FORMAT = "{rt7} Забирайте // Эй, %s, я нашел %s %s, не могу %s! Координаты: %s, %s в %s."
    },
    koKR = {
        ROGUES = "도적",
        HERBALISTS = "약초채집가",
        MINERS = "채광사",
        ACTION_OPEN = "열기",
        ACTION_PICK = "채집",
        ACTION_MINE = "채광",
        PREFIX_LOCKED = "잠긴",
        PREFIX_HERB = "",
        PREFIX_MINE = "",
        MATCH_HERB = "약초채집",
        MATCH_MINE = "채광",
        MSG_FORMAT = "{rt7} 와서 가져가세요 // 저기요 %s님, %s %s(을)를 발견했는데 %s 할 수 없네요! 위치: %s, %s (%s)"
    },
    zhCN = {
        ROGUES = "盗贼",
        HERBALISTS = "草药师",
        MINERS = "矿工",
        ACTION_OPEN = "打开",
        ACTION_PICK = "采集",
        ACTION_MINE = "挖掘",
        PREFIX_LOCKED = "上锁的",
        PREFIX_HERB = "",
        PREFIX_MINE = "",
        MATCH_HERB = "草药学",
        MATCH_MINE = "采矿",
        MSG_FORMAT = "{rt7} 快来拿 // 嘿 %s，我发现了一个 %s %s，但我无法 %s！坐标：%s, %s 在 %s"
    }
}
local locale = GetLocale()
if locale == "esMX" then
    locale = "esES"
end
if locale == "enGB" then
    locale = "enUS"
end
local loc = L[locale] or L.enUS

local ANNOUNCE_COOLDOWN, ERROR_LOCKED_CHEST, lastAnnounce = 5, 268, 0
local GetTime, IsInInstance, OpenChat, format = GetTime, IsInInstance, ChatFrame_OpenChat, string.format
local GetBestMapForUnit, GetPlayerMapPosition, GetMapInfo = C_Map and C_Map.GetBestMapForUnit, C_Map and C_Map.GetPlayerMapPosition, C_Map and C_Map.GetMapInfo

local errorMapping = {
    [ERROR_LOCKED_CHEST] = {
        role = loc.ROGUES,
        prefix = loc.PREFIX_LOCKED,
        defaultNode = "TREASURE CHEST",
        action = loc.ACTION_OPEN
    },
    [loc.MATCH_HERB] = {
        role = loc.HERBALISTS,
        prefix = loc.PREFIX_HERB,
        defaultNode = "HERB NAME",
        action = loc.ACTION_PICK
    },
    [loc.MATCH_MINE] = {
        role = loc.MINERS,
        prefix = loc.PREFIX_MINE,
        defaultNode = "MINERAL VEIN",
        action = loc.ACTION_MINE
    }
}

local function GetNodeName()
    local f = _G.GameTooltipTextLeft1
    return f and f:GetText()
end

local function MatchError(messageID, message)
    if errorMapping[messageID] then
        return errorMapping[messageID]
    end
    if not message then
        return nil
    end
    local lowerMessage = string.lower(message)
    for key, mapping in pairs(errorMapping) do
        if type(key) == "string" and string.find(lowerMessage, string.lower(key), 1, true) then
            return mapping
        end
    end
    return nil
end

local function Announce(mapping)
    if IsInInstance() then
        return
    end
    local now = GetTime()
    if now - lastAnnounce < ANNOUNCE_COOLDOWN then
        return
    end
    if not GetBestMapForUnit or not GetPlayerMapPosition or not GetMapInfo then
        return
    end
    local mapID = GetBestMapForUnit("player")
    if not mapID then
        return
    end
    local pos = GetPlayerMapPosition(mapID, "player")
    if not pos then
        return
    end
    local mapInfo = GetMapInfo(mapID)
    if not mapInfo or not mapInfo.name then
        return
    end
    local node = GetNodeName() or mapping.defaultNode
    if not node or node == "" then
        return
    end
    local currentPrefix = mapping.prefix
    if (locale == "enUS" or locale == "enGB") and currentPrefix == "a" and string.find(node, "^[AEIOUaeiou]") then
        currentPrefix = "an"
    end
    OpenChat("/1 " .. format(loc.MSG_FORMAT, mapping.role, currentPrefix, node, mapping.action, format("%.0f", pos.x * 100), format("%.0f", pos.y * 100), mapInfo.name), ChatFrame1)
    lastAnnounce = now
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("UI_ERROR_MESSAGE")
frame:SetScript("OnEvent", function(_, _, messageID, message)
    local map = MatchError(messageID, message)
    if map then
        Announce(map)
    end
end)
