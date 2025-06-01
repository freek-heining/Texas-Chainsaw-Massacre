function ButtonCloseWindowClick()
    UI.setAttribute("setupWindow", "active", false)
end

local scenarioTable = { "Scenario_A", "Scenario_B", "Scenario_C", "Scenario_D", "Scenario_E" }
local currentScenarioIndex = 1
local scenarioBackActive = false

-- Toggles front and back of cards
function ButtonScenarioClick()
    if scenarioBackActive then
        scenarioBackActive = false
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Front" )
    else
        scenarioBackActive = true
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Back" )
    end
end

-- Cycle scenario cards. Table is used to set filenames in XML
function ButtonScenarioLeftClick()
    currentScenarioIndex = currentScenarioIndex - 1
    UI.setAttribute("buttonScenarioRight", "interactable", "true" )

    if currentScenarioIndex == 1 then
        UI.setAttribute("buttonScenarioLeft", "interactable", "false" )
    end

    if scenarioBackActive then
       UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Back" )
    else
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Front" )
    end
end

function ButtonScenarioRightClick()
    currentScenarioIndex = currentScenarioIndex + 1
    UI.setAttribute("buttonScenarioLeft", "interactable", "true" )

    if currentScenarioIndex == 5 then
        UI.setAttribute("buttonScenarioRight", "interactable", "false" )
    end

    if scenarioBackActive then
       UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Back" )
    else
        UI.setAttribute("scenario_Carousel", "image", scenarioTable[currentScenarioIndex] .. "_Front" )
    end
end

local achievements = false

function ToggleAchievementsChanged(player, isOn)
    UI.setAttribute("toggleAchievements", "isOn", isOn)
    if isOn then
        achievements = true
    end
end