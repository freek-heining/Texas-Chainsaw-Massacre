-- Initial dice objects
local diceObjects = {}

-- Setup Menu
require("Menu")
-- Dice Tray 
require("Dice_Tray")
-- Restrict certain player actions
require("Behavior_Restrictions")

function onLoad()
    UI.setAttribute("setupWindow", "active", false)
    diceObjects = GetDiceFromZone()
end