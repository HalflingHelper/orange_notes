-- Defining the data structure and properties of notes, reading and writing
-- from toml.

local notes = {}

local VALID_PROPS     = {status=true, details=true, due=true, tags=true}
local PROP_CHARS      = '[%a_]+'

notes.NoteItem = {__type = "Note"}

function notes.NoteItem.new()
    local self = setmetatable({}, {__index = notes.NoteItem})
    self.name = ""
    self.details = ""
    self.due = nil
    self.status = nil
    self.tags = {}
end

function notes.NoteItem:toTomlString()
    return '[' .. self.name .. ']\n' ..
           self.details and 'details: ' .. self.details .. '\n' or '' ..  
           self.due and 'due: ' .. self.due .. '\n' or '' ..  
           self.status and 'status: ' .. self.status .. '\n' or '' ..  
           self.tags and 'tags: ' .. self.tags .. '\n' or '' 
end

-- TODO: Concert is passing the file hear. Maybe some better way to load from TOML?
function notes.consume_item(f, name)
    -- Reads the next NoteItem
    -- We've already consumed the name
   local item = notes.NoteItem.new()
   item.name = name
    -- First: find a prop
    repeat
        local l = f:read('l')
        local prop_name = l:match('(' .. PROP_CHARS .. '):')
        if prop_name and VALID_PROPS[prop_name] then
            item[prop_name] = 1
        end
    until true
    return item
end

return notes
