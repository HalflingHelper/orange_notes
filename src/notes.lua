-- Working with notes files
--
-- An orange notes file is a plain text file, typically with the .orng file
-- extension. There are a number of parts of this file that are important.
--
-- # The first line
-- !ORANGE_NOTES # This delineates the file as being an orange notes file.
--
-- Then each of items with additional meta details
-- [Name]
--      status: 
--      details:
--      due:
--      tags:

local notes = {}

local NOTES_DOCSTRING = '!ORANGE_NOTES'

local function note_exists(path) 
    local f = io.open(path, 'r')

    if (f == null) then return false end
    
    local type = f:read('l')
    f:close()

    return type == NOTES_DOCSTRING
end

local function init_note(path)
    -- This will overwrite any notes file at the path
    local f = assert(io.open(path, 'w'))

    io.write('Creating a new note \'' .. path .. '\'.\n')

    f:write(NOTES_DOCSTRING)

    f:close()

    return {}
end

local function read_note(path)
    local f = assert(io.open(path, 'r'))

    local type = f:read('l')

    assert(type == NOTES_DOCSTRING, "'"..path.."' is not a valid notes file")
    
    for l in f:lines() do
        local name = string.match(l, '%[(%w%s%-_%.)%]')
        print(name)

        -- local details, f = consume_details(f)
    end
end

function notes.load(path)
    if note_exists(path) then
        return read_note(path)
    else
        return init_note(path)
    end
end

return notes
