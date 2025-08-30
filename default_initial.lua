local InitialScene = nova.Scene:extend()

function InitialScene:draw()
    love.graphics.print("nova: no initial scene was found.\ncreate a scene inside of scenes/initial.lua.\n\nrunning nova v" .. nova.version .. "\nonexus, ".. nova.year)
end

return InitialScene