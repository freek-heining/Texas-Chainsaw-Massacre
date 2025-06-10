-- Setup Menu
require("Menu")
-- Dice Tray 
require("Dice_Tray")
-- Restrict certain player actions
require("Behavior_Restrictions")
-- Dealing 4 random Horror Tiles
require("Horror_Tiles")
-- Set all interactables
require("Set_Interactables")
-- Setup Game
require("Setup_Game")

function onLoad()
    UI.setAttribute("setupWindow", "active", false)
    broadcastToAll("First determine the Red / Sawyer player before choosing it!")
    SetInteractableFalse()
end