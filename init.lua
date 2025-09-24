-- nova 0.1.1
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
    return nil
end

local function checkArgType(paramName, value, expectedType)
    if type(value) ~= expectedType then
        error("parameter \"" .. paramName .. "\" expected an argument of type \"" .. expectedType .. "\" but received an argument of type \"" .. type(value) .. "\"", 3)
    end
end

local function checkArgClass(paramName, value, class)
    if type(value) ~= "table" then
        error("parameter \"" .. paramName .. "\" expected an argument to be an object of class \"" .. class .. "\" but received an argument of type \"" .. type(value) .. "\"", 3)
    end
    if type(value.is) ~= "function" then
        error("parameter \"" .. paramName .. "\" expected an argument to be an object of class \"" .. class .. "\" but received an argument of type \"table\"", 3)
    end
    if not value:is(class) then
        error("parameter \"" .. paramName .. "\" expected an argument to be an object of class \"" .. class .. "\" but received an argument of class \"" .. value.super .. "\"", 3)
    end
end

function math.round(x)
    return math.floor(x + 0.5)
end

local Scene = require "lib.nova.classes.Scene"
local Service = require "lib.nova.classes.Service"
local Rectangle = require "lib.nova.classes.Rectangle"
local Timer = require "lib.nova.classes.Timer"

-- simple and effective framework to make games with love2d, successor to novum
nova = {
    version = "0.1.1",
    year = 2025,

    title = "untitled nova game",
    id = "nova" .. love.math.random(1, 999999),

    checkArgType = checkArgType,
    checkArgClass = checkArgClass,

    Rectangle = Rectangle,

    Scene = Scene,
    Service = Service,

    Timer = Timer,

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
            --print('REGSVC', service, priority)
            if not findInTable(self.list, service) then
                table.insert(self.list, priority, service)
            end
        end,
        registerInOrder = function(self, ...)
            for i, svc in ipairs({...}) do
                self:register(svc)
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

-- Helper functions for graphics
nova.graphics = require("lib.nova.services.graphics")()
nova.services:registerInOrder(nova.graphics)

local function createHook(name)
    return function(...)
        for i, svc in ipairs(nova.services.list) do
            if svc["_pre_"..name] then
                svc["_pre_"..name](svc, ...)
            end
        end
        if nova.scenes.current[name] then
            nova.scenes.current[name](...)
        end
        for i, svc in ipairs(nova.services.list) do
            if svc["_" .. name] then
                svc["_" .. name](svc, ...)
            end
        end
    end
end

local hookTable = {"load", "update", "draw", "resize", "occluded", "keypressed", "keyreleased", "mousefocus", "mousemoved", "mousepressed", "mousereleased", "wheelmoved", "dropbegan", "dropmoved", "dropcompleted", "filedropped"}
for i, v in ipairs(hookTable) do
    love[v] = createHook(v)
end

nova.scenes.current:opened()