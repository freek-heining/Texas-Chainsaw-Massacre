-- Setup Menu
require("Menu")
-- Dice Tray 
require("Dice_Tray")
-- Restrict certain player actions
require("Behavior_Restrictions")
-- Dealing 4 random Horror Tiles
require("Horror_Tiles")
-- Set all interactables
require("Set_Interactables")

function onLoad()
    UI.setAttribute("setupWindow", "active", false)
    broadcastToAll("First determine the Red / Sawyer player before choosing it!")
    SetInteractableFalse()
end

function SetupGame(achievements, currentScenarioIndex)
    local sawyerDeckGUID = "0a2ad0"
    local sawyerDeckAchievGUID = "4300c2"
    local desperationDeckGUID = "dc7f3e"
    local desperationDeckAchievGUID = "7ba0bc"
    local injuryDeckGUID = "ab13cc"
    local injuryDeckAchievGUID = "f1ac4c"
    local sawyerDeck = getObjectFromGUID(sawyerDeckGUID)
    local sawyerDeckAchiev = getObjectFromGUID(sawyerDeckAchievGUID)
    local desperationDeck = getObjectFromGUID(desperationDeckGUID)
    local desperationDeckAchiev = getObjectFromGUID(desperationDeckAchievGUID)
    local injuryDeck = getObjectFromGUID(injuryDeckGUID)
    local injuryDeckAchiev = getObjectFromGUID(injuryDeckAchievGUID)


    local itemDeckGUID = "920a1b"
    local itemDeck = getObjectFromGUID(itemDeckGUID)
    local itemDeckAchievGUID = "ad86a4"
    local itemDeckAchiev = getObjectFromGUID(itemDeckAchievGUID)
    local personalItemDeckGUID = "d89d3a"
    local personalItemDeck = getObjectFromGUID(personalItemDeckGUID)

    UI.setAttribute("setupWindow", "active", false)

    -- #1: Deal Horror Tiles
    startLuaCoroutine(Global, "DealHorrorTilesCoroutine")

    -- #2: Shuffle & Deal Sawyer Cards
    if achievements then
        sawyerDeckAchiev.shuffle()
        sawyerDeckAchiev.setPosition({12.16, 2.58, -21.00})
        sawyerDeck.destruct()
    else
        sawyerDeck.shuffle()
        sawyerDeck.setPosition({12.16, 2.58, -21.00})
        sawyerDeckAchiev.destruct()
    end

    -- #3: Shuffle & Deal Sawyer Cards
    if achievements then
        desperationDeckAchiev.shuffle()
        desperationDeckAchiev.setPosition({32.82, 2.58, 8.41})
        desperationDeck.destruct()
    else
        desperationDeck.shuffle()
        desperationDeck.setPosition({32.82, 2.58, 8.41})
        desperationDeckAchiev.destruct()
    end

    -- #4: Shuffle & Deal Injury Cards
    if achievements then
        injuryDeckAchiev.shuffle()
        injuryDeckAchiev.setPosition({32.64, 2.58, -4.83}, {0.00, 270.00, 180.00})
        injuryDeck.destruct()
    else
        injuryDeck.shuffle()
        injuryDeck.setPosition({32.64, 2.58, -4.83}, {0.00, 270.00, 180.00})
        injuryDeckAchiev.destruct()
    end

    -- #5: Shuffle & Deal 6 Personal Items
    local personalItemPositions = {
        {25.40, 2.58, -4.60},
        {25.40, 2.58, -8.20},
        {25.40, 2.58, -11.80},
        {25.40, 2.58, -15.40},
        {25.40, 2.58, -19.00},
        {25.40, 2.58, -22.60}
    }
    personalItemDeck.shuffle()

    for i = 1, 6 do
        personalItemDeck.takeObject({
            position = personalItemPositions[i],
            flip = true
        })
    end

    personalItemDeck.destruct()

    broadcastToAll("Roll a D6 to determine first pick on Personal Items, then continue clockwise in player order. Discard the rest")

    -- #6: Set Scenario Boards
    local ScenariosScriptingZoneGUID = "6a561d"
    local ScenariosScriptingZone = getObjectFromGUID(ScenariosScriptingZoneGUID)

    local scenarioNames = {
        "Scenario Card A: Who Will Survive?",
        "Scenario Card B: Burn it Down",
        "Scenario Card C: Ransack",
        "Scenario Card D: I Dare You",
        "Scenario Card E: Things Happened Here"
    }

    for i, object in ipairs(ScenariosScriptingZone.getObjects()) do
        if object.type == "Tile" and object.getName() ~=  scenarioNames[currentScenarioIndex] then
            object.destruct()
        elseif object.type == "Tile" then
            object.locked = false
            Wait.time(function() object.locked = true end, 1)
        end
    end

    -- #7: Set Item Cards
    if achievements then
        itemDeckAchiev.shuffle()
        
        itemDeck.destruct()
    else
        itemDeck.shuffle()
      
        itemDeckAchiev.destruct()
    end


    -- #8: Set Scenario Cards
    local ScenariosADeckGUID = "382ea5"
    local ScenariosADeck = getObjectFromGUID(ScenariosADeckGUID)
    local ScenariosBDeckGUID = "12acdc"
    local ScenariosBDeck = getObjectFromGUID(ScenariosBDeckGUID)
    local ScenariosCDeckGUID = "d94c03"
    local ScenariosCDeck = getObjectFromGUID(ScenariosCDeckGUID)
    local ScenarioDECardGUID = "d71bc0"
    local ScenarioDECard = getObjectFromGUID(ScenarioDECardGUID)
    local ScenariosEDeckGUID = "8c348f"
    local ScenariosEDeck = getObjectFromGUID(ScenariosEDeckGUID)

end
