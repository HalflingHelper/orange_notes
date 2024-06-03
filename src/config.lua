-- Module for working with the config file

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
        local k, v = string.match(l, '(%a+) = (.+)')

        if k == 'username' then
            name = v
        elseif k == 'count' then
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

return config
