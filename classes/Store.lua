-- Basic class for storing data.
-- Doesn't use the default object system for simplicity reason.

local isolatedValue = {}

local Store = {
    get = function(self)
        return self[isolatedValue]
    end,
    set = function(self, value)
        for i, v in ipairs(self.callbacks) do
            v(self, self[isolatedValue], value)
        end
        self[isolatedValue] = value
    end,
    bind = function(self, callback)
        -- TODO: ADD TYPE CHECKING
        table.insert(self.callbacks, callback)
    end,
    unbind = function(self, pos)
        -- TODO: ADD TYPE CHECKING
        table.remove(self.callbacks, pos)
    end,
}

return function(initValue)
    local instance = {
        callbacks = {},
    }

    setmetatable(instance, {
        __index = Store,
        __call = function(self, value)
            if value ~= nil then
                self:set(value)
            else
                return self:get()
            end
        end,
    })

    instance:set(initValue)

    return instance
end