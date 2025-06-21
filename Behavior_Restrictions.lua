-- Prevent spam rolling dice and shuffling decks with 'R'

local randomizeTriggered -- Prevents message spam
local shuffleTriggered -- Prevents message spam
local activeDiceGuids = {} -- All manually activated dice

local function checkGuidInTable(dieGuid)
    for _, guid in ipairs(activeDiceGuids) do
        if dieGuid == guid then
            return true
        end
    end
    return false
end

-- Allow rolling any die every 3 seconds. Just rolled dice are held in table for 3 seconds.
function onPlayerAction(player, action, targets) -- returning false blocks action/behavior
    local randomizedObject = targets[1]

    -- Die already in table
    if (action == Player.Action.Randomize) and (randomizedObject.type == "Dice") and (checkGuidInTable(randomizedObject.guid)) and not (randomizeTriggered) then
        
        broadcastToAll("Please roll only once!")
        randomizeTriggered = true
        Wait.time(function() randomizeTriggered = false end, 2)
    
        return false
    
    -- Message already broadcasted
    elseif (action == Player.Action.Randomize) and (randomizedObject.type == "Dice") and (checkGuidInTable(randomizedObject.guid)) then
        return false

    -- Die not in table yet, we insert it for 3 seconds
    elseif (action == Player.Action.Randomize) and (randomizedObject.type == "Dice") then
        table.insert(activeDiceGuids, randomizedObject.guid)
        Wait.time(function() table.remove(activeDiceGuids, 1) end, 3)

        -- return stops executing the rest of code in onPlayerAction()
        return true
    end
    
    -- Preven shuffling of all decks
    if (action == Player.Action.Randomize) and (randomizedObject.type == "Deck") and not (shuffleTriggered) then
        broadcastToAll("Decks are never shuffled, only BURY cards!")
        shuffleTriggered = true
        Wait.time(function() shuffleTriggered = false end, 2)
        return false
    elseif (action == Player.Action.Randomize) and (randomizedObject.type == "Deck") then
        return false
    end

    -- All other player actions are valid
    return true
end