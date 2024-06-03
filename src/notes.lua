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
local VALID_PROPS     = {status=true, details=true, due=true, tags=true}
local PROP_CHARS      = '([%w%s%-_%.]+)'

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

local function consume_item(f)
    -- Reads the next NoteItem
    -- We've already consumed the name
    
    -- First: find a prop
    repeat
        local l = f:read('l')
        local prop_name = l:match(PROP_CHARS .. ':')
        print(prop_name)
    until true
end

local function read_note(path)
    local f = assert(io.open(path, 'r'))

    local type = f:read('l')

    assert(type == NOTES_DOCSTRING, "'"..path.."' is not a valid notes file")
    
    local notes_list = {}

    for l in f:lines() do
        local name = string.match(l, '%[' .. PROP_CHARS .. '%]')
        print(name)

        if name then
            local details, f = consume_item(f)
            notes_list[#notes_list + 1] = details
        end
    end

    return notes_list
end

notes.NoteItem = {__type = "Note"}

function notes.NoteItem.new()
    local self = setmetatable({}, {__index = notes.NoteItem})
    self.details = ""
    self.due = nil
    self.status = nil
    self.tags = {}
end

function notes.load(path)
    if note_exists(path) then
        return read_note(path)
    else
        return init_note(path)
    end
end

function notes.write(note_list, path)
    local f = assert(io.open(path, 'w'))

    f:write(NOTES_DOCSTRING .. '\n')
    
    for i, note in ipairs(note_list) do
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

return notes
