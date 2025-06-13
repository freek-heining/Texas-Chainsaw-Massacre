-- scenarioIndex holds active scenario
local scenarioIndex = 0
-- activeItemDeck holds itemDeck or itemDeckAchiev
local activeItemDeck

-- Run after player pressed 'Start Game' from menu
function SetupGame(achievements, chosenScenarioIndex)
    local sawyerDeckGUID = "0a2ad0"
    local sawyerDeckAchievGUID = "4300c2"
    local desperationDeckGUID = "dc7f3e"
    local desperationDeckAchievGUID = "7ba0bc"
    local injuryDeckGUID = "ab13cc"
    local injuryDeckAchievGUID = "f1ac4c"
    local itemDeckGUID = "920a1b"
    local itemDeckAchievGUID = "ad86a4"
    local personalItemDeckGUID = "d89d3a"
    local sawyerDeck = getObjectFromGUID(sawyerDeckGUID)
    local sawyerDeckAchiev = getObjectFromGUID(sawyerDeckAchievGUID)
    local desperationDeck = getObjectFromGUID(desperationDeckGUID)
    local desperationDeckAchiev = getObjectFromGUID(desperationDeckAchievGUID)
    local injuryDeck = getObjectFromGUID(injuryDeckGUID)
    local injuryDeckAchiev = getObjectFromGUID(injuryDeckAchievGUID)
    local itemDeck = getObjectFromGUID(itemDeckGUID)
    local itemDeckAchiev = getObjectFromGUID(itemDeckAchievGUID)
    local personalItemDeck = getObjectFromGUID(personalItemDeckGUID)

    UI.setAttribute("setupWindow", "active", false)

    -- scenarioIndex holds active scenario
    scenarioIndex = chosenScenarioIndex

    -- Global used in Bury_Cards
    AchievementsUsed = achievements

    -- #1: Deal Horror Tiles
    startLuaCoroutine(Global, "DealHorrorTilesCoroutine")

    -- #2: Shuffle & Deal Sawyer Cards
    if achievements then
        sawyerDeckAchiev.shuffle()
        sawyerDeckAchiev.locked=false
        sawyerDeckAchiev.setPosition({12.16, 2.7, -21.00})
        Wait.time(function() sawyerDeckAchiev.locked = true end, 1)
        sawyerDeck.destruct()
    else
        sawyerDeck.shuffle()
        sawyerDeck.locked=false
        sawyerDeck.setPosition({12.16, 2.7, -21.00})
        Wait.time(function() sawyerDeck.locked = true end, 1)
        sawyerDeckAchiev.destruct()
    end

    -- #3: Shuffle & Deal Desperation Cards
    if achievements then
        desperationDeckAchiev.shuffle()
        desperationDeckAchiev.locked=false
        desperationDeckAchiev.setPosition({32.82, 2.7, 8.41})
        Wait.time(function() desperationDeckAchiev.locked = true end, 1)
        desperationDeck.destruct()
    else
        desperationDeck.shuffle()
        desperationDeck.locked=false
        desperationDeck.setPosition({32.82, 2.7, 8.41})
        Wait.time(function() desperationDeck.locked = true end, 1)
        desperationDeckAchiev.destruct()
    end

    -- #4: Shuffle & Deal Injury Cards
    if achievements then
        injuryDeckAchiev.shuffle()
        injuryDeckAchiev.locked=false
        injuryDeckAchiev.setPosition({32.64, 2.7, -4.83}, {0.00, 270.00, 180.00})
        Wait.time(function() injuryDeckAchiev.locked = true end, 1)
        injuryDeck.destruct()
    else
        injuryDeck.shuffle()
        injuryDeck.locked=false
        injuryDeck.setPosition({32.64, 2.7, -4.83}, {0.00, 270.00, 180.00})
        Wait.time(function() injuryDeck.locked = true end, 1)
        injuryDeckAchiev.destruct()
    end

    -- #5: Shuffle & Deal 6 Personal Items
    local personalItemPositions = {
        {32.70, 2.58, -19.16},
        {28.70, 2.58, -19.16},
        {24.70, 2.58, -19.16},
        {32.70, 2.58, -14.00},
        {28.70, 2.58, -14.00},
        {24.70, 2.58, -14.00}
    }
    personalItemDeck.shuffle()

    for i = 1, 6 do
        personalItemDeck.takeObject({
            position = personalItemPositions[i],
            rotation = {0.00, 0.00, 0.00},
            flip = true
        })
    end

    local itemDieGUID = "2bd87f"
    local itemDie = getObjectFromGUID(itemDieGUID)
    itemDie.setPosition({28.70, 2.92, -22.22})

    personalItemDeck.setPosition({42.24, 2.66, -14.00})

    broadcastToAll("- Roll the red die to determine first pick on Personal Items, then continue clockwise in player order. Discard the rest.")

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
        if object.type == "Tile" and object.getName() ~=  scenarioNames[chosenScenarioIndex] then
            object.destruct()
        elseif object.type == "Tile" then
            object.locked = false
            Wait.time(function() object.locked = true end, 1)
        end
    end

    -- #7: Set Item Cards
    -- activeItemDeck holds itemDeck or itemDeckAchiev
    if achievements then
        activeItemDeck = itemDeckAchiev
        itemDeck.destruct()
    else
        activeItemDeck = itemDeck
        itemDeckAchiev.destruct()
    end

    -- #8: Set Scenario Items
    startLuaCoroutine(Global, "SetupScenarioItemsCoroutine")

    -- #9: Set Vehicle Cards
    startLuaCoroutine(Global, "SetupVehiclesCoroutine")
