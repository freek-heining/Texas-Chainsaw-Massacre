-- Get all dice objects in tray
function GetDiceFromZone()
    local DiceTrayZoneGuid = "89711c"
    local DiceTrayZoneObject = getObjectFromGUID(DiceTrayZoneGuid)
    
    local diceObjects = {}

    for _, object in ipairs(DiceTrayZoneObject.getObjects()) do
        if object.getName() == "Bone Die" then
            log("die found")
            table.insert(diceObjects, object)
        end
    end
    log(diceObjects)
end

