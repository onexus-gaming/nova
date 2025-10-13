---Simple linear and non-linear counter class
---Doesn't use the default object system for simplicity reasons.
---@class SmoothCounter
---@field value number
---@field target number
---@field direction -1|1
---@field exponent number (0 for linear, >0 for non-linear)
---@field factor number (must be >0)

--TODO: ADD TYPE CHECKING

local SmoothCounter = {
    getValue = function(self)
        return self.value
    end,
    getTarget = function(self)
        return self.target
    end,
    getExponent = function(self)
        return self.exponent
    end,
    getFactor = function(self)
        return self.factor
    end,
    setValue = function(self, value)
        self.value = value
        if value < self.target then
            self.direction = -1
        else
            self.direction = 1
        end
    end,
    setTarget = function(self, target)
        self.target = target
    end,
    setExponent = function(self, exponent)
        self.exponent = exponent
    end,
    setFactor = function(self, factor)
        self.factor = factor
    end,
    floor = function(self)
        return math.floor(self.value)
    end,
    ceil = function(self)
        return math.ceil(self.value)
    end,
    round = function(self)
        return math.floor(self.value + 0.5)
    end,
    update = function(self, dt)
        if self.exponent == 0 then
            self.value = self.value + self.direction * self.factor * dt
        else
            self.value = self.value + self.direction * (math.abs(self.target - self.value) ^ self.exponent) * self.factor * dt
        end

        if (self.direction == 1 and self.value >= self.target) or (self.direction == -1 and self.value <= self.target) or math.abs(self.target - self.value) < 0.001 then
            self.value = self.target
        end
    end,
}

return function(value, target, exponent, factor)
    local instance = {
        value = value,
        target = target,
        direction = value > target and -1 or 1,
        exponent = exponent,
        factor = factor,
    }

    setmetatable(instance, {
        __index = SmoothCounter,
        __call = function(self, value)
            if value ~= nil then
                self:setTarget(value)
            else
                return self:getValue()
            end
        end,
    })

    return instance
end