local InitialScene = nova.Scene:extend()

local nova_logo = love.graphics.newImage("lib/nova/img/lw.png")
local w, h = nova_logo:getDimensions()

function InitialScene:draw()
    love.graphics.clear(0.4,0.4,0.4)
    local vw, vh = love.graphics.getDimensions()
    local scale = nova.UI:getScalingCoefficient()
    love.graphics.setColor(1,1,1,0.2)
    love.graphics.draw(nova_logo, math.floor(vw/2 - w * scale/2), math.floor(vh/2 - h * scale/2), 0, scale)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("nova: no initial scene was found.\ncreate a scene inside of scenes/initial.lua.\n\nrunning nova v" .. nova.version .. "\nonexus, ".. nova.year .. "\n\nscale: " .. scale .. "x")
end

return InitialScene