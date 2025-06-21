local fearStackGUID = "1acb50"
local fearStack
local fearStackDiscardPos
local fearStackRot

local noiseScriptingZoneGUID = "4cced7"
local noiseScriptingZone

-- We use scripting zones instead of stack object, because the stacks will dissapear during the game
function TakeFear()
    fearStack = getObjectFromGUID(fearStackGUID)
    noiseScriptingZone = getObjectFromGUID(noiseScriptingZoneGUID)

    -- Fear Stack positions
    local height = 0.2
    local fearStackPos = fearStack.getPosition()
    fearStackRot = {0, 180, 180}
    fearStackDiscardPos = {fearStackPos.x, fearStackPos.y + height, fearStackPos.z}

    -- Check amount of tokens in zone
    -- If zone only has 1 object found, every Noise/Fear token is taken. The 1 object remaining is the Custom Token on table.
    local counterNoise = 0
    for _, _ in ipairs(noiseScriptingZone.getObjects()) do
        counterNoise = counterNoise + 1
    end
    if counterNoise <= 1 then
        broadcastToAll("No Fear left!", "Red")
    else
        -- Otherwise we draw. Break is important for animation smooth, so it doesn't return multiple moving tokens
        for _, object in ipairs(noiseScriptingZone.getObjects()) do
            if object.name == "Custom_Tile_Stack" then
                object.takeObject({
                    position = fearStackDiscardPos,
                    rotation = fearStackRot,
                    smooth = true
                })
                break
            elseif object.name == "Custom_Tile" then
                object.setPositionSmooth(fearStackDiscardPos, false, false)
                object.setRotation(fearStackRot)
                break
            end
        end
    end
end