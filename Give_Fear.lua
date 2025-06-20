local fearStackGUID = "1acb50"
local greenNoiseScriptingZoneGUID = "4c956c"
local yellowNoiseScriptingZoneGUID = "36c74a"
local greyNoiseScriptingZoneGUID = "7ecbd2"
local blueNoiseScriptingZoneGUID = "cd79c8"

local fearStack
local greenNoiseScriptingZone
local yellowNoiseScriptingZone
local greyNoiseScriptingZone
local blueNoiseScriptingZone

-- We use scripting zones instead of stack object, because the stacks will dissapear during the game
function GiveFear(Player, color)
    fearStack = getObjectFromGUID(fearStackGUID)

    greenNoiseScriptingZone = getObjectFromGUID(greenNoiseScriptingZoneGUID)
    yellowNoiseScriptingZone = getObjectFromGUID(yellowNoiseScriptingZoneGUID)
    greyNoiseScriptingZone = getObjectFromGUID(greyNoiseScriptingZoneGUID)
    blueNoiseScriptingZone = getObjectFromGUID(blueNoiseScriptingZoneGUID)

    -- Fear Stack positions
    local height = 1
    local fearStackPos = fearStack.getPosition()
    local fearStackDiscardPos = {fearStackPos.x, fearStackPos.y + height, fearStackPos.z}

    local trespasserNoiseScriptingZones = {
        ["Green"] = greenNoiseScriptingZone,
        ["Yellow"] = yellowNoiseScriptingZone,
        ["Grey"] = greyNoiseScriptingZone,
        ["Blue"] = blueNoiseScriptingZone
    }


    -- Check amount of tokens in Trespasser Noise zone
    -- If Trespasser zone only has 1 object found, every Noise token is taken. The 1 object remaining is the Custom Token on table
    local counterFear = 0
    for _, _ in ipairs(trespasserNoiseScriptingZones[color].getObjects()) do
        counterFear = counterFear + 1
    end
    if counterFear == 1 then
        broadcastToAll("No Fear left!", color)
    end

    -- Otherwise we discard all
    while counterFear > 1 do
        for _, object in ipairs(trespasserNoiseScriptingZones[color].getObjects()) do
            if object.name == "Custom_Tile_Stack" then
                counterFear = object.getQuantity()
                object.takeObject({
                    position = fearStackDiscardPos,
                    rotation = {0.00, 180.00, 180.00},
                    smooth = true
                })
            elseif object.name == "Custom_Tile" then
                counterFear = 1
                object.setPositionSmooth(fearStackDiscardPos, false, false)
                object.setRotation({0.00, 180.0, 180.00}, false, true)
            end
        end
    end
end