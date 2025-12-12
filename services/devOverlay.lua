local devOverlay = nova.Service:extend()

local graphicsHandler = require("lib.nova.services.graphics")()
graphicsHandler.name = "Graphics handler (developer overlay)"
graphicsHandler:setIntendedDimensions(800, 600)

local fonts = {
    title = love.graphics.newFont(20),
    subtitle = love.graphics.newFont(17),
    data = love.graphics.newFont(14),
}

function devOverlay:new()
    self.display = false
    self.hitKeys = {}
    self.joysticks = love.joystick.getJoysticks()
end

function devOverlay:enable()
    nova.toasts:post(nova.Toast.TOAST_TYPE.INFORMATION, "The developer overlay is enabled. Press F12 to open it.")
    nova.services:register(graphicsHandler, 1)
    nova.services:register(self, 1)
end

function devOverlay:_pre_keypressed(key)
    if key == 'f12' then
        self.display = not self.display
    end
    self.hitKeys[key] = true

    return self.display -- capture if displaying or just opened
end

function devOverlay:_pre_keyreleased(key)
    self.hitKeys[key] = false

    return self.display or key == 'f12' -- capture if displaying or just closed
end

function devOverlay:_pre_joystickadded()
    self.joysticks = love.joystick.getJoysticks()
end

function devOverlay:_pre_joystickremoved()
    self.joysticks = love.joystick.getJoysticks()
end

function devOverlay:_pre_joystickaxis()
    return self.display
end

function devOverlay:_pre_joystickhat()
    return self.display
end

function devOverlay:_pre_joystickpressed()
    return self.display
end

function devOverlay:_pre_joystickreleased()
    return self.display
end

function devOverlay:_draw()
    if not self.display then return end

    local initialApplyTransformations = nova.graphics.applyingTransformations
    if initialApplyTransformations then nova.graphics.applyTransformations(false) end

    love.graphics.reset()

    local y = 0
    local function step(n)
        y = y + (n or love.graphics.getFont():getHeight())
    end

    love.graphics.setColor(0, 0, 0, 0.5)

    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
    graphicsHandler:applyTransformations(true)

    love.graphics.setColor(1, 0.2, 0)
    love.graphics.setFont(fonts.title)
    love.graphics.print("Keyboard input", 0, y)
    step()

    local keys = {}
    for k, v in pairs(self.hitKeys) do
        if v then
            table.insert(keys, k)
        end
    end
    table.sort(keys)

    s = ""
    for i, v in pairs(keys) do
        s = s .. v .. " "
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.data)
    love.graphics.print(s, 0, y)
    step()

    love.graphics.setColor(1, 0.2, 0)
    love.graphics.setFont(fonts.title)
    love.graphics.print("Joystick input", 0, y)
    step()

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fonts.subtitle)
    for i, joystick in ipairs(self.joysticks) do
        love.graphics.print(joystick:getName() .. " (" .. joystick:getGUID() .. ")", 0, y)
        step(36)

        local x = 9

        for j = 1,joystick:getHatCount() do
            local hat = joystick:getHat(j)
            love.graphics.setColor(1, 0.2, 0)
            if string.find(hat, "r") then
                love.graphics.arc("fill", "pie", x + 18, y + 9, 18, -math.pi/4, math.pi/4)
            end
            if string.find(hat, "d") then
                love.graphics.arc("fill", "pie", x + 18, y + 9, 18, math.pi/4, math.pi/4*3)
            end
            if string.find(hat, "l") then
                love.graphics.arc("fill", "pie", x + 18, y + 9, 18, math.pi/4*3, math.pi/4*5)
            end
            if string.find(hat, "u") then
                love.graphics.arc("fill", "pie", x + 18, y + 9, 18, math.pi/4*5, math.pi/4*7)
            end
            
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("line", x + 18, y + 9, 18)
            love.graphics.printf(j, x, y, 36, 'center')

            x = x + 45
        end

        for j = 1,joystick:getAxisCount() do
            local axis = joystick:getAxis(j)

            love.graphics.setColor(1, 0.2, 0)
            love.graphics.rectangle('fill', x + 36, y, 36*axis, 18)

            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle('line', x , y, 72, 18)
            love.graphics.printf(j, x, y, 72, 'center')

            x = x + 81
        end

        step(36)

        x = 9
        for j = 1,joystick:getButtonCount() do
            if joystick:isDown(j) then
                love.graphics.setColor(1, 0.2, 0)
                love.graphics.circle("fill", x + 16, y + 8, 16)
            end

            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("line", x + 16, y + 8, 16)
            love.graphics.printf(j, x, y, 32, 'center')

            x = x + 40
        end

        step(36)
    end

    graphicsHandler:applyTransformations(false)
    if initialApplyTransformations then nova.graphics.applyTransformations(true) end

    love.graphics.reset()
end

return devOverlay