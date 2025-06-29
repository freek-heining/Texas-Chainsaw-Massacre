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
        Player[Turns.turn_color].pingTable(vehicleDeck.getPosition())
    else
        for i = 1, 5 do
            vehicleDeck.takeObject({
                position = freeVehicleLocations[i][1],
                rotation = freeVehicleLocations[i][2],
                smooth = false
            })
        end
    end

    -- End of setup reached
    SetupDone = true
    log("SetupDone = " .. tostring(SetupDone))
end

function DealVehiclesScenarioC()
    local vehicleDeckGUID = "83a551"
    local vehicleDeck = getObjectFromGUID(vehicleDeckGUID)

    local vehicleScriptingZone1GUID = "f67c75"
    local vehicleScriptingZone2GUID = "070c51"
    local vehicleScriptingZone3GUID = "ad9118"
    local vehicleScriptingZone4GUID = "fbf093"
    local vehicleScriptingZone5GUID = "a28a11"
    local vehicleScriptingZone1 = getObjectFromGUID(vehicleScriptingZone1GUID)
    local vehicleScriptingZone2 = getObjectFromGUID(vehicleScriptingZone2GUID)
    local vehicleScriptingZone3 = getObjectFromGUID(vehicleScriptingZone3GUID)
    local vehicleScriptingZone4 = getObjectFromGUID(vehicleScriptingZone4GUID)
    local vehicleScriptingZone5 = getObjectFromGUID(vehicleScriptingZone5GUID)

    local blueTruckPosition = {28.41, 2.58, -8.45}

    -- Position/Rotation
    local freeVehicleLocations = {
        [1] = {{-18.91, 2.73, 10.53}, {0.00, 270.00, 180.00}},
        [2] = {{-0.67, 2.73, 7.99}, {0.00, 270.00, 180.00}},
        [3] = {{-0.22, 2.73, -4.78}, {0.00, 310.47, 180.00}},
        [4] = {{-2.36, 2.73, -7.35}, {0.00, 310.47, 180.00}},
        [5] = {{-12.35, 2.73, -10.46}, {0.00, 270.00, 180.00}}
    }

    local scriptingZonesObjects = {
        vehicleScriptingZone1,
        vehicleScriptingZone2,
        vehicleScriptingZone3,
        vehicleScriptingZone4,
        vehicleScriptingZone5,
    }

    -- True when 1 location is removed. Only need 1 removed.
    local locationRemoved = false

    -- Check zones for vehicle card present. If not empty, remove location from freeVehicleLocations table
    local function inspectLocation(value)
        for _, object in ipairs(scriptingZonesObjects[value].getObjects()) do
            if object.hasTag("Vehicle") then
                table.remove(freeVehicleLocations, value)
            end
        end
    end

    -- Only run when nothing is yet removed
    if not locationRemoved then inspectLocation(1) end
    if not locationRemoved then inspectLocation(2) end
    if not locationRemoved then inspectLocation(3) end
    if not locationRemoved then inspectLocation(4) end
    if not locationRemoved then inspectLocation(5) end

    -- Move remaining 4 vehicle cards to board. Error when deck is not 4 cards!
    if not (vehicleDeck.getQuantity() == 4) then
        broadcastToAll("ERROR: Vehicle deck size should be 4!", "Red")
        Player[Turns.turn_color].pingTable(vehicleDeck.getPosition())
    elseif not (#freeVehicleLocations == 4) then
        broadcastToAll("Error: Place the Blue Truck first!", "Red")
        Player[Turns.turn_color].pingTable(blueTruckPosition)
    else
        for i = 1, 4 do
            vehicleDeck.takeObject({
                position = freeVehicleLocations[i][1],
                rotation = freeVehicleLocations[i][2],
                smooth = false
            })
        end
    end

    -- End of setup reached
    SetupDone = true
    log("SetupDone = " .. tostring(SetupDone))
end