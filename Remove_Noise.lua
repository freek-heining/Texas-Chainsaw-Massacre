local noiseStackGUID = "17fc64"
local greenNoiseScriptingZoneGUID = "4c956c"
local yellowNoiseScriptingZoneGUID = "36c74a"
local greyNoiseScriptingZoneGUID = "7ecbd2"
local blueNoiseScriptingZoneGUID = "cd79c8"

local noiseStack
local greenNoiseScriptingZone
local yellowNoiseScriptingZone
local greyNoiseScriptingZone
local blueNoiseScriptingZone

-- We use scripting zones instead of stack object, because the stacks will dissapear during the game
function RemoveNoise(Player, color)
    noiseStack = getObjectFromGUID(noiseStackGUID)

    greenNoiseScriptingZone = getObjectFromGUID(greenNoiseScriptingZoneGUID)
    yellowNoiseScriptingZone = getObjectFromGUID(yellowNoiseScriptingZoneGUID)
    greyNoiseScriptingZone = getObjectFromGUID(greyNoiseScriptingZoneGUID)
    blueNoiseScriptingZone = getObjectFromGUID(blueNoiseScriptingZoneGUID)

    -- Noise Stack positions
    local height = 1
    local noiseStackPos = noiseStack.getPosition()
    local noiseStackDiscardPos = {noiseStackPos.x, noiseStackPos.y + height, noiseStackPos.z}

    local trespasserNoiseScriptingZones = {
        ["Green"] = greenNoiseScriptingZone,
        ["Yellow"] = yellowNoiseScriptingZone,
        ["Grey"] = greyNoiseScriptingZone,
        ["Blue"] = blueNoiseScriptingZone
    }

    -- Check amount of tokens in Trespasser Noise zone
    -- If Trespasser zone only has 1 object found, every Noise token is taken. The 1 object remaining is the Custom Token on table
    local counterNoise = 0
    for _, _ in ipairs(trespasserNoiseScriptingZones[color].getObjects()) do
        counterNoise = counterNoise + 1
    end
    if counterNoise == 1 then
        broadcastToAll("No Noise left!", color)
    end

    -- Otherwise we discard. Break is important for animation smooth, so it doesn't return multiple moving tokens
    for _, object in ipairs(trespasserNoiseScriptingZones[color].getObjects()) do
        if object.name == "Custom_Tile_Stack" then
            object.takeObject({
                position = noiseStackDiscardPos,
                smooth = true
            })
            break
        elseif object.name == "Custom_Tile" then
            object.setPositionSmooth(noiseStackDiscardPos, false, false)
            break
        end
    end
end