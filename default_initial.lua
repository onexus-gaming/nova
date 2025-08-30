local InitialScene = nova.Scene:extend()

local nova_logo = love.graphics.newImage("lib/nova/img/lw.png")
local w, h = nova_logo:getDimensions()

function InitialScene:draw()
    local vw, vh = love.graphics.getDimensions()
    local scale = nova.UI:getScalingCoefficient()
    local pad = math.floor(16 * scale)
    love.graphics.print("nova: no initial scene was found.\ncreate a scene inside of scenes/initial.lua.\n\nrunning nova v" .. nova.version .. "\nonexus, ".. nova.year .. "\n\nscale: " .. scale .. "x")
    love.graphics.draw(nova_logo, math.floor(vw - w * scale - pad), math.floor(vh - h * scale - pad), 0, scale)
end

return InitialScene