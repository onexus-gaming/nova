-- nova 0.1.0
-- onexus, 2025

-- dependencies
binser = require "lib.binser"
Object = require "lib.classic"

local Scene = require "lib.nova.classes.Scene"

local nova = {
    scenes = {
        loaded = {},
        current = Scene(),
        load = function(self, name)
            self.loaded[name] = require("scenes." .. name)
        end,
    },

    services = {},

    Scene = Scene,
}

-- loading scenes
if not pcall(function() require "scenes.initial" end) then
    nova.scenes.loaded.initial = require "lib.nova.default_initial"
end

local hook_table = {"load", "update", "draw"}
for i, v in ipairs(hook_table) do
    local original_function = love[v]

    love[v] = function(...)
        for j, svc in ipairs(nova.services) do
            if svc[v] then
                svc[v](...)
            end
        end
        if nova.scenes.current[v] then
            nova.scenes.current[v](...)
        end
        original_function(...)
    end
end

nova.scenes.current:opened()

return nova