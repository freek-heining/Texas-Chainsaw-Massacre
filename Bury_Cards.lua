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

-- Hold references to cards/decks on bury spots
local sawyerCardOrDeckToBury
local DesperationCardOrDeckToBury
local injuryCardOrDeckToBury
local item1CardOrDeckToBury
local item2CardOrDeckToBury

-- If not nil, move card/deck to bottom deck
local function buryCardOrDeck(cardOrDeckToBury, activeDeck)
    Wait.time(function ()
        log("bury wait")
        activeDeck.locked = false
        cardOrDeckToBury.setPosition(cardOrDeckToBury.getPosition() + vector(0, -1, 0))
        activeDeck.putObject(cardOrDeckToBury)
        activeDeck.locked = true
    end, 2)
end

-- Tidy up cards. Y needs to be around 2.8 or higher, else cards go to bottom!
local function tidyUpCards(cardOrDeckToBury, position, rotation)
    Wait.time(function ()
        cardOrDeckToBury.highlightOn("Green", 1)
        cardOrDeckToBury.setPositionSmooth(position, false, true)
        cardOrDeckToBury.setRotationSmooth(rotation, false, true)
        if not cardOrDeckToBury.is_face_down then
            cardOrDeckToBury.flip()
        end
    end, 0.1)
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
    -- Check all 5 bury zones seperately. Also triggers when deck is created inside!
    -- Sawyer
    if (zone == burySawyerScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        sawyerCardOrDeckToBury = object
        if sawyerCardOrDeckToBury.type == "Deck" then
            log("Deck entering")
        end
        if sawyerCardOrDeckToBury.type == "Card" then
            log("Card entering")
        end        
        local position = {17.72, 2.8, -21.00}
        local rotation = {0.00, 180.00, 180.00}
        tidyUpCards(sawyerCardOrDeckToBury, position, rotation)
        buryCardOrDeck(sawyerCardOrDeckToBury, activeSawyerDeck)
    -- Desperation
    elseif (zone == buryDesperationScriptingZone) and (object.type == "Card" or object.type == "Deck")  then
        DesperationCardOrDeckToBury = object
        local position = {32.82, 2.8, 2.72}
        local rotation = {0.00, 270.00, 180.00}
        tidyUpCards(DesperationCardOrDeckToBury, position, rotation)
        buryCardOrDeck(DesperationCardOrDeckToBury, activeDesperationDeck)
    -- Injury
    elseif (zone == buryInujryScriptingZone) and (object.type == "Card" or object.type == "Deck")  then
        injuryCardOrDeckToBury = object
        local position = {32.64, 2.8, -8.88}
        local rotation = {0.00, 270.00, 180.00}
        tidyUpCards(injuryCardOrDeckToBury, position, rotation)
        buryCardOrDeck(injuryCardOrDeckToBury, activeInjuryDeck)
    -- Item Ground Floor
    elseif (zone == buryItem1ScriptingZone) and (object.type == "Card" or object.type == "Deck")  then
        item1CardOrDeckToBury = object
        local position = {5.73, 2.8, 0.00}
        local rotation = {0.00, 0.00, 180.00}
        tidyUpCards(item1CardOrDeckToBury, position, rotation)
        buryCardOrDeck(item1CardOrDeckToBury, itemDeck1)
    -- Item 1st Floor
    elseif (zone == buryItem2ScriptingZone) and (object.type == "Card" or object.type == "Deck")  then
        item2CardOrDeckToBury = object
        local position = {24.70, 2.8, 0.00}
        local rotation = {0.00, 0.00, 180.00}
        tidyUpCards(item2CardOrDeckToBury, position, rotation)
        buryCardOrDeck(item2CardOrDeckToBury, itemDeck2)
    end
end

-- Card leaving and/or a deck is created
function onObjectLeaveZone(zone, object)
    -- Stop cards/decks from burying by cancelling all queued Waits
    -- Sawyer
    if (zone == burySawyerScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        Wait.stopAll()

        if sawyerCardOrDeckToBury.type == "Deck" then
            log("Deck leaving")
        end
        if sawyerCardOrDeckToBury.type == "Card" then
            log("Card leaving")
        end    
        -- Check if a deck > 2 cards is created, set variable and continue burying. Wait needed otherwise it's to fast for check. 
        -- (Deck of 2 is handled via onObjectEnterZone, because the creation of a deck counts as entering a zone)
        Wait.time(function ()
            for _, zoneObject in ipairs(burySawyerScriptingZone.getObjects()) do
                if zoneObject.type == "Deck" then
                    sawyerCardOrDeckToBury = zoneObject
                    buryCardOrDeck(sawyerCardOrDeckToBury, activeSawyerDeck)
                end
            end
        end, 0.1)
    -- Desperation
    elseif (zone == buryDesperationScriptingZone) and (object == DesperationCardOrDeckToBury) then
        Wait.stopAll()

        Wait.time(function ()
            for _, zoneObject in ipairs(buryDesperationScriptingZone.getObjects()) do
                if zoneObject.type == "Deck" then
                    DesperationCardOrDeckToBury = zoneObject
                    buryCardOrDeck(DesperationCardOrDeckToBury, activeDesperationDeck)
                end
            end
        end, 0.1)
    -- Injury
    elseif (zone == buryInujryScriptingZone) and (object == injuryCardOrDeckToBury) then
        Wait.stopAll()

        Wait.time(function ()
            for _, zoneObject in ipairs(buryInujryScriptingZone.getObjects()) do
                if zoneObject.type == "Deck" then
                    injuryCardOrDeckToBury = zoneObject
                    buryCardOrDeck(injuryCardOrDeckToBury, activeInjuryDeck)
                end
            end
        end, 0.1)
    -- Item Ground Floor        
    elseif (zone == buryItem1ScriptingZone) and (object == item1CardOrDeckToBury) then
        Wait.stopAll()

        Wait.time(function ()
            for _, zoneObject in ipairs(buryItem1ScriptingZone.getObjects()) do
                if zoneObject.type == "Deck" then
                    item1CardOrDeckToBury = zoneObject
                    buryCardOrDeck(item1CardOrDeckToBury, itemDeck1)
                end
            end
        end, 0.1)
    -- Item 1st Floor        
    elseif (zone == buryItem2ScriptingZone) and (object == item2CardOrDeckToBury) then
        Wait.stopAll()

        Wait.time(function ()
            for _, zoneObject in ipairs(buryItem2ScriptingZone.getObjects()) do
                if zoneObject.type == "Deck" then
                    item2CardOrDeckToBury = zoneObject
                    buryCardOrDeck(item2CardOrDeckToBury, itemDeck2)
                end
            end
        end, 0.1)
    end
end