-- nova 0.1.3
-- onexus, 2025

---@alias class table MUST be a class
---@alias float number n >= math.floor(n)

-- dependencies
---@diagnostic disable-next-line: lowercase-global
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

---@param paramName string
---@param value any
---@param expectedType type
local function checkArgType(paramName, value, expectedType)
    if type(value) ~= expectedType then
        error("parameter \"" .. paramName .. "\" expected an argument of type \"" .. expectedType .. "\" but received an argument of type \"" .. type(value) .. "\"", 3)
    end
end

---@param paramName string
---@param value any
---@param class class MUST be a class
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
local Store = require "lib.nova.classes.Store"
local Timer = require "lib.nova.classes.Timer"
local Toast = require "lib.nova.classes.Toast"
local Vector = require "lib.nova.classes.Vector"

-- simple and effective framework to make games with love2d, successor to novum
---@diagnostic disable-next-line: lowercase-global
nova = {
    version = "0.1.3",
    year = 2025,

    title = "untitled nova game",
    id = "nova" .. love.math.random(1, 999999),

    checkArgType = checkArgType,
    checkArgClass = checkArgClass,

    Rectangle = Rectangle,

    Scene = Scene,
    Service = Service,

    Timer = Timer,
    Toast = Toast,
    Store = Store,
    Vector = Vector,
    vectors = {
        null2d = Vector.make(2),
        null3d = Vector.make(3),
        extend2d = Vector.make(2, 1),
        extend3d = Vector.make(3, 1),
        flip1d = Vector(-1),
        flipX2d = Vector(-1, 1),
        flipY2d = Vector(1, -1),
        flipX3d = Vector(-1, 1, 1),
        flipY3d = Vector(1, -1, 1),
        flipZ3d = Vector(1, 1, -1),
        X2d = Vector(1, 0),
        Y2d = Vector(0, 1),
        X3d = Vector(1, 0, 0),
        Y3d = Vector(0, 1, 0),
        Z3d = Vector(0, 0, 1),
    },

    -- Does nothing
    noop = function(...) end,
    -- Returns the arguments it takes
    echo = function(...) return ... end,
    -- Returns the arguments it takes as a table
    echoT = function(...) return {...} end,
    -- Returns a function that returns the passed values
    wrap = function(...)
        local args = {...}
        return function()
            return (unpack or table.unpack)(args)
        end
    end,

    scenes = {
        loaded = {},
        current = Scene(),
        load = function(self, name)
            self.loaded[name] = require("scenes." .. name)
            if self.loaded[name].isSingleton then
                self.loaded[name] = self.loaded[name]()
            end
        end,
        switch = function(self, name, ...)
            if self.loaded[name].isSingleton then
                self.current = self.loaded[name]
            else
                self.current = self.loaded[name](...)
            end

            if self.loaded[name].opened then
                self.loaded[name].opened(...)
            end
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

-- loading services

-- Helper functions for graphics
nova.graphics = require("lib.nova.services.graphics")()
-- Toast manager
nova.toasts = require("lib.nova.services.toasts")(5, 4, 4)
nova.services:registerInOrder(nova.toasts, nova.graphics)

-- loading scenes

if not pcall(function() require "scenes.initial" end) then
    print("[nova/scenes] no initial scene found, defaulting to demo scene.")
    nova.toasts:post(nova.Toast.TOAST_TYPE.WARNING, "no initial scene found, defaulting to demo scene.")
    nova.scenes.loaded.initial = require "lib.nova.default_initial"
else
    nova.scenes:load("initial")
end
nova.scenes:switch("initial")

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