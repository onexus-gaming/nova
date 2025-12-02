local function noop(...) end

---class to manage global and individual configurations, with support for backups, upgrading and downgrading
---@class Config
local Config = Object:extend()

---initialize a new configuration handler
---@param configData table {file: string, version: number, onUpgrade: function(self, storedVersion: number) -> nil, onDowngrade: function(self, storedVersion: number) -> nil, defaults: table}
function Config:new(configData)
    self._file = configData.file
    self._version = configData.version
    self._onUpgrade = configData.onUpgrade or noop
    self._onDowngrade = configData.onDowngrade or noop
    self._defaults = configData.defaults

    self:load()
end

---Initialize the default configuration at the save location.
function Config:init()
    self.options = self._defaults
    self:save()
end

-- TODO: backup autoload
---Load the configuration from the save location.
function Config:load()
    self.options = {}
    local info = love.filesystem.getInfo(self._file)

    if info == nil then
        self:init()
    elseif info.type == 'file' then
        local contents, size = love.filesystem.read(self._file)
        local results, len = binser.deserialize(contents)
        self.options = results[1].options

        --print('loaded config version', results[1].version, 'with set version', self._version)
        if results[1].version < self._version then
            self:_onUpgrade(results[1].version)
        elseif results[1].version > self._version then
            self:_onDowngrade(results[1].version)
        end
    else
        error("attempted to load config from " .. info.type, 2)
    end
end

---Save the configuration to the save location.
---@param outfile string? path to override the default save location
function Config:save(outfile)
    if outfile == nil then
        outfile = self._file
    end
    local success, message = love.filesystem.write(outfile, binser.serialize({
        version = self._version,
        options = self.options,
    }))

    if not success then
        error(message, 2)
    end
end

---Save a backup of the configuration close to the save location (<save location>.bak).
function Config:backup()
    self:save(self._file .. '.bak')
end

---Retrieve the save location.
---@return string
function Config:file()
    return self._file
end

---Retrieve the expected configuration version.
---@return number
function Config:version()
    return self._version
end

---Retrieve a configuration values
---@param key any the key to retrieve the value from
---@return any
function Config:get(key)
    return self.options[key]
end

---Get the default value for a given keys.
---@param key any the key to retrieve the value from
---@return any
function Config:default(key)
    return self._defaults[key]
end

---Set the value for a given key.
---@param key any the key to set the value of
---@param value any the new value
function Config:set(key, value)
    self.options[key] = value
end

return Config