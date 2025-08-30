local InitialScene = nova.Scene:extend()

local nova_logo = love.graphics.newImage("lib/nova/img/lw.png")
local w, h = nova_logo:getDimensions()

function InitialScene:draw()
    local vw, vh = love.graphics.getDimensions()
    local pad = math.floor(vw/50)
    love.graphics.print("nova: no initial scene was found.\ncreate a scene inside of scenes/initial.lua.\n\nrunning nova v" .. nova.version .. "\nonexus, ".. nova.year)
    love.graphics.draw(nova_logo, vw - w - pad, vh - h - pad)
end

return InitialScene