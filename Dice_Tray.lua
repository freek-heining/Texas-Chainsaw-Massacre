-- Get all dice objects in tray
function GetDiceFromZone()
    local DiceTrayZoneGuid = "89711c"
    local DiceTrayZoneObject = getObjectFromGUID(DiceTrayZoneGuid)
    local diceStartPositions = {
        Vector(-34.00, 3.21, 3.50),
        Vector(-34.00, 3.22, 0.00),
        Vector(-34.00, 3.24, -3.50)
    }
    local diceObjects = {}

    for _, object in pairs(DiceTrayZoneObject.getObjects()) do
        if object.getName() == "Bone Die" then
            table.insert(diceObjects, object)
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
    else
        return diceObjects
    end
end

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
function RollDice(player, amount)
    local randomUniqueNumbers = {}
    local tableSize = 0

    -- Disable buttons for 10 seconds to prevent spam
    local object = getObjectFromGUID("7cd743")
    object.UI.setAttribute("ButtonRollOneLeft", "interactable", false)
    object.UI.setAttribute("ButtonRollTwoLeft", "interactable", false)
    object.UI.setAttribute("ButtonRollThreeLeft", "interactable", false)
    object.UI.setAttribute("ButtonRollOneRight", "interactable", false)
    object.UI.setAttribute("ButtonRollTwoRight", "interactable", false)
    object.UI.setAttribute("ButtonRollThreeRight", "interactable", false)
    Wait.time(
        function()
            object.UI.setAttribute("ButtonRollOneLeft", "interactable", true)
            object.UI.setAttribute("ButtonRollTwoLeft", "interactable", true)
            object.UI.setAttribute("ButtonRollThreeLeft", "interactable", true)
            object.UI.setAttribute("ButtonRollOneRight", "interactable", true)
            object.UI.setAttribute("ButtonRollTwoRight", "interactable", true)
            object.UI.setAttribute("ButtonRollThreeRight", "interactable", true)
        end,
        5
    )

    -- Create random unique numbers for rolling
    while tableSize < tonumber(amount) do
        local number = math.random(3)

        local function checkTableContains()
            for _, numberEntry in pairs(randomUniqueNumbers) do
                if number == numberEntry then
                    return true
                end
            end
        end

        if not checkTableContains() then
            table.insert(randomUniqueNumbers, number)
            tableSize = tableSize + 1
        end
    end

    local diceObjects = GetDiceFromZone()

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
            log(numberOfSuccesses)

            
            object.UI.setAttribute("TextSuccessesLeft", "text", numberOfSuccesses)
            object.UI.setAttribute("TextSuccessesRight", "text", numberOfSuccesses)
        end,
        3
    )
end