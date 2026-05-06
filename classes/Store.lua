---Basic class for storing data.
---Doesn't use the default object system for simplicity reasons.


local isolatedValue = {}

---@class Store<T>
---@field callbacks table
local Store = {
    ---Returns the value contained by the Store.
    ---@param self Store<any>
    ---@return any
    get = function(self)
        return self[isolatedValue]
    end,
    ---Sets the value in the Store. Calls all bound callbacks if any.
    ---@param self Store<any>
    ---@param value any
    set = function(self, value)
        for i, v in ipairs(self.callbacks) do
            v(self, self[isolatedValue], value)
        end
        self[isolatedValue] = value
    end,
    bind = function(self, callback)
        nova.checkArgType("callback", callback, "function")
        table.insert(self.callbacks, callback)
    end,
    unbind = function(self, pos)
        nova.checkArgTypes("pos", pos, {"number", "function"})
        table.remove(self.callbacks, pos)
    end,
}

local StoreMT = {
    __index = Store,
    __call = function(self, value)
        if value ~= nil then
            self:set(value)
        else
            return self:get()
        end
    end,
}

return function(initValue)
    ---@type Store<any>
    local instance = {
        callbacks = {},
    }

    setmetatable(instance, StoreMT)

    instance:set(initValue)

    return instance
end