function onStateChange()
    local oldRotation = self.getRotation()
    local newRotation = {0, oldRotation.y, 0}
    local oldPosition = self.getPosition()
    local newPosition = oldPosition:add(vector(0, 2, 0))
    self.setPosition(newPosition)
    self.setRotation(newRotation)
end