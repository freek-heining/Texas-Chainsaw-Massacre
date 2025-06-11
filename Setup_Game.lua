local scenarioIndex = 0

function SetupGame(achievements, chosenScenarioIndex)
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

    scenarioIndex = chosenScenarioIndex

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
        if object.type == "Tile" and object.getName() ~=  scenarioNames[chosenScenarioIndex] then
            object.destruct()
        elseif object.type == "Tile" then
            object.locked = false
            Wait.time(function() object.locked = true end, 1)
        end
    end

    -- #7: Set Item Cards
    if achievements then
        ActiveItemDeck = itemDeckAchiev
        itemDeck.destruct()
    else
        ActiveItemDeck = itemDeck
        itemDeckAchiev.destruct()
    end

    -- #8: Set Scenario Cards
    startLuaCoroutine(Global, "SetupItemsCoroutine")

end

function SetupItemsCoroutine()
    local function splitDealItems()
        -- split() returns a table
        local splitItemDecksTable = ActiveItemDeck.split(2)
        splitItemDecksTable[1].setPosition({5.73, 2.58, 4.95})
        splitItemDecksTable[1].setRotation({0.00, 0.00, 180.00})
        splitItemDecksTable[2].setPosition({24.70, 2.58, 5.07})
        splitItemDecksTable[2].setRotation({0.00, 0.00, 180.00})

        for _ = 1, 30 do
            coroutine.yield(0)
        end

        splitItemDecksTable[1].locked = true
        splitItemDecksTable[2].locked = true
    end

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


    -- ActiveItemDeck = global that holds itemDeck or itemDeckAchiev
    -- Scenario A
    if scenarioIndex == 1 then
        ScenariosBDeck.destruct()
        ScenariosCDeck.destruct()
        ScenarioDECard.destruct()
        ScenariosEDeck.destruct()
        photoTokensStack.destruct()
        lootTokensStack.destruct()

        ActiveItemDeck.locked = false
        ScenariosADeck.locked = false

        -- Merge decks
        ActiveItemDeck.putObject(ScenariosADeck)
        
        for _ = 1, 100 do
            coroutine.yield(0)
        end
        
        ActiveItemDeck.shuffle()

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

        ActiveItemDeck.locked = false
        ScenariosCDeck.locked = false

        -- 7 Loot Tokens
        for i = 1, 6 do
            lootTokensStack.takeObject({
                position = scenarioCLootTokenPositions[i],
                rotation = { 0, 270, 180 }
            })

            -- remainder contains reference to last object from container
            if lootTokensStack.remainder ~= nil then
                log(lootTokensStack.remainder)
                lootTokensStack.remainder.setPositionSmooth(scenarioCLootTokenPositions[7], false, false)
                lootTokensStack.remainder.setRotation({ 0, 270, 180 })
            end

            for _ = 1, 20 do
                coroutine.yield(0)
            end
        end

        -- Merge decks
        ActiveItemDeck.putObject(ScenariosCDeck)
        
        for _ = 1, 100 do
            coroutine.yield(0)
        end
        
        ActiveItemDeck.shuffle()

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

        ActiveItemDeck.locked = false
        ScenarioDECard.locked = false

        -- 6 Photo Tokens
        for i = 1, 6 do
            photoTokensStack.takeObject({
                position = scenarioDPhotoTokenPositions[i],
                rotation = { 0, 270, 180 }
            })

            -- remainder contains reference to last object from container
            if photoTokensStack.remainder ~= nil then
                log(photoTokensStack.remainder)
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

        ActiveItemDeck.locked = false
        ScenarioDECard.locked = false
        ScenariosEDeck.locked = false

        -- 3 Photo Tokens
        for i = 1, 3 do
            photoTokensStack.takeObject({
                position = scenarioEPhotoTokenPositions[i],
                rotation = { 0, 270, 180 }
            })

            for _ = 1, 20 do
                coroutine.yield(0)
            end
        end

        -- Merge decks
        ActiveItemDeck.putObject(ScenariosEDeck)
        
        for _ = 1, 100 do
            coroutine.yield(0)
        end
        
        ActiveItemDeck.shuffle()

        for _ = 1, 60 do
            coroutine.yield(0)
        end

        splitDealItems()

        ScenarioDECard.setPosition({36.65, 2.58, -17.00})
        ScenarioDECard.setRotation({0.00, 0.00, 0.00})
    end

    return 1
end