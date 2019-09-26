local ffi = require('ffi')

ffi.cdef([[
    int fileno(struct FILE *stream);
]])

local ext = require('coio.ext')
local export = table.copy(ext)

function export.parse_fd(fd)
    -- fio
    if type(fd) == 'table' and fd.fh then
        return fd.fh
    -- io
    elseif type(fd) == 'userdata' and type(fd.read) == 'function' then
        return ffi.C.fileno(fd)
    else
        return fd
    end
end

function export.parse_event(event)
    if type(event) == 'table' then
        local result = 0
        for _, item in pairs(event) do
            result = bit.bor(result, export.parse_event(item))
        end
        return result
    elseif type(event) == 'string' then
        return ext.events[event] or error('Invalid event name: ' .. event)
    else
        return event
    end
end

function export.wait(fd, event, timeout)
    return ext.wait(export.parse_fd(fd), export.parse_event(event), timeout)
end

function export.close(fd)
    return ext.close(export.parse_fd(fd))
end

return export
