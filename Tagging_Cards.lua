local sawyerDeckGUID
local sawyerDeckAchievGUID
local desperationDeckGUID
local desperationDeckAchievGUID
local injuryDeckGUID
local injuryDeckAchievGUID
local personalItemDeckGUID
local sawyerDeck
local sawyerDeckAchiev
local desperationDeck
local desperationDeckAchiev
local injuryDeck
local injuryDeckAchiev
local personalItemDeck

local activeSawyerDeck
local activeDesperationDeck
local activeInjuryDeck

-- Tags cards when leaving deck. Used for bury cards etc.
function onObjectLeaveContainer(container, object)
    sawyerDeckGUID = "0a2ad0"
    sawyerDeckAchievGUID = "4300c2"
    desperationDeckGUID = "dc7f3e"
    desperationDeckAchievGUID = "7ba0bc"
    injuryDeckGUID = "ab13cc"
    injuryDeckAchievGUID = "f1ac4c"
    personalItemDeckGUID = "d89d3a"
    sawyerDeck = getObjectFromGUID(sawyerDeckGUID)
    sawyerDeckAchiev = getObjectFromGUID(sawyerDeckAchievGUID)
    desperationDeck = getObjectFromGUID(desperationDeckGUID)
    desperationDeckAchiev = getObjectFromGUID(desperationDeckAchievGUID)
    injuryDeck = getObjectFromGUID(injuryDeckGUID)
    injuryDeckAchiev = getObjectFromGUID(injuryDeckAchievGUID)
    personalItemDeck = getObjectFromGUID(personalItemDeckGUID)

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

    if container == activeSawyerDeck and object.type == "Card" then
        object.addTag("Sawyer Card")
    elseif container == activeDesperationDeck and object.type == "Card" then
        object.addTag("Desperation Card")
    elseif container == activeInjuryDeck and object.type == "Card" then
        object.addTag("Injury Card")
    elseif container == ItemDeck1 and object.type == "Card" then
        object.addTag("Item1 Card")
    elseif container == ItemDeck2 and object.type == "Card" then
        object.addTag("Item2 Card")
    elseif container == personalItemDeck and object.type == "Card" then
        object.addTag("Personal Item")
    end
end