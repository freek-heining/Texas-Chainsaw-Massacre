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
local cardToBury

function onObjectEnterZone(zone, object)
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

    local function buryCardOrDeck()
        Wait.time(function ()
            cardToBury.setPositionSmooth({17.72, 2.68, -21.00}, false, true)
        end, 0.3)

        Wait.time(function ()
            -- If not nil
            if cardToBury then
                activeSawyerDeck.locked = false
                log("Burying card:")
                log(cardToBury)
                cardToBury.setPosition(cardToBury.getPosition() + vector(0, -1, 0))
                activeSawyerDeck.putObject(cardToBury)
                activeSawyerDeck.locked = true
            end
        end, 3)
    end
    
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

    if zone == burySawyerScriptingZone and object.type == "Card" then
        cardToBury = object
        log("------")
        log("Starting bury of card:")
        log(cardToBury)

        buryCardOrDeck()
    end
end

function onObjectLeaveZone(zone, object)
    -- Stop card from burying by setting cardToBury to nil and cancel all Waits
    if (zone == burySawyerScriptingZone) and (object == cardToBury) then
        cardToBury = nil
        log("Cancelling bury: cardToBury = " .. tostring(cardToBury))
        Wait.stopAll()
    end
end


-- TODO DECK!