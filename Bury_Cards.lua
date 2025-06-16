local burySawyerScriptingZoneGUID
local burySawyerScriptingZone
local buryDesperationScriptingZoneGUID
local buryDesperationScriptingZone
local buryInujryScriptingZoneGUID
local buryInujryScriptingZone
local buryItem1ScriptingZoneGUID
local buryItem1ScriptingZone
local buryItem2ScriptingZoneGUID
local buryItem2ScriptingZone

local sawyerDeckGUID
local sawyerDeckAchievGUID
local desperationDeckGUID
local desperationDeckAchievGUID
local injuryDeckGUID
local injuryDeckAchievGUID
local sawyerDeck
local sawyerDeckAchiev
local desperationDeck
local desperationDeckAchiev
local injuryDeck
local injuryDeckAchiev

local activeSawyerDeck
local activeDesperationDeck
local activeInjuryDeck
local itemDeck1
local itemDeck2

local waitBury = {
    waitBurySawyer = nil,
    waitBuryDesperation = nil,
    waitBuryInjury = nil,
    waitBuryItem1 = nil,
    waitBuryItem2 = nil
}

-- Move card/deck to bottom deck. Each deck has a seperate Wait Id so a cancel does not interfere with the rest.
local function buryCardOrDeck(cardOrDeckToBury, activeDeck, deckNumber)
    -- Make sure we only have 1 fresh wait to be run
    if waitBury[deckNumber] then
        Wait.stop(waitBury[deckNumber])
        waitBury[deckNumber] = nil
    end

    waitBury[deckNumber] = Wait.time(function ()
        waitBury[deckNumber] = nil
        activeDeck.locked = false
        cardOrDeckToBury.setPosition(cardOrDeckToBury.getPosition() + vector(0, -1, 0))
        activeDeck.putObject(cardOrDeckToBury)
        activeDeck.locked = true
    end, 2)
end

-- Tidy up cards. Y needs to be around 2.8 or higher, else cards go to bottom!
local function tidyUpCards(cardOrDeck, position, rotation)
    log("tidy")
    cardOrDeck.setPositionSmooth(position, false, true)
    cardOrDeck.setRotationSmooth(rotation, false, true)
end

function onObjectEnterZone(zone, object)
--#Set Guids and Objects
    burySawyerScriptingZoneGUID = "5e69ad"
    burySawyerScriptingZone = getObjectFromGUID(burySawyerScriptingZoneGUID)
    buryDesperationScriptingZoneGUID = "c613db"
    buryDesperationScriptingZone = getObjectFromGUID(buryDesperationScriptingZoneGUID)
    buryInujryScriptingZoneGUID = "cdbc64"
    buryInujryScriptingZone = getObjectFromGUID(buryInujryScriptingZoneGUID)
    buryItem1ScriptingZoneGUID = "83a876"
    buryItem1ScriptingZone = getObjectFromGUID(buryItem1ScriptingZoneGUID)
    buryItem2ScriptingZoneGUID = "457d56"
    buryItem2ScriptingZone = getObjectFromGUID(buryItem2ScriptingZoneGUID)

    sawyerDeckGUID = "0a2ad0"
    sawyerDeckAchievGUID = "4300c2"
    desperationDeckGUID = "dc7f3e"
    desperationDeckAchievGUID = "7ba0bc"
    injuryDeckGUID = "ab13cc"
    injuryDeckAchievGUID = "f1ac4c"
    sawyerDeck = getObjectFromGUID(sawyerDeckGUID)
    sawyerDeckAchiev = getObjectFromGUID(sawyerDeckAchievGUID)
    desperationDeck = getObjectFromGUID(desperationDeckGUID)
    desperationDeckAchiev = getObjectFromGUID(desperationDeckAchievGUID)
    injuryDeck = getObjectFromGUID(injuryDeckGUID)
    injuryDeckAchiev = getObjectFromGUID(injuryDeckAchievGUID)

    -- Set active decks
    if AchievementsUsed then
        activeSawyerDeck = sawyerDeckAchiev
        activeDesperationDeck = desperationDeckAchiev
        activeInjuryDeck = injuryDeckAchiev
    else
        activeSawyerDeck = sawyerDeck
        activeDesperationDeck = desperationDeck
        activeInjuryDeck = injuryDeck
    end

    -- Set 2 local item decks from 2 Globals in Setup_Game
    itemDeck1 = ItemDeck1
    itemDeck2 = ItemDeck2
