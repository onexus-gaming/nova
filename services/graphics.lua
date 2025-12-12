-- Helper functions for graphics
local graphics = nova.Service:extend()

graphics.name = "Graphics helper"

function graphics:new()
    self.intendedDimensions = {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
    }
    self.scaleMultiplier = 1

    self.scalingCoefficient = self:calculateScalingCoefficient()

    self.applyingTransformations = false
end

-- scaling

---Set the dimensions the game is intended to be displayed in
---@param width number
---@param height number
function graphics:setIntendedDimensions(width, height)
    nova.checkArgType("width", width, "number")
    nova.checkArgType("height", height, "number")

    self.intendedDimensions.width = width
    self.intendedDimensions.height = height
end

---Set the scaling coefficient multiplier and update the scaling coefficient
---@param scaleMultiplier number
function graphics:setScaleMultiplier(scaleMultiplier)
    nova.checkArgType("scaleMultiplier", scaleMultiplier, "number")
    if scaleMultiplier < 0 then
        error("scale multiplier must be greater than 0", 2)
    end

    self.scaleMultiplier = scaleMultiplier

    self.scalingCoefficient = self:calculateScalingCoefficient()
end

---Calculate the scaling coefficient with respect to the intended dimensions and applied multiplier
---@return number
function graphics:calculateScalingCoefficient(w, h)
    if w == nil or h == nil then
        w, h = love.graphics.getDimensions()
    else
        nova.checkArgType("w", w, "number")
        nova.checkArgType("h", h, "number")
    end

    return math.min(w/self.intendedDimensions.width, h/self.intendedDimensions.height) * self.scaleMultiplier
end

-- hooks to resize calls to recalculate the scaling coefficient
-- for efficiency
function graphics:_resize(w, h)
    print('RSZ', w, h)
    self.scalingCoefficient = self:calculateScalingCoefficient(w, h)
    print(self.scalingCoefficient, w/self.scalingCoefficient, h/self.scalingCoefficient)
end

---Set whether to apply scaling and translation to fit the intended area to the screen
---@param state boolean
function graphics:applyTransformations(state)
    self.applyingTransformations = state
    if state then
        local w, h = love.graphics.getDimensions()
        love.graphics.push()
        love.graphics.translate(math.round((w - self.scalingCoefficient * self.intendedDimensions.width)/2), math.round((h - self.scalingCoefficient * self.intendedDimensions.height)/2))
        love.graphics.scale(self.scalingCoefficient)
    else
        love.graphics.pop()
    end
end

return graphics