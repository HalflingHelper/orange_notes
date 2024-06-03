local config = require 'src/config'
local notes  = require 'src/notes'


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

if index == "0" then
    -- start the creation process    
elseif index > #user_settings.files then
    print('Invalid choice')
else
    notes.load(user_settings.files[index] .. '.orng')
end
