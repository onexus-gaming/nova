local UI = nova.Service:extend()

function UI:new()
    self.intendedDimensions = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
    }
end

function UI:getScalingCoefficient()
    local w, h = love.graphics.getDimensions()

    return math.min(w/self.intendedDimensions.width, h/self.intendedDimensions.height)
end