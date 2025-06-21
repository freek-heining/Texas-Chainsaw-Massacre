local noiseStackGUID = "17fc64"
local fearScriptingZoneGUID = "857de3"

local noiseStack
local fearScriptingZone

-- We use scripting zones instead of stack object, because the stacks will dissapear during the game
function RemoveFear()
    noiseStack = getObjectFromGUID(noiseStackGUID)
    fearScriptingZone = getObjectFromGUID(fearScriptingZoneGUID)

    -- Noise Stack positions
    local height = 0.2
    local noiseStackPos = noiseStack.getPosition()
    local noiseStackRot = {0, 0, 0}
    local noiseStackDiscardPos = {noiseStackPos.x, noiseStackPos.y + height, noiseStackPos.z}

    -- Check amount of tokens in Fear zone
    -- If Fear zone only has 1 object found, all Fear is removed. The 1 object remaining is the Custom Token on table
    local counterFear = 0
    for _, _ in ipairs(fearScriptingZone.getObjects()) do
        counterFear = counterFear + 1
    end
    if counterFear <= 1 then
        broadcastToAll("No Fear left!", "Red")
    else
        -- Otherwise we discard. Break is important for animation smooth, so it doesn't return multiple moving tokens
        for _, object in ipairs(fearScriptingZone.getObjects()) do
            if object.name == "Custom_Tile_Stack" then
                object.takeObject({
                    position = noiseStackDiscardPos,
                    rotation = noiseStackRot,
                    smooth = true
                })
                break
            elseif object.name == "Custom_Tile" then
                object.setPositionSmooth(noiseStackDiscardPos, false, false)
                object.setRotation(noiseStackRot)
                break
            end
        end
    end
end