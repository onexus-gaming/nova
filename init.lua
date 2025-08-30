-- nova 0.1.0
-- onexus, 2025

-- dependencies
binser = require "lib.binser"
Object = require "lib.classic"

-- helpers
local function findInTable(t, e)
    for k, v in pairs(t) do
        if v == e then
            return k
        end
    end
    return k
end

local Scene = require "lib.nova.classes.Scene"
local Service = require "lib.nova.classes.Service"
local Rectangle = require "lib.nova.classes.Rectangle"

nova = {
    version = "0.1.0",
    year = 2025,

    title = "untitled nova game",
    id = "nova" .. love.math.random(1, 999999),

    Rectangle = Rectangle,

    Scene = Scene,
    Service = Service,

    scenes = {
        loaded = {},
        current = Scene(),
        load = function(self, name)
            self.loaded[name] = require("scenes." .. name)
        end,
        switch = function(self, name, ...)
            self.current = self.loaded[name](...)
        end,
    },

    services = {
        list = {},
        register = function(self, service, priority)
            if priority == nil then priority = #self.list + 1 end
            if not findInTable(self.list, service) then
                table.insert(self.list, priority, service)
            end
        end,
    },
}

-- loading scenes
if not pcall(function() require "scenes.initial" end) then
    print("[nova/scenes] no initial scene")
    nova.scenes.loaded.initial = require "lib.nova.default_initial"
else
    nova.scenes:load("initial")
end
nova.scenes:switch("initial")

-- loading services
nova.UI = require("lib.nova.services.UI")()
nova.services:register(nova.UI, 1)

local function createHook(name)
    return function(...)
        for i, svc in ipairs(nova.services) do
            if svc["pre_"..name] then
                svc["pre_"..name](...)
            end
        end
        if nova.scenes.current[name] then
            nova.scenes.current[name](...)
        end
        for i, svc in ipairs(nova.services) do
            if svc[name] then
                svc[name](...)
            end
        end
    end
end

local hookTable = {"load", "update", "draw", "keypressed", "keyreleased", "mousefocus", "mousemoved", "mousepressed", "mousereleased", "wheelmoved"}
for i, v in ipairs(hookTable) do
    love[v] = createHook(v)
end

nova.scenes.current:opened()