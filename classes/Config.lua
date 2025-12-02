local function noop(...) end

---class to maage global and individual configurations, with support for backups, upgrading and downgrading
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

function Config:init()
    self.options = self._defaults
    self:save()
end

-- TODO: backup autoload
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

function Config:backup()
    self:save('bak.' .. self._file)
end

function Config:file()
    return self._file
end

function Config:version()
    return self._version
end

function Config:get(key)
    return self.options[key]
end

function Config:default(key)
    return self._defaults[key]
end

function Config:set(key, value)
    self.options[key] = value
end

return Config