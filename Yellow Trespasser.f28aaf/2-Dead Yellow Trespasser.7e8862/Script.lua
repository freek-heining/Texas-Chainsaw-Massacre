function onStateChange()
    local oldRotation = self.getRotation()
    local newRotation = {80, oldRotation.y, 0}
    self.setRotation(newRotation)
end