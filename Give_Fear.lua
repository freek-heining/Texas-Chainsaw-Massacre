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

local colorClicked
local fearStackDiscardPos
local fearStackRot
local trespasserNoiseScriptingZones
local counterFear = 0

-- We use scripting zones instead of stack object, because the stacks will dissapear during the game
function GiveFear(Player, color)
    fearStack = getObjectFromGUID(fearStackGUID)

    greenNoiseScriptingZone = getObjectFromGUID(greenNoiseScriptingZoneGUID)
    yellowNoiseScriptingZone = getObjectFromGUID(yellowNoiseScriptingZoneGUID)
    greyNoiseScriptingZone = getObjectFromGUID(greyNoiseScriptingZoneGUID)
    blueNoiseScriptingZone = getObjectFromGUID(blueNoiseScriptingZoneGUID)

    colorClicked = color

    -- Fear Stack positions
    local height = 0.2
    local fearStackPos = fearStack.getPosition()
    fearStackRot = {0, 180, 180}
    fearStackDiscardPos = {fearStackPos.x, fearStackPos.y + height, fearStackPos.z}

    trespasserNoiseScriptingZones = {
        ["Green"] = greenNoiseScriptingZone,
        ["Yellow"] = yellowNoiseScriptingZone,
        ["Grey"] = greyNoiseScriptingZone,
        ["Blue"] = blueNoiseScriptingZone
    }

    -- Check amount of tokens in Trespasser Noise zone. Start giving if at least 1 Fear found
    -- If Trespasser zone only has 1 object found, no Noise left. The 1 object remaining is the Custom Token on table (counterFear = 1)
    counterFear = 0
    for _, _ in ipairs(trespasserNoiseScriptingZones[color].getObjects()) do
        counterFear = counterFear + 1
    end
    if counterFear <= 1 then
        broadcastToAll("No Fear left!", color)
    else
        for _, object in ipairs(trespasserNoiseScriptingZones[color].getObjects()) do
            if object.name == "Custom_Tile_Stack" then
                -- Returns -1 if no Bag/Deck/Stack
                counterFear = object.getQuantity()
                broadcastToAll(color .. " generates " .. counterFear .." Fear for the Sawyers!", color)
                startLuaCoroutine(Global, "GiveFearCoroutine")
                break
            elseif object.name == "Custom_Tile" then
                counterFear = 1
                broadcastToAll(color .. " generates " .. counterFear .." Fear for the Sawyers!", color)
                startLuaCoroutine(Global, "GiveFearCoroutine")
                break
            end
        end
    end
end

function GiveFearCoroutine()
    while counterFear > 0 do
        -- First object found is the Custom Token on table
        for _, object in ipairs(trespasserNoiseScriptingZones[colorClicked].getObjects()) do
            if object.name == "Custom_Tile_Stack" then
                object.takeObject({
                    position = fearStackDiscardPos,
                    rotation = fearStackRot,
                    smooth = true
                })
                
                counterFear = counterFear - 1
                
                -- Wait is needed or the last token is not seen in loop
                for _ = 1, 5 do coroutine.yield(0) end
            elseif object.name == "Custom_Tile" then
                object.setPositionSmooth(fearStackDiscardPos, false, false)
                object.setRotation(fearStackRot)

                -- Stop loop
                counterFear = 0
            end
        end
    end

    return 1
end