local config = require 'src/config'
local slice  = require 'src/slice'


io.write("Orange Version 0.0.0.1\n")
io.write("Press Ctrl+C to Exit\n\n")

-- Look for .orange_config
local user_settings = config.load()

-- Ask which of the available files to pick.
local index 

repeat 
    io.write('0. Create new slice.\n')
    
    for i, f in ipairs(user_settings.files) do
        io.write(i .. '. ' .. f .. '\n')
    end

    io.write('Choose a slice: ')
    index = tonumber(io.read())
until index ~= nil and index >= 0 and index <= #user_settings.files 

if index == 0 then
    -- start the creation process    
    io.write('Enter the name of the slice to create: ')
    local path = io.read()
    
    slice.load(path .. '.orng')
elseif index > #user_settings.files then
    print('Invalid choice')
else
    slice.load(user_settings.files[index] .. '.orng')
end
