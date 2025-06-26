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

-- Stores Bury Wait Id's for all decks objects
local waitBury = {}

-- Stores Tidy Wait Id's for all card and deck objects
local waitTidy = {}

local waitFlicker = {}

-- 0.2s on, 0.2s off x 10 = 4 seconds
local function flickerCard(cardOrDeckToBury)
    waitFlicker[cardOrDeckToBury] = Wait.time(function ()
        cardOrDeckToBury.highlightOn("Teal", 0.2)
    end, 0.4, 10)
end

-- Move card/deck to bottom deck. Each deck has a seperate Wait Id so a cancel does not interfere with the rest.
-- The flow can be different depending how cards and decks are created by player. That's why we have to make sure to always have only 1 waitBury active. 
-- For example: 2 seperate cards will tidy and then create a deck. OR 1 card will tidy and then a deck is created by dropping a cards right on top of the first. This will change the flow.
local function buryCardOrDeck(cardOrDeckToBury, activeDeck, deckNumber)
    -- Make sure we only have 1 fresh bury/wait to be run
    if waitBury[deckNumber] then
        Wait.stop(waitBury[deckNumber])
        waitBury[deckNumber] = nil
    end

    -- Make sure we only have 1 fresh flicker/wait to be run
    if waitFlicker[cardOrDeckToBury] then
        Wait.stop(waitFlicker[cardOrDeckToBury])
        waitFlicker[cardOrDeckToBury] = nil
    end

    flickerCard(cardOrDeckToBury)

    -- Position needs to be lowered or else the cards go to top of decks
    waitBury[deckNumber] = Wait.time(
        function ()
            waitBury[deckNumber] = nil
            activeDeck.locked = false
            cardOrDeckToBury.setPosition(cardOrDeckToBury.getPosition() + vector(0, -1, 0))
            activeDeck.putObject(cardOrDeckToBury)
            activeDeck.locked = true
        end, 2
    )
end

-- Tidy up cards and chain call to buryCardOrDeck() afterwards. Y needs to be around 2.68 or higher, else cards clip their tray.
local function tidyUpCards(cardOrDeck, position, rotation, activeDeck, deckNumber)
    flickerCard(cardOrDeck)

    waitTidy[cardOrDeck] = Wait.time(
        function ()
            waitTidy[cardOrDeck] = nil
            local updatedPosition = position:add(vector(0, 0.1, 0))
            cardOrDeck.setPositionSmooth(updatedPosition, false, true)
            cardOrDeck.setRotation(rotation)
            buryCardOrDeck(cardOrDeck, activeDeck, deckNumber)
        end, 1
    )
end

--Also triggers when deck is created inside = card leaving! (Or visa versa)
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
    --#endregion

    -- Check all 5 bury zones seperately
    -- *Sawyer
    if (zone == burySawyerScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Sawyer Card")) then
        local position = burySawyerScriptingZone.getPosition()
        local rotation = {0.00, 180.00, 180.00}
        
        tidyUpCards(object, position, rotation, activeSawyerDeck, 1)
    -- *Desperation
    elseif (zone == buryDesperationScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Desperation Card")) then
        local position = buryDesperationScriptingZone.getPosition()
        local rotation = {0.00, 270.00, 180.00}

        tidyUpCards(object, position, rotation, activeDesperationDeck, 2)
    -- *Injury
    elseif (zone == buryInujryScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Injury Card")) then
        local position = buryInujryScriptingZone.getPosition()
        local rotation = {0.00, 270.00, 180.00}

        tidyUpCards(object, position, rotation, activeInjuryDeck, 3)
    -- *Item Ground Floor
    elseif (zone == buryItem1ScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Item Card")) then
        local position = buryItem1ScriptingZone.getPosition()
        local rotation = {0.00, 0.00, 180.00}

        tidyUpCards(object, position, rotation, ItemDeck1, 4)
    -- *Item 1st Floor
    elseif (zone == buryItem2ScriptingZone) and (object.type == "Card" or object.type == "Deck") and (object.hasTag("Item Card")) then
        local position = buryItem2ScriptingZone.getPosition()
        local rotation = {0.00, 0.00, 180.00}

        tidyUpCards(object, position, rotation, ItemDeck2, 5)
    end
end

-- Cards or deck leaving and/or a deck is created
function onObjectLeaveZone(zone, object)
    -- Stop cards/decks from burying/flickering/tidying by cancelling queued Waits
    -- Cancel/clear flickering wait if leaving (early). waitFlicker will also be made nil when it's run
    if waitFlicker[object] then
        Wait.stop(waitFlicker[object])
        waitFlicker[object] = nil
    end

    -- Cancel/clear tidy wait if leaving early. waitTidy will also be made nil when it's run
    if waitTidy[object] then
        Wait.stop(waitTidy[object])
        waitTidy[object] = nil
    end

    -- *Sawyer
    if (zone == burySawyerScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        -- Cancel/clear bury wait if leaving early or deck gets created = card leaving. waitBury will also be made nil when it's run
        if waitBury[1] then
            Wait.stop(waitBury[1])
            waitBury[1] = nil
        end

        -- Check if another deck or card is present, then continue burying with new variable
        -- For example: multiple cards or a deck becomes a card or visa versa
        for _, sawyerCardOrDeckToBury in ipairs(burySawyerScriptingZone.getObjects()) do
            if sawyerCardOrDeckToBury.type == "Deck" or sawyerCardOrDeckToBury.type == "Card" then
                buryCardOrDeck(sawyerCardOrDeckToBury, activeSawyerDeck, 1)
            end
        end
    -- *Desperation
    elseif (zone == buryDesperationScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[2] then
            Wait.stop(waitBury[2])
            waitBury[2] = nil
        end

        for _, desperationCardOrDeckToBury in ipairs(buryDesperationScriptingZone.getObjects()) do
            if desperationCardOrDeckToBury.type == "Deck" or desperationCardOrDeckToBury.type == "Card" then
                buryCardOrDeck(desperationCardOrDeckToBury, activeDesperationDeck, 2)
            end
        end
    -- *Injury
    elseif (zone == buryInujryScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[3] then
            Wait.stop(waitBury[3])
            waitBury[3] = nil
        end

        for _, injuryCardOrDeckToBury in ipairs(buryInujryScriptingZone.getObjects()) do
            if injuryCardOrDeckToBury.type == "Deck" or injuryCardOrDeckToBury.type == "Card" then
                buryCardOrDeck(injuryCardOrDeckToBury, activeInjuryDeck, 3)
            end
        end
    -- *Item Ground Floor        
    elseif (zone == buryItem1ScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[4] then
            Wait.stop(waitBury[4])
            waitBury[4] = nil
        end

        for _, item1CardOrDeckToBury in ipairs(buryItem1ScriptingZone.getObjects()) do
            if item1CardOrDeckToBury.type == "Deck" or item1CardOrDeckToBury.type == "Card" then
                buryCardOrDeck(item1CardOrDeckToBury, ItemDeck1, 4)
            end
        end
    -- *Item 1st Floor        
    elseif (zone == buryItem2ScriptingZone) and (object.type == "Card" or object.type == "Deck") then
        if waitBury[5] then
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