--      
    local objectPosition = object.getPosition()
    local objectYPosition = tonumber(objectPosition.y)
    
    -- Check all 5 bury zones seperately. Also triggers when deck is created inside!
    -- Sawyer
    if (zone == burySawyerScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Sawyer Card")) then
        local position = {17.72, 2.8, -21.00}
        local rotation = {0.00, 180.00, 180.00}
        
        -- Only activate when dropped from hand
        if objectYPosition > 2.95 then
            tidyUpCards(object, position, rotation)
        end
        
        buryCardOrDeck(object, activeSawyerDeck, 1)
    -- Desperation
    elseif (zone == buryDesperationScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Desperation Card")) then
        local position = {32.82, 2.8, 2.72}
        local rotation = {0.00, 270.00, 180.00}

        if objectYPosition > 2.95 then
            tidyUpCards(object, position, rotation)
        end

        buryCardOrDeck(object, activeDesperationDeck, 2)
    -- Injury
    elseif (zone == buryInujryScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Injury Card")) then
        local position = {32.64, 2.8, -8.88}
        local rotation = {0.00, 270.00, 180.00}

        if objectYPosition > 2.95 then
            tidyUpCards(object, position, rotation)
        end

        buryCardOrDeck(object, activeInjuryDeck, 3)
    -- Item Ground Floor
    elseif (zone == buryItem1ScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Item1 Card")) then
        local position = {5.73, 2.8, -0.40}
        local rotation = {0.00, 0.00, 180.00}

        if objectYPosition > 2.95 then
            tidyUpCards(object, position, rotation)
        end
        
        buryCardOrDeck(object, itemDeck1, 4)
    -- Item 1st Floor
    elseif (zone == buryItem2ScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Item2 Card")) then
        local position = {24.70, 2.8, -0.40}
        local rotation = {0.00, 0.00, 180.00}

        if objectYPosition > 2.95 then
            tidyUpCards(object, position, rotation)
        end
        
        buryCardOrDeck(object, itemDeck2, 5)
    end
end

-- Cards or deck leaving and/or a deck is created
function onObjectLeaveZone(zone, object)
    -- Stop cards/decks from burying by cancelling queued Wait
    -- Sawyer
    if (zone == burySawyerScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        -- Cancel wait if leaving
        if waitBury[1] then
            log("leaving wait")
            Wait.stop(waitBury[1])
            waitBury[1] = nil
        end

        -- Check if a deck or card is present, then continue burying with new variable.
        for _, sawyerCardOrDeckToBury in ipairs(burySawyerScriptingZone.getObjects()) do
            if sawyerCardOrDeckToBury.type == "Deck" or sawyerCardOrDeckToBury.type == "Card" then
                buryCardOrDeck(sawyerCardOrDeckToBury, activeSawyerDeck, 1)
            end
        end
    -- Desperation
    elseif (zone == buryDesperationScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[2] then
            log("leaving wait")
            Wait.stop(waitBury[2])
            waitBury[2] = nil
        end

        for _, desperationCardOrDeckToBury in ipairs(buryDesperationScriptingZone.getObjects()) do
            if desperationCardOrDeckToBury.type == "Deck" or desperationCardOrDeckToBury.type == "Card" then
                buryCardOrDeck(desperationCardOrDeckToBury, activeDesperationDeck, 2)
            end
        end
    -- Injury
    elseif (zone == buryInujryScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[3] then
            log("leaving wait")
            Wait.stop(waitBury[3])
            waitBury[3] = nil
        end

        for _, injuryCardOrDeckToBury in ipairs(buryInujryScriptingZone.getObjects()) do
            if injuryCardOrDeckToBury.type == "Deck" or injuryCardOrDeckToBury.type == "Card" then
                buryCardOrDeck(injuryCardOrDeckToBury, activeInjuryDeck, 3)
            end
        end
    -- Item Ground Floor        
    elseif (zone == buryItem1ScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[4] then
            log("leaving wait")
            Wait.stop(waitBury[4])
            waitBury[4] = nil
        end

        for _, item1CardOrDeckToBury in ipairs(buryItem1ScriptingZone.getObjects()) do
            if item1CardOrDeckToBury.type == "Deck" or item1CardOrDeckToBury.type == "Card" then
                buryCardOrDeck(item1CardOrDeckToBury, ItemDeck1, 4)
            end
        end
    -- Item 1st Floor        
    elseif (zone == buryItem2ScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[5] then
            log("leaving wait")
            Wait.stop(waitBury[5])
            waitBury[5] = nil
        end

        for _, item2CardOrDeckToBury in ipairs(buryItem2ScriptingZone.getObjects()) do
            if item2CardOrDeckToBury.type == "Deck" or item2CardOrDeckToBury.type == "Card" then
                buryCardOrDeck(item2CardOrDeckToBury, ItemDeck2, 5)
            end
        end
    end
end