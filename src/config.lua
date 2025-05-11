-- Module for working with the config file

-- { username = string, files = {} }
local config = {}

local CONFIG_PATH = '.orange_config'
local CONFIG_DOCSTRING = '!ORANGE_CONFIG'

local function config_exists()
    local f = io.open(CONFIG_PATH, 'r')

    if (f == null) then return false end

    local type = f:read('l')
    f:close()

    return type == CONFIG_DOCSTRING
end

local function init_details()
    -- This will overwrite any malformed config file
    local f = assert(io.open(CONFIG_PATH, 'w'))
    
    io.write('A config file \'' .. CONFIG_PATH .. '\' could not be found.\n')
    io.write('Please provide the following information to get started.\n\n')

    io.write('Name: ')
    local name = io.read()

    io.write('Todos Name: ')
    local fname = io.read()

    f:write(CONFIG_DOCSTRING)
    f:write('\n\nusername = ' .. name)
    f:write('\nfile_count = 1\n')
    f:write(fname)

    f:close()

    return { username=name, files={fname}}
end

local function read_details()
    local f = assert(io.open(CONFIG_PATH, 'r'))

    local name, files = "", {}

    for l in f:lines() do
        local k, v = string.match(l, '([%a_]+) = (.+)')

        if k == 'username' then
            name = v
        elseif k == 'file_count' then
            for i = 1, tonumber(v) do
                files[#files+1] = f:read("l")
            end
        end
    end

    f:close()
    
    return { username = name, files = files }
end

function config.load()
    if config_exists() then
        return read_details()
    else
        return init_details()
    end
end

function config.add_slice(cfg, name)
    -- Add a file to an active config file
    cfg.files[#cfg.files+1] = name
    return cfg
end

function config.save(cfg)
    -- Write out the given file to the config path
    local f = assert(io.open(CONFIG_PATH, 'w'))

    f:write(CONFIG_DOCSTRING .. '\n\n')
    f:write('username = ' .. cfg.username .. '\n')
    f:write('file_count = ' .. #cfg.files .. '\n')
    for _, file in ipairs(cfg.files) do
        f:write(file .. '\n')
    end
end

return config
