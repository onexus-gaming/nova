---Helper class for vector calculation
---@class Vector
local Vector = Object:extend()

local privateValues = {}

function Vector:new(...)
    local args = {...}

    if #args == 1 and type(args[1]) == "table" then
        self[privateValues] = {}
        args = args[1]
        for i, v in ipairs(args) do
            table.insert(self[privateValues], v)
        end
    else
        for i, v in ipairs(args) do
            if type(v) ~= "number" then
                error("vector value " .. i .. " (" .. v .. ")" .. "is of type " .. type(v) .. ", not number", 2)
            end
            self[privateValues] = args
        end
    end
end

---Create a default vector with arbitrary dimension and default value
---@param dimension integer|nil
---@param defaultValue number|nil
function Vector.make(dimension, defaultValue)
    if type(dimension) ~= "number" then
        dimension = 1
    elseif dimension%1 > 0 then
        dimension = math.floor(dimension)
    end
    if type(defaultValue) ~= "number" then
        defaultValue = 0
    end

    local values = {}
    for i = 1, dimension do
        table.insert(values, defaultValue)
    end

    return Vector((unpack or table.unpack)(values))
end

function Vector:values()
    local copy = {}

    for i, v in ipairs(self[privateValues]) do
        table.insert(copy, v)
    end

    return copy
end

function Vector:get(i)
    return self[privateValues][i] or 0
end

function Vector:dimension()
    return #self[privateValues]
end

function Vector:copy()
    return Vector(self:values())
end

function Vector:sum(other)
    nova.checkArgClass("other", other, Vector)

    local values = {}
    for i = 1, math.max(self:dimension(), other:dimension()) do
        table.insert(values, self:get(i) + other:get(i))
    end

    return Vector((unpack or table.unpack)(values))
end

function Vector:difference(other)
    nova.checkArgClass("other", other, Vector)

    local values = {}
    for i = 1, math.max(self:dimension(), other:dimension()) do
        table.insert(values, self:get(i) - other:get(i))
    end

    return Vector((unpack or table.unpack)(values))
end

function Vector:__add(other)
    return self:sum(other)
end

function Vector:__sub(other)
    return self:difference(other)
end

function Vector:valueProduct(other)
    nova.checkArgClass("other", other, Vector)

    local values = {}
    for i = 1, math.max(self:dimension(), other:dimension()) do
        table.insert(values, self:get(i) * other:get(i))
    end

    return Vector((unpack or table.unpack)(values))
end

function Vector:scalarProduct(other)
    nova.checkArgClass("other", other, Vector)

    local value = 0
    for i = 1, self:dimension() do
        value = value + self:get(i) * other:get(i)
    end

    return value
end

function Vector:scale(coefficient)
    nova.checkArgType("coefficient", coefficient, "number")

    local values = {}
    for i = 1, self:dimension() do
        table.insert(values, self:get(i) * coefficient)
    end

    return Vector((unpack or table.unpack)(values))
end

function Vector:valueDivision(other)
    nova.checkArgClass("other", other, Vector)

    local values = {}
    for i = 1, math.max(self:dimension(), other:dimension()) do
        table.insert(values, self:get(i) / other:get(i))
    end

    return Vector((unpack or table.unpack)(values))
end

function Vector:downscale(coefficient)
    nova.checkArgType("coefficient", coefficient, "number")

    local values = {}
    for i = 1, self:dimension() do
        table.insert(values, self:get(i) / coefficient)
    end

    return Vector((unpack or table.unpack)(values))
end

function Vector:__mul(other)
    if type(other) == "table" and other:is(Vector) then
        return self:valueProduct(other)
    elseif type(other) == "number" then
        return self:scale(other)
    else
        error("cannot compute product between vector and " .. type(other))
    end
end

function Vector:__div(other)
    if type(other) == "table" and other:is(Vector) then
        return self:valueDivision(other)
    elseif type(other) == "number" then
        return self:downscale(other)
    else
        error("cannot compute division between vector and " .. type(other))
    end
end

function Vector:__tostring()
    s = "Vector"

    if self[privateValues] ~= nil then
        s = s .. "("
        for i = 1, #self[privateValues] do
            s = s .. self[privateValues][i]
            if i < #self[privateValues] then
                s = s .. " "
            end
        end

        s = s .. ")"
    end

    return s
end

return Vector