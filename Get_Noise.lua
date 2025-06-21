local greenNoiseStackGUID = "fc500f"
local yellowNoiseStackGUID = "ba6091"
local greyNoiseStackGUID = "576cf1"
local blueNoiseStackGUID = "3a208f"
local greenNoiseStack
local yellowNoiseStack
local greyNoiseStack
local blueNoiseStack

local noiseScriptingZoneGUID = "4cced7"
local noiseScriptingZone

-- We use scripting zones instead of stack object, because the stacks will dissapear during the game
function GetNoise(Player, color)
    greenNoiseStack = getObjectFromGUID(greenNoiseStackGUID)
    yellowNoiseStack = getObjectFromGUID(yellowNoiseStackGUID)
    greyNoiseStack = getObjectFromGUID(greyNoiseStackGUID)
    blueNoiseStack = getObjectFromGUID(blueNoiseStackGUID)

    noiseScriptingZone = getObjectFromGUID(noiseScriptingZoneGUID)

    -- Trespasser Noise Stack positions
    local height = 0.2
    local greenNoiseStackPos = greenNoiseStack.getPosition()
    local greenNoiseStackDealPos = {greenNoiseStackPos.x, greenNoiseStackPos.y + height, greenNoiseStackPos.z}
    local yellowNoiseStackPos = yellowNoiseStack.getPosition()
    local yellowNoiseStackDealPos = {yellowNoiseStackPos.x, yellowNoiseStackPos.y + height, yellowNoiseStackPos.z}
    local greyNoiseStackPos = greyNoiseStack.getPosition()
    local greyNoiseStackDealPos = {greyNoiseStackPos.x, greyNoiseStackPos.y + height, greyNoiseStackPos.z}
    local blueNoiseStackPos = blueNoiseStack.getPosition()
    local blueNoiseStackDealPos = {blueNoiseStackPos.x, blueNoiseStackPos.y + height, blueNoiseStackPos.z}

    -- Trespasser Noise Stack deal positions = extra y-height. String keys are for function parameter dealNoiseToPlayer(colorClicked)
    local noiseStackDealPositions = {
        ["Green"] = greenNoiseStackDealPos,
        ["Yellow"] = yellowNoiseStackDealPos,
        ["Grey"] = greyNoiseStackDealPos,
        ["Blue"] = blueNoiseStackDealPos
    }

    -- Check amount of tokens in zone
    -- If zone only has 1 object found, every Noise token is taken. The 1 object remaining is the Custom Token on table.
    local counterNoise = 0
    for _, _ in ipairs(noiseScriptingZone.getObjects()) do
        counterNoise = counterNoise + 1
    end
    if counterNoise <= 1 then
        broadcastToAll("No Noise left!", "Red")
    else
        -- Otherwise we draw. Break is important for animation smooth, so it doesn't return multiple moving tokens
        for _, object in ipairs(noiseScriptingZone.getObjects()) do
            if object.name == "Custom_Tile_Stack" then
                object.takeObject({
                    position = noiseStackDealPositions[color],
                    smooth = true
                })
                break
            elseif object.name == "Custom_Tile" then
                object.setPositionSmooth(noiseStackDealPositions[color], false, false)
                break
            end
        end
    end
end