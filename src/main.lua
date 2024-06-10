local config = require 'src/config'
local slice  = require 'src/slice'


io.write("Orange Version 0.0.0.1\n")
io.write("Press Ctrl+C to Exit\n\n")

-- Look for .orange_config
local user_settings = config.load()

-- Ask which of the available files to pick.
local index 
local loaded_slice, active_path

repeat 
    io.write('0. Create new slice.\n')
    
    for i, f in ipairs(user_settings.files) do
        io.write(i .. '. ' .. f .. '\n')
    end

    io.write('Choose a slice: ')
    index = tonumber(io.read())

    if index == nil or index < 0 or index > #user_settings.files then
        io.write('Invalid choice\n')
    elseif index == 0 then
        -- start the creation process    
        io.write('Enter the name of the slice to create: ')
        local path = io.read()
        active_path = path .. '.orng'
        -- TODO: Ensure path is valid for filesystem 
        config.add_slice(user_settings, path)
        loaded_slice = slice.load(active_path)
    else
        active_path = user_settings.files[index] .. '.orng'
        loaded_slice = slice.load(active_path)
    end
until index ~= nil and index >= 0 and index <= #user_settings.files 

repeat
    slice.menu(loaded_slice)
until true

-- Exit sequence
slice.write(loaded_slice, active_path)
config.save(user_settings)
