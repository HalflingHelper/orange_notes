-- Working with slice files
--
-- A slice is simplay a plain text file, with the .slice file extension. There
-- are a number of notable parts of the file. The file format is intended as a
-- subset of toml.
--
-- #!ORANGE_SLICE
--
-- Then Each of the Items
-- [Name]
-- status = ___
-- details = ___
-- due = ___
-- tags = ___
local notes = require 'src/notes'

local slice = {}

local SLICE_DOCSTRING = '!ORANGE_SLICE'
local NAME_CHARS      = '[%w%s%-_%.]+'

local function slice_exists(path)
    local f = io.open(path, 'r')

    if (f == null) then return false end
    local type = f:read('l')

    f:close()

    return type == SLICE_DOCSTRING
end

local function init_slice(path)
    -- This will overwrite any slices file at the path
    local f = assert(io.open(path, 'w'))

    io.write('Creating a new slice \'' .. path .. '\'.\n')

    f:write(SLICE_DOCSTRING)

    f:close()

    return {}
end

local function read_slice(path)
    local f = assert(io.open(path, 'r'))

    local type = f:read('l')

    assert(type == SLICE_DOCSTRING, "'"..path.."' is not a valid slices file")
    
    local slices_list = {}

    for l in f:lines() do
        local name = string.match(l, '%[(' .. NAME_CHARS .. ')%]')
        print(name)

        if name then
            local details, f = notes.consume_item(f, name)
            slices_list[#slices_list + 1] = details
        end
    end

    return slices_list
end

function slice.load(path)
    if slice_exists(path) then
        return read_slice(path)
    else
        return init_slice(path)
    end
end

function slice.write(notes_list, path)
    local f = assert(io.open(path, 'w'))

    f:write(SLICE_DOCSTRING .. '\n')
    
    for i, note in ipairs(notes_list) do
       f:write('[' .. note.name .. ']\n')
       f:write('\tdetails: ' .. note.details .. '\n')
       f:write('\tstatus: ' .. note.status .. '\n')
       f:write('\tdue: ' .. note.due .. '\n')
       f:write('\ttags: ')
       for j, tag in ipairs(note.tags) do
           io.write(tag)
           io.write(',')
       end
       io.write('\n\n')
    end
end

return slice

