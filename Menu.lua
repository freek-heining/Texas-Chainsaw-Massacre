function ButtonCloseWindowClick()
    UI.setAttribute("setupWindow", "active", false)
end

local scenarioTable = {"Scenario_A", "Scenario_B", "Scenario_C", "Scenario_D", "Scenario_E"}
local currentScenarioIndex = 1
local scenarioBackActive = false

-- Toggles front and back of cards
function ScenarioClick()
    if scenarioBackActive then
        scenarioBackActive = false
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Front")
    else
        scenarioBackActive = true
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Back")
    end
end

-- Cycle scenario cards. scenarioTable is used to set filenames in XML

function ButtonScenarioLeftClick()
    currentScenarioIndex = currentScenarioIndex - 1

    local rightButtonAttributes = {
        tooltip = "Next Scenario",
        textColor="#373737",
        colors="#f0eddc|#fffceb|#dedbcb|#A3A19670",
        interactable = "true"
    }

    -- Re-enable button if disabled
    if UI.getAttribute("buttonScenarioRight", "interactable") == "false" then
        UI.setAttributes("buttonScenarioRight", rightButtonAttributes)
    end

    -- Disable button and tooltip
    if currentScenarioIndex == 1 then
        UI.setAttribute("buttonScenarioLeft", "interactable", "false")
        UI.setAttribute("buttonScenarioLeft", "tooltip", "")
    end

    if scenarioBackActive then
       UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Back")
    else
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Front")
    end
end

function ButtonScenarioRightClick()
    currentScenarioIndex = currentScenarioIndex + 1

    local leftButtonAttributes = {
        tooltip = "Previous Scenario",
        textColor="#373737",
        colors="#f0eddc|#fffceb|#dedbcb|#A3A19670",
        interactable = "true"
    }

    -- Re-enable button if disabled
    if UI.getAttribute("buttonScenarioLeft", "interactable") == "false" then
        UI.setAttributes("buttonScenarioLeft", leftButtonAttributes)
    end

    -- Disable button and tooltip
    if currentScenarioIndex == 5 then
        UI.setAttribute("buttonScenarioRight", "interactable", "false")
        UI.setAttribute("buttonScenarioRight", "tooltip", "")
    end

    if scenarioBackActive then
       UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Back")
    else
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Front")
    end
end

-- Toggle for achievements
local achievements = false
function ToggleAchievementsChanged(player, isOn)
    UI.setAttribute("toggleAchievements", "isOn", isOn)
    achievements = isOn
    log("Achievements" .. " is " .. isOn)
end

-- Start game
function ButtonStartGameClick()
    log("Starting the game with Scenario " .. currentScenarioIndex .. "!")
    SetupGame(achievements, currentScenarioIndex)
end