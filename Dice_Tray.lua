-- Get all dice objects in tray
local function getDiceFromZone()
    local DiceTrayZoneGuid = "89711c"
    local DiceTrayZoneObject = getObjectFromGUID(DiceTrayZoneGuid)
    local diceStartPositions = {
        Vector(-34.00, 3.21, 3.50),
        Vector(-34.00, 3.22, 0.00),
        Vector(-34.00, 3.24, -3.50)
    }
    local diceObjects = {}
    local diceObjectCount = 0

    for _, object in pairs(DiceTrayZoneObject.getObjects()) do
        if object.getName() == "Bone Die" then
            table.insert(diceObjects, object)
            diceObjectCount = diceObjectCount + 1
        end
    end

    -- Reset to random x dice positions to keep them from going over the edge
    for i, die in ipairs(diceObjects) do
        local randomXFloat = math.random() + math.random(-3, 2)
        local vecRandom = Vector(randomXFloat, 0, 0)
        die.setPosition(diceStartPositions[i]:add(vecRandom))
    end

    if next(diceObjects) == nil then
        error("No dice found in tray!")
    elseif diceObjectCount < 3 then
        error("Less then 3 dice in tray, put them back!")
    else
        return diceObjects
    end
end

-- Translate normal D6 to a Bone Die
local function interpretDieValue(value)
    if value == 1 then
        return 1
    elseif value == 2 then
        return 1
    elseif value == 3 then
        return 0
    elseif value == 4 then
        return 0
    elseif value == 5 then
        return 0
    elseif value == 6 then
        return 2
    end
end

-- Roll 1-3 dice in random order
function RollDice(player, amount, id)
    local randomUniqueNumbers = {}
    local tableSize = 0

    -- amount is value 1-3 from button
    if amount == 1 then
        broadcastToAll(player.color .. " player rolls 1 die...", player.color)
    else
        broadcastToAll(player.color .. " player rolls " .. amount .. " dice...", player.color)
    end

    -- Disable buttons for 5 seconds to prevent spam
    local boardObject = getObjectFromGUID("7cd743")
    boardObject.UI.setAttribute("ButtonRollOneLeft", "interactable", false)
    boardObject.UI.setAttribute("ButtonRollTwoLeft", "interactable", false)
    boardObject.UI.setAttribute("ButtonRollThreeLeft", "interactable", false)
    boardObject.UI.setAttribute("ButtonRollOneRight", "interactable", false)
    boardObject.UI.setAttribute("ButtonRollTwoRight", "interactable", false)
    boardObject.UI.setAttribute("ButtonRollThreeRight", "interactable", false)
    
    Wait.time(
        function()
            boardObject.UI.setAttribute("ButtonRollOneLeft", "interactable", true)
            boardObject.UI.setAttribute("ButtonRollTwoLeft", "interactable", true)
            boardObject.UI.setAttribute("ButtonRollThreeLeft", "interactable", true)
            boardObject.UI.setAttribute("ButtonRollOneRight", "interactable", true)
            boardObject.UI.setAttribute("ButtonRollTwoRight", "interactable", true)
            boardObject.UI.setAttribute("ButtonRollThreeRight", "interactable", true)
        end,
        5
    )

    -- Change button color to pushing player's color
    boardObject.UI.setAttribute("TextSuccessesLeft", "color", "#f0eddc")
    boardObject.UI.setAttribute("TextSuccessesRight", "color", "#f0eddc")


    -- Create random unique numbers for rolling, equal amount to amount of button
    while tableSize < tonumber(amount) do
        local number = math.random(3)

        local function checkTableContains()
            for _, numberEntry in pairs(randomUniqueNumbers) do
                if number == numberEntry then
                    return true
                end
            end
        end

        -- Insert in table if not already present
        if not checkTableContains() then
            table.insert(randomUniqueNumbers, number)
            tableSize = tableSize + 1
        end
    end

    local diceObjects = getDiceFromZone()

    -- Only roll the randomly selected numbers dice
    for _, number in pairs(randomUniqueNumbers) do
        diceObjects[number].roll()
    end

    -- get values of rolled dice after some time
    Wait.time(
        function()
            local numberOfSuccesses = 0
            for _, number in pairs(randomUniqueNumbers) do
                numberOfSuccesses = numberOfSuccesses + interpretDieValue(diceObjects[number].getValue())
            end

            if numberOfSuccesses == 0 then
                broadcastToAll("Scoring 0 success...", player.color)
            elseif numberOfSuccesses == 1 then 
                broadcastToAll("Scoring 1 success!", player.color)
            else
                broadcastToAll("Scoring " .. numberOfSuccesses .. " successes!", player.color)
            end
            
            -- Change text color to pushing player's color
            boardObject.UI.setAttribute("TextSuccessesLeft", "color", player.color)
            boardObject.UI.setAttribute("TextSuccessesRight", "color", player.color)   

            boardObject.UI.setAttribute("TextSuccessesLeft", "text", numberOfSuccesses)
            boardObject.UI.setAttribute("TextSuccessesRight", "text", numberOfSuccesses)
        end,
        3
    )
end

-- Prevent dice change with num keys (cheating)
local numberTriggered -- Prevents message spam
function onObjectNumberTyped(object, player_color, number)
    if not numberTriggered and object.type == "Dice" then
        broadcastToAll(player_color .. " typed '" .. number .. "' whilst hovering over a die. Please use the buttons only...", player_color)
        numberTriggered = true
        Wait.time(function() numberTriggered = false end, 2)
    end

    if object.type == "Dice" then
        return true
    end

    return false
end