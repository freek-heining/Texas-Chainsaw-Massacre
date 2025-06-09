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
end

function StartGame(achievements, currentScenarioIndex)
    SawyerDeckGUID = "0a2ad0"
    SawyerDeckAchievGUID = "4300c2"
    DesperationDeckGUID = "dc7f3e"
    DesperationDeckAchievGUID = "7ba0bc"
    InjuryDeckGUID = "ab13cc"
    InjuryDeckAchievGUID = "f1ac4c"
    SawyerDeck = getObjectFromGUID(SawyerDeckGUID)
    SawyerDeckAchiev = getObjectFromGUID(SawyerDeckAchievGUID)
    DesperationDeck = getObjectFromGUID(DesperationDeckGUID)
    DesperationDeckAchiev = getObjectFromGUID(DesperationDeckAchievGUID)
    InjuryDeck = getObjectFromGUID(InjuryDeckGUID)
    InjuryDeckAchiev = getObjectFromGUID(InjuryDeckAchievGUID)

    broadcastToAll("First determine the Red / Sawyer player before choosing it!")
    UI.setAttribute("setupWindow", "active", false)

    -- #1 Deal Horror Tiles
    startLuaCoroutine(Global, "DealHorrorTilesCoroutine")

    -- #2 Deal Sawyer Cards
    if achievements then
        SawyerDeckAchiev.setPosition({12.16, 2.58, -21.00})
        SawyerDeck.destruct()
    else
        SawyerDeck.setPosition({12.16, 2.58, -21.00})
        SawyerDeckAchiev.destruct()
    end

    -- #3 Deal Sawyer Cards
    if achievements then
        DesperationDeckAchiev.setPosition({32.82, 2.58, 8.41})
        DesperationDeck.destruct()
    else
        DesperationDeck.setPosition({32.82, 2.58, 8.41})
        DesperationDeckAchiev.destruct()
    end    
end