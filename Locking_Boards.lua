local leatherfaceBoardGUID = "5ec27f"
local hitchhikerBoardGUID = "06c597"
local oldManBoardGUID = "a30ee9"
local boardObjectGUID = "7cd743"
local leatherfaceBoard
local hitchhikerBoard
local oldManBoard
local boardObject

function ButtonLockOldMan()
    oldManBoard = getObjectFromGUID(oldManBoardGUID)
    boardObject = getObjectFromGUID(boardObjectGUID)

    if oldManBoard.locked == true then
        oldManBoard.locked = false
        boardObject.UI.setAttribute("ButtonLockOldMan", "text", "Lock")
    else
        oldManBoard.locked = true
        boardObject.UI.setAttribute("ButtonLockOldMan", "text", "Unlock")
    end
end

function ButtonLockHitchhiker()
    hitchhikerBoard = getObjectFromGUID(hitchhikerBoardGUID)
    boardObject = getObjectFromGUID(boardObjectGUID)

    if hitchhikerBoard.locked == true then
        hitchhikerBoard.locked = false
        boardObject.UI.setAttribute("ButtonLockHitchhiker", "text", "Lock")
    else
        hitchhikerBoard.locked = true
        boardObject.UI.setAttribute("ButtonLockHitchhiker", "text", "Unlock")
    end
end

function ButtonLockLeatherface()
    leatherfaceBoard = getObjectFromGUID(leatherfaceBoardGUID)
    boardObject = getObjectFromGUID(boardObjectGUID)

    if leatherfaceBoard.locked == true then
        leatherfaceBoard.locked = false
        boardObject.UI.setAttribute("ButtonLockLEatherface", "text", "Lock")
    else
        leatherfaceBoard.locked = true
        boardObject.UI.setAttribute("ButtonLockLEatherface", "text", "Unlock")
    end
end