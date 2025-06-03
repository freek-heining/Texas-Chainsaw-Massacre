-- Setup Menu
require("Menu")
-- Dice Tray 
require("Dice_Tray")

function onLoad()
    UI.setAttribute("setupWindow", "active", false)
    GetDiceFromZone()
end