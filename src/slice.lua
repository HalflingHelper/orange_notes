-- Working with slice files
--
-- A slice is simply a plain text file, with the .slice file extension. There
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

-- { name=string, items={ NoteItem } }
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

    return { name=path, items={} }
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

    return { name=path, items=slices_list }
end

function slice.load(path)
    if slice_exists(path) then
        return read_slice(path)
    else
        return init_slice(path)
    end
end

function slice.menu(display_slice)
    io.write("Slice: " .. display_slice.name .. "\n")
    io.write("1. View all\n")
    io.write("2. Filter\n")
    io.write("3. Add\n")
    io.write("4. Save and Close\n")

    local i = tonumber(io.read())

    if i == 1 then
       for i, note in ipairs(display_slice.items) do
          io.write(note.name .. " - " .. note.details .. "\n\n")
       end
    elseif i == 2 then
       io.write("Enter tag(s): ")
       local tag = io.read()
       -- TODO: Run a filter for each space-separated tag
    elseif i == 3 then
        -- TODO: Defaults
       io.write("Enter name: ")
       local name = io.read()
       io.write("Enter details: ")
       local details = io.read()
       io.write("Enter due date: ")
       local due = io.read()

       local new_item = { name=name, details=details, due=due, tags={}, status='none' }

       table.insert(display_slice.items, new_item)

       io.write("Successfully added!\n")
    elseif i == 4 then
       slice.write(display_slice.items, display_slice.name)
       return
    else
       io.write("Invalid option.\n")
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

