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

function onLoad()
    --UI.setAttribute("setupWindow", "active", false)
    printToAll("- Welcome to the Texas Chainsaw Massacre: Slaughterhouse!", {240/255, 237/255, 220/255})
    printToAll("- In this game, there are no winners — there are only survivors.", {240/255, 237/255, 220/255})
    printToAll("- Collectively determine the Sawyer / Red player before choosing it!", {240/255, 237/255, 220/255})
    SetInteractableFalse()
    Turns.enable = true
end