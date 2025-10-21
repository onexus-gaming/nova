---Class to hold information with semantic meaning
---@class Toast
---@field type table
---@field text string
---@field timestamp number
---@field decay number
local Toast = Object:extend()

Toast.TOAST_TYPE = {
    SUCCESS = {"Success", {0.3,   1, 0.3}},
    DEBUG = {"Debug", {0.6, 0.6, 0.6}},
    INFORMATION = {"Information", {0.5, 0.7, 0.9}},
    WARNING = {"Warning", {1,   0.7, 0.1}},
    ERROR = {"Error", {1,   0.3, 0.3}},
}
Toast.TYPE_FONT = love.graphics.newFont(8)
Toast.TEXT_FONT = love.graphics.newFont(16)

function Toast:new(type, text, timestamp, decay)
    self.type = type
    self.text = text
    self.timestamp = timestamp
    self.decay = decay
end

function Toast:width(lifetime)
    if lifetime == nil then lifetime = 0 end
    local f = lifetime * 8
    if f > 1 then f = 1 end
    return math.round((math.max(self.TEXT_FONT:getWidth(self.text), self.TYPE_FONT:getWidth(self.type[1])) + 12) * f)
end

function Toast:height(lifetime)
    if lifetime == nil then lifetime = 0 end
    return math.max(self.TEXT_FONT:getWidth(self.text), self.TYPE_FONT:getWidth(self.type[1])) + 8
end

function Toast:render(x, y, lifetime)
    local of = love.graphics.getFont()
    local oc = {love.graphics.getColor()}
    
    if lifetime < 0.125 then
        love.graphics.setColor(self.type[2])
        love.graphics.rectangle('fill', x, y, self:width(lifetime), self:height())
    else
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', x, y, self:width(), self:height())

        love.graphics.setColor(self.type[2])
        love.graphics.rectangle('fill', x, y, 4, self:height())

        love.graphics.setFont(self.TYPE_FONT)
        love.graphics.print(self.type[1], x+8, y+4)

        love.graphics.setFont(self.TEXT_FONT)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(self.text, x+8, y+4+self.TYPE_FONT:getHeight())

        if lifetime < 0.25 then
            local f = 1-math.min((lifetime - 0.125) * 8, 1)
            local c = self.type[2]
            love.graphics.setColor(c[1], c[2], c[3], f)
            love.graphics.rectangle('fill', x, y, self:width(), self:height())
        end
    end
end

return Toast