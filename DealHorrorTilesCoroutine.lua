-- Get all 8 tiles and deal 4 random to Sawyer player
function DealHorrorTilesCoroutine()
    local horrorTileContainerGUID = "dc8f40"
    local horrorTileContainer = getObjectFromGUID(horrorTileContainerGUID)
    local horrorTilePositions = {
        [1] = {-29.00, 2.72, -15.00},
        [2] = {-29.00, 2.72, -17.68},
        [3] = {-29.00, 2.72, -20.32},
        [4] = {-29.00, 2.72, -23.00}
    }

    horrorTileContainer.shuffle()

    for i = 1, 4 do
        horrorTileContainer.takeObject({
            position = horrorTilePositions[i],
            rotation = { 0, 180, 180 },
            callback_function = function(spawnedObject)
                Wait.frames(function()
                    spawnedObject.flip()
                end)
            end
        })

        for _ = 1, 20 do
            coroutine.yield(0)
        end
    end

    return 1
end
