-- Prevent rolling dice and shuffling decks with 'R'
-- Exception for Sawyer deck!
local randomizeTriggered -- Prevents message spam
local shuffleTriggered -- Prevents message spam
function onPlayerAction(player, action, targets)
    local randomizedObject = targets[1]

    if action == Player.Action.Randomize and randomizedObject.type == "Dice" and not randomizeTriggered then
        broadcastToAll("Please use the buttons only for rolling dice!", white)
        randomizeTriggered = true
        Wait.time(function() randomizeTriggered = false end, 2)
    elseif action == Player.Action.Randomize and randomizedObject.type == "Deck" and not shuffleTriggered then
        broadcastToAll("Decks are never shuffled, only bury cards!", white)
        shuffleTriggered = true
        Wait.time(function() shuffleTriggered = false end, 2)
    end

    if action == Player.Action.Randomize and randomizedObject.type == "Dice" then
        return false
    end

    if action == Player.Action.Randomize and randomizedObject.type == "Deck" then
        return false
    end

    return true
end