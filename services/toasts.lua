-- Toast manager
local toasts = nova.Service:extend()

toasts.name = "Toast manager"

function toasts:new(defaultDecay, padding, margin)
    self.items = {}
    self.defaultDecay = defaultDecay
    self.padding = padding
    self.margin = margin
end

function toasts:register(toast)
    table.insert(self.items, 1, toast)
end

function toasts:post(type, text, decay)
    local toast = nova.Toast(type, text, love.timer.getTime(), decay or self.defaultDecay)
    self:register(toast)
end

function toasts:_update(dt)
    local i = 1
    while i <= #self.items do
        local v = self.items[i]
        if love.timer.getTime() - v.timestamp >= v.decay then
            table.remove(self.items, i)
        end
        i = i + 1
    end
end

function toasts:_draw()
    local y = self.padding
    for i, v in ipairs(self.items) do
        local lifetime = love.timer.getTime() - v.timestamp
        v:render(self.padding, y, lifetime)
        y = y + v:height(lifetime) + self.margin
    end
end

return toasts