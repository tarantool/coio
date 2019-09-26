local t = require('luatest')
local g = t.group('coio')

local coio = require('coio')
local fiber = require('fiber')
local fio = require('fio')

g.test_wait = function()
    t.assert_equals(coio.wait(0, coio.events.READ, 0.05), 0)
    t.assert_equals(coio.wait(0, 'READ', 0.05), 0)
    t.assert_equals(coio.wait(1, 'WRITE', 0.05), coio.events.WRITE)

    t.assert_equals(coio.wait(io.stdin, 'READ', 0.05), 0)
    t.assert_equals(coio.wait(io.stdout, 'WRITE', 0.05), coio.events.WRITE)

    local f = fio.open('Makefile')
    t.assert_equals(coio.wait(f, 'READ', 0.5), coio.events.READ)
    t.assert_equals(coio.wait(f, 'WRITE', 0.5), coio.events.WRITE)
    t.assert_equals(coio.wait(f, {'READ', 'WRITE'}, 0.5),
        bit.bor(coio.events.WRITE, coio.events.READ))
end

g.test_wait_concurrent = function()
    local STDIN_FD = 0
    local fibers = {}
    for _ = 1, 10 do
        local f = fiber.new(function()
            for _ = 1, 10 do
                coio.wait(STDIN_FD, coio.events.READ, 0.05)
                fiber.testcancel()
            end
        end)
        f:set_joinable(true)
        table.insert(fibers, f)
    end
    for _, f in pairs(fibers) do
        f:join()
    end
end

g.test_close = function()
    local f = fio.open('Makefile')
    t.assert_equals(coio.close(f), 0)
    f = fio.open('Makefile')
    t.assert_equals(coio.close(f.fh), 0)
end

g.test_parse_event = function()
    t.assert_equals(coio.parse_event(53), 53)
    t.assert_equals(coio.parse_event('READ'), coio.events.READ)
    t.assert_equals(coio.parse_event('WRITE'), coio.events.WRITE)
    t.assert_equals(coio.parse_event({'READ'}), coio.events.READ)
    t.assert_equals(coio.parse_event({'READ', 'WRITE'}),
        bit.bor(coio.events.READ, coio.events.WRITE))
    t.assert_equals(coio.parse_event({'READ', 12}), bit.bor(coio.events.READ, 12))
end

g.test_parse_fd = function()
    t.assert_equals(coio.parse_fd(3), 3)
    local f = fio.open('Makefile')
    t.assert_equals(coio.parse_fd(f), f.fh)
    t.assert_equals(coio.parse_fd(io.stdin), 0)
    t.assert_equals(coio.parse_fd(io.stdout), 1)
end
