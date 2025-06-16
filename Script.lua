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
    broadcastToAll("- Collectively determine the Sawyer / Red player before choosing it!")
    SetInteractableFalse()
    Turns.enable = true
end