end

function SetupVehiclesCoroutine()
    local vehicleDeckGUID = "83a551"
    local vehicleDeck = getObjectFromGUID(vehicleDeckGUID)
    local vehicleGuid

    -- Scenario 1 & 2
    if scenarioIndex == 1 or scenarioIndex == 2 then
        local iterator = 1
        for _, vehicleCard in ipairs(vehicleDeck.getObjects()) do
            if iterator > 3 then
                break
            end
            
            vehicleGuid = vehicleCard.guid
            
            -- Delete 3 randoms excluding 3 named
            if not (vehicleCard.name == "Orange Car" or vehicleCard.name == "Blue Truck" or vehicleCard.name == "Green Van") then
                iterator = iterator + 1

                vehicleDeck.takeObject({
                    position = {37.39, 2.58, 12.88},
                    guid = vehicleGuid,
                    callback_function = function(card)
                        card.destruct()
                    end
                })
            end

            for _ = 1, 30 do coroutine.yield(0) end
        end

        for _ = 1, 30 do coroutine.yield(0) end
        vehicleDeck.shuffle()
        for _ = 1, 60 do coroutine.yield(0) end
        DealVehicles()

    -- Scenario 3 (manual dealing)
    elseif scenarioIndex == 3 then
        for _, vehicleCard in ipairs(vehicleDeck.getObjects()) do
            vehicleGuid = vehicleCard.guid

            -- Seperate and move Blue Truck
            if vehicleCard.name == "Blue Truck" then
                vehicleDeck.takeObject({
                    position = {36.65, 2.58, -17.00},
                    rotation = {0.00, 0.00, 0.00},
                    guid = vehicleGuid
                })
            end
        end
        
        local iterator = 1
        for _, vehicleCard in ipairs(vehicleDeck.getObjects()) do
            if iterator > 3 then
                break
            end

            vehicleGuid = vehicleCard.guid

            -- Delete 3 randoms excluding 1 named
            if not (vehicleCard.name == "Pile of Parts") then
                iterator = iterator + 1
                
                vehicleDeck.takeObject({
                    position = {37.39, 2.58, 12.88},
                    guid = vehicleGuid,
                    callback_function = function(card)
                        card.destruct()
                    end
                })
            end

            for _ = 1, 30 do coroutine.yield(0) end
        end

        -- Enable deal button
        vehicleDeck.UI.setAttribute("vehicleDeal", "active", true)

        broadcastToAll("- Place the Blue Truck on a vehicle space of choice, then press the 'Deal Vehicles' button.")

    -- Scenario 4
    elseif scenarioIndex == 4 then
        local iterator = 1
        for _, vehicleCard in ipairs(vehicleDeck.getObjects()) do
            if iterator > 3 then
                break
            end
            
            vehicleGuid = vehicleCard.guid
            
            -- Delete 3 randoms excluding 2 named
            if not (vehicleCard.name == "Secret Stash" or vehicleCard.name == "Green Van") then
                iterator = iterator + 1

                vehicleDeck.takeObject({
                    position = {37.39, 2.58, 12.88},
                    guid = vehicleGuid,
                    callback_function = function(card)
                        card.destruct()
                    end
                })
            end

            for _ = 1, 30 do coroutine.yield(0) end
        end

        for _ = 1, 30 do coroutine.yield(0) end
        vehicleDeck.shuffle()
        for _ = 1, 60 do coroutine.yield(0) end
        DealVehicles()

    -- Scenario 5
    elseif scenarioIndex == 5 then
        local iterator = 1
        for _, vehicleCard in ipairs(vehicleDeck.getObjects()) do
            if iterator > 3 then
                break
            end
            
            vehicleGuid = vehicleCard.guid
            
            -- Delete 3 randoms excluding 1 named
            if not (vehicleCard.name == "Secret Stash") then
                iterator = iterator + 1

                vehicleDeck.takeObject({
                    position = {37.39, 2.58, 12.88},
                    guid = vehicleGuid,
                    callback_function = function(card)
                        card.destruct()
                    end
                })
            end

            for _ = 1, 30 do coroutine.yield(0) end
        end

        for _ = 1, 30 do coroutine.yield(0) end
        vehicleDeck.shuffle()
        for _ = 1, 60 do coroutine.yield(0) end
        DealVehicles()
    end

    return 1
end

function SetupScenarioItemsCoroutine()
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
    local photoTokensStackGUID = "764fd1"
    local photoTokensStack = getObjectFromGUID(photoTokensStackGUID)
    local lootTokensStackGUID = "ceac14"
    local lootTokensStack = getObjectFromGUID(lootTokensStackGUID)

    local function splitDealItems()
        -- split() returns a table
        local splitItemDecksTable = activeItemDeck.split(2)
        splitItemDecksTable[1].setPosition({5.73, 2.58, 4.95})
        splitItemDecksTable[1].setRotation({0.00, 0.00, 180.00})
        splitItemDecksTable[2].setPosition({24.70, 2.58, 5.07})
        splitItemDecksTable[2].setRotation({0.00, 0.00, 180.00})

        for _ = 1, 30 do coroutine.yield(0) end

        -- Globals used in Bury_Cards
        ItemDeck1 = splitItemDecksTable[1]
        ItemDeck2 = splitItemDecksTable[2]

        splitItemDecksTable[1].locked = true
        splitItemDecksTable[2].locked = true
    end

    -- activeItemDeck = global that holds itemDeck or itemDeckAchiev
    -- Scenario A
    if scenarioIndex == 1 then
        ScenariosBDeck.destruct()
        ScenariosCDeck.destruct()
        ScenarioDECard.destruct()
        ScenariosEDeck.destruct()
        photoTokensStack.destruct()
        lootTokensStack.destruct()

        activeItemDeck.locked = false
        ScenariosADeck.locked = false

        -- Merge decks
        activeItemDeck.putObject(ScenariosADeck)
        
        for _ = 1, 100 do
            coroutine.yield(0)
        end
        
        activeItemDeck.shuffle()

        for _ = 1, 60 do
            coroutine.yield(0)
        end

        splitDealItems()

    -- Scenario B    
    elseif scenarioIndex == 2 then
        local scenarioBCardPositions = {
            {-25.60, 2.58, -7.00},
            {-25.60, 2.58, 0.00},
            {-25.60, 2.58, 7.00}
        }
        ScenariosADeck.destruct()
        ScenariosCDeck.destruct()
        ScenarioDECard.destruct()
        ScenariosEDeck.destruct()
        photoTokensStack.destruct()
        lootTokensStack.destruct()

        for i = 1, 3 do
            ScenariosBDeck.takeObject({
                position = scenarioBCardPositions[i],
                rotation = { 0, 0, 0 }
            })
        end
            
        splitDealItems()

    -- Scenario C 
    elseif scenarioIndex == 3 then
        local scenarioCLootTokenPositions = {
            {-25.02, 2.71, 6.00},
            {-25.02, 2.71, 4.00},
            {-25.02, 2.71, 2.00},
            {-25.02, 2.71, 0.00},
            {-25.02, 2.71, -2.00},
            {-25.02, 2.71, -4.00},
            {-25.02, 2.71, -6.00}
        }
        ScenariosADeck.destruct()
        ScenariosBDeck.destruct()
        ScenarioDECard.destruct()
        ScenariosEDeck.destruct()
        photoTokensStack.destruct()

        activeItemDeck.locked = false
        ScenariosCDeck.locked = false

        -- 7 Loot Tokens
        for i = 1, 6 do
            lootTokensStack.takeObject({
                position = scenarioCLootTokenPositions[i],
                rotation = { 0, 270, 180 }
            })

            -- remainder contains reference to last object from container
            if lootTokensStack.remainder ~= nil then
                lootTokensStack.remainder.setPositionSmooth(scenarioCLootTokenPositions[7], false, false)
                lootTokensStack.remainder.setRotation({ 0, 270, 180 })
            end

            for _ = 1, 20 do
                coroutine.yield(0)
            end
        end

        -- Merge decks
        activeItemDeck.putObject(ScenariosCDeck)
        
        for _ = 1, 100 do
            coroutine.yield(0)
        end
        
        activeItemDeck.shuffle()

        for _ = 1, 60 do
            coroutine.yield(0)
        end

        splitDealItems()

    -- Scenario D
    elseif scenarioIndex == 4 then
        local scenarioDPhotoTokenPositions = {
            {-25.02, 2.71, 5.00},
            {-25.02, 2.71, 3.00},
            {-25.02, 2.71, 1.00},
            {-25.02, 2.71, -1.00},
            {-25.02, 2.71, -3.00},
            {-25.02, 2.71, -5.00},
        }
        ScenariosADeck.destruct()
        ScenariosBDeck.destruct()
        ScenariosCDeck.destruct()
        ScenariosEDeck.destruct()
        lootTokensStack.destruct()

        activeItemDeck.locked = false
        ScenarioDECard.locked = false

        -- 6 Photo Tokens
        for i = 1, 6 do
            photoTokensStack.takeObject({
                position = scenarioDPhotoTokenPositions[i],
                rotation = { 0, 270, 180 }
            })

            -- remainder contains reference to last object from container
            if photoTokensStack.remainder ~= nil then
                photoTokensStack.remainder.setPositionSmooth(scenarioDPhotoTokenPositions[6], false, false)
                photoTokensStack.remainder.setRotation({ 0, 270, 180 })
            end

            for _ = 1, 20 do
                coroutine.yield(0)
            end
        end

        splitDealItems()

        ScenarioDECard.setPosition({36.65, 2.58, -17.00})
        ScenarioDECard.setRotation({0.00, 0.00, 0.00})

    -- Scenario E
    elseif scenarioIndex == 5 then
        local scenarioEPhotoTokenPositions = {
            {-25.02, 2.71, 2.00},
            {-25.02, 2.71, 0.00},
            {-25.02, 2.71, -2.00}
        }

        ScenariosADeck.destruct()
        ScenariosBDeck.destruct()
        ScenariosCDeck.destruct()
        lootTokensStack.destruct()

        activeItemDeck.locked = false
        ScenarioDECard.locked = false
        ScenariosEDeck.locked = false

        ScenariosEDeck.flip()
        for _ = 1, 60 do coroutine.yield(0) end
        ScenariosEDeck.shuffle()

        -- 3 Photo Tokens
        for i = 1, 3 do
            photoTokensStack.takeObject({
                position = scenarioEPhotoTokenPositions[i],
                rotation = { 0, 270, 180 }
            })

            for _ = 1, 20 do coroutine.yield(0) end
        end

        photoTokensStack.destruct()

        -- Move 1 random scenario card facedown near board before merging the rest
        ScenariosEDeck.takeObject({
            position = {-25.56, 2.58, -6.78},
            rotation = {0.00, 0.00, 180.00},
        })

        -- Merge decks
        activeItemDeck.putObject(ScenariosEDeck)
        
        for _ = 1, 100 do coroutine.yield(0) end
        
        activeItemDeck.shuffle()

        for _ = 1, 60 do coroutine.yield(0) end

        splitDealItems()

        ScenarioDECard.setPosition({36.65, 2.58, -17.00})
        ScenarioDECard.setRotation({0.00, 0.00, 0.00})
    end

    return 1
end