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
-- Getting Noise
require("Get_Noise")
-- Removing Noise
require("Remove_Noise")
-- Give Fear
require("Give_Fear")
-- Remove Fear
require("Remove_Fear")
-- Take Fear
require("Take_Fear")
-- Locking Boards
require("Locking_Boards")
-- XML Refreshing
require("setXml")

-- Set to true in DealVehicles.lua (after whole setup is done) 
SetupDone = false

function onLoad(state)
    local decodedState = JSON.decode(state)

    -- Retrieve value from loading state
    if decodedState then
        SetupDone = decodedState.setupDone
    end

    log("SetupDone = " .. tostring(SetupDone))
    
    -- Restores achievements and Item Decks 1 & 2 on (re)load
    if SetupDone then
        ItemDeck1 = getObjectFromGUID(decodedState.guids.item1Deck)
        ItemDeck2 = getObjectFromGUID(decodedState.guids.item2Deck)
        
        AchievementsUsed = decodedState.achievementsUsed
    end

    printToAll("- Welcome to The Texas Chainsaw Massacre: Slaughterhouse!", {240/255, 237/255, 220/255})
    printToAll("- Collectively determine the Sawyer / Red player before choosing it!", {240/255, 237/255, 220/255})
    printToAll("- Read the Notebook for some clarifactions and overlooked rules.", {240/255, 237/255, 220/255})
    printToAll("- In this game, there are no winners — there are only survivors.", {240/255, 237/255, 220/255})
    
    SetInteractableFalse()
    
    Turns.enable = true

    -- Only run when setup is not done
    -- Load UI xml after slight delay. It was buggy otherwise. Hope this will fix it for all clients...
    if not SetupDone then
        Wait.time(function() SetXmlTable() end, 1)
    end
end

-- Save SetupDone, achievements and Item Decks 1 & 2, ONLY when setup is compeltely finished
function onSave()
    if SetupDone then
        local state = {
            setupDone = SetupDone,
            achievementsUsed = AchievementsUsed,
            guids = {
                item1Deck = ItemDeck1.guid,
                item2Deck = ItemDeck2.guid
            }
        }

        return JSON.encode(state)
    end
end