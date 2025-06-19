-- Setup Menu / UI
require("Menu")
-- Dice Tray UI
require("Dice_Tray_Automation")
-- Restrict certain player actions
require("Behavior_Restrictions")
-- Dealing 4 random Horror Tiles
require("DealHorrorTilesCoroutine")
-- Set all interactables
require("Set_Interactables")
-- Setup Game
require("Setup_Game")
-- Dealing Vehicles
require("DealVehicles")
-- Bury Cards
require("Bury_Cards")
-- Tagging Cards
require("Tagging_Cards")

-- Set to true after setup is done. 
SetupDone = false

function onLoad(state)
    local decodedState = JSON.decode(state)
    if decodedState then
        SetupDone = decodedState.setupDone
    end

    if SetupDone then
        UI.setAttribute("setupWindow", "active", false)
    end

    --UI.setAttribute("setupWindow", "active", false)
    printToAll("- Welcome to The Texas Chainsaw Massacre: Slaughterhouse!", {240/255, 237/255, 220/255})
    printToAll("- Collectively determine the Sawyer / Red player before choosing it!", {240/255, 237/255, 220/255})
    printToAll("- Read the Notebook for some clarifactions and overlooked rules.", {240/255, 237/255, 220/255})
    printToAll("- In this game, there are no winners — there are only survivors.", {240/255, 237/255, 220/255})
    SetInteractableFalse()
    Turns.enable = true
end

-- Save SetupDone so menu screen doesnt show on reload
function onSave()
    local state = {
        setupDone = SetupDone
    }
    return JSON.encode(state)
end