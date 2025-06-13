function DealVehicles()
    local vehicleDeckGUID = "83a551"
    local vehicleDeck = getObjectFromGUID(vehicleDeckGUID)

    -- Position/Rotation
    local freeVehicleLocations = {
        [1] = {{-18.91, 2.73, 10.53}, {0.00, 270.00, 180.00}},
        [2] = {{-0.67, 2.73, 7.99}, {0.00, 270.00, 180.00}},
        [3] = {{-0.22, 2.73, -4.78}, {0.00, 310.47, 180.00}},
        [4] = {{-2.36, 2.73, -7.35}, {0.00, 310.47, 180.00}},
        [5] = {{-12.35, 2.73, -10.46}, {0.00, 270.00, 180.00}}
    }

    -- Move 5 vehicle cards to board. Error when deck is not 5 cards!
    if not (vehicleDeck.getQuantity() == 5) then
        broadcastToAll("ERROR: Vehicle deck size should be 5!", "Red")
        Player[Turns.turn_color].pingTable({42.25, 2.63, 12.88})
    else
        for i = 1, 5 do
            vehicleDeck.takeObject({
                position = freeVehicleLocations[i][1],
                rotation = freeVehicleLocations[i][2]
            })
        end
    end
end