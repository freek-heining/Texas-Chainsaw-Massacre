function SetInteractableFalse()
    local tableGUID = "b1cd0c"
    local tableObject = getObjectFromGUID(tableGUID)
    tableObject.interactable = false

    local diceTrayGUID = "985b0d"
    local diceTray = getObjectFromGUID(diceTrayGUID)
    diceTray.interactable = false
end
