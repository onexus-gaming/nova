---Basic timer class.
---@class Timer
---@field min number
---@field max number
---@field initial number
---@field current number
---@field running boolean
---@field direction number
local Timer = Object:extend()

function Timer:new(min, max, initial)
    -- TODO: ADD TYPE CHECKING

    self.min = min
    self.max = max
    self.initial = initial

    self.current = initial
    self.running = false
    self.direction = 1
    if self.max < self.min then
        self.direction = -1
    end
end

---Start the timer in the designated direction
function Timer:start()
    self.running = true
end

---Pause the timer
function Timer:pause()
    self.running = false
end

---Pause the timer and reset the value according to the designated direction
function Timer:stop()
    self:pause()

    if self.direction == 1 then
        self.current = self.min
    else
        self.current = self.max
    end
end

---Set the timer value
---@param value number
function Timer:set(value)
    self.current = math.min(math.max(self.min, value), self.max)
end

---Start the timer with a forwards (increasing) direction
function Timer:forwards()
    self.direction = 1
    self:start()
end

---Start the timer with a backwards (decreasing) direction
function Timer:backwards()
    self.direction = -1
    self:start()
end

---Update the timer
---@param dt number
function Timer:update(dt)
    if self.running then
        self.current = math.min(math.max(self.min, self.current + self.direction * dt), self.max)
    end
end

return Timer