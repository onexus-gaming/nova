---Collection of unique, unordered objects  
---Instanciation should be done with `Set{your elements here}`
---@class Set
local Set = Object:extend()
local privateValues = {}

function Set:new(elements)
    nova.checkArgType('elements', elements, "table")
    self[privateValues] = {}
    for i, v in ipairs(elements) do
        self:add(v)
    end
end

function Set:add(element)
    self[privateValues][element] = true
end

function Set:remove(element)
    self[privateValues][element] = nil
end

function Set:has(element)
    return self[privateValues][element] ~= nil -- boolean conversion
end

function Set:elements()
    local elements = {}
    for elm, _ in pairs(self[privateValues]) do
        table.insert(elements, elm)
    end
    return elements
end

---Checks whether this set is a subset of the given set
---@param other Set
---@return boolean
function Set:isSubsetOf(other)
    nova.checkArgClass('other', other, Set)
    for elm, _ in pairs(self[privateValues]) do
        if not other:has(elm) then return false end
    end
    return true
end

---Checks whether this set is equal to the given set
---@param other Set
---@return boolean
function Set:equals(other)
    nova.checkArgClass('other', other, Set)
    return self:isSubsetOf(other) and other:isSubsetOf(self)
end

---Checks whether this set is a proper subset of the given set (subset and not equal)
---@param other Set
---@return boolean
function Set:isProperSubsetOf(other)
    nova.checkArgClass('other', other, Set)
    return self:isSubsetOf(other) and not other:isSubsetOf(self)
end

---Checks whether this set is a superset of the given set
---@param other Set
---@return boolean
function Set:isSupersetOf(other)
    return other:isSubsetOf(self)
end

---Checks whether this set is a proper superset of the given set (superset and not equal)
---@param other Set
---@return boolean
function Set:isProperSupersetOf(other)
    return other:isProperSubsetOf(self)
end

return Set