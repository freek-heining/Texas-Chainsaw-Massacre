-- Setup Menu
require("Menu")
-- Dice Tray 
require("Dice_Tray")
-- Restrict certain player actions
require("Behavior_Restrictions")
-- Dealing 4 random Horror Tiles
require("Horror_Tiles")

function onLoad()
    UI.setAttribute("setupWindow", "active", false)
    --startLuaCoroutine(Global, "DealHorrorTilesCoroutine")
end