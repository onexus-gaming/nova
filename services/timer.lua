local Timer = Object:extend()

function Timer:new(min, max, initial)
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

function Timer:start()
    self.running = true
end

function Timer:pause()
    self.running = false
end

function Timer:stop()
    self:pause()

    if self.direction == 1 then
        self.current = self.min
    else
        self.current = self.max
    end
end

function Timer:set(value)
    self.current = math.min(math.max(self.min, value), self.max)
end

function Timer:forwards()
    self.direction = 1
    self:start()
end

function Timer:backwards()
    self.direction = -1
    self:start()
end

function Timer:update(dt)
    if self.running then
        self.current = math.min(math.max(self.min, self.current + self.direction * dt), self.max)
    end
end

return Timer