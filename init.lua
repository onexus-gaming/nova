-- nova 0.1.0
-- onexus, 2025

-- dependencies
binser = require "lib.binser"
Object = require "lib.classic"

local Scene = require "lib.nova.classes.Scene"

local nova = {
    version = "0.1.0",
    year = 2025,

    title = "untitled nova game",
    id = "nova" .. love.math.random(1, 999999),

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

    services = {},

    Scene = Scene,
}

-- loading scenes
if not pcall(function() require "scenes.initial" end) then
    print("[nova/scenes] no initial scene")
    nova.scenes.loaded.initial = require "lib.nova.default_initial"
    nova.scenes:switch("initial")
end

local function createHook(name)
    return function(...)
        for i, svc in ipairs(nova.services) do
            if svc[name] then
                svc[name](...)
            end
        end
        if nova.scenes.current[name] then
            nova.scenes.current[name](...)
        end
    end
end

local hookTable = {"load", "update", "draw"}
for i, v in ipairs(hookTable) do
    love[v] = createHook(v)
end

nova.scenes.current:opened()

return nova