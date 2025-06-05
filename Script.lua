-- Initial dice objects
local diceObjects = {}

-- Setup Menu
require("Menu")
-- Dice Tray 
require("Dice_Tray")

function onLoad()
    UI.setAttribute("setupWindow", "active", false)
    diceObjects = GetDiceFromZone()
end

-- Prevent shuffling decks with 'R'

function tryObjectRandomize(object, player_color)
    if object.type == "Deck" and not shuffleTriggered then
        broadcastToAll("Decks are never shuffled, only bury cards!", white)
        shuffleTriggered = true
        Wait.time(function() shuffleTriggered = false end, 2)
    end

    if object.type == "Deck" then
        return false
    end

    return true
end

-- Prevent rolling dice and shuffling decks with 'R'
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