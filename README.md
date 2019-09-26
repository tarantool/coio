# COIO

[![Build Status](https://travis-ci.com/tarantool/coio.svg?branch=master)](https://travis-ci.com/tarantool/coio)

Lua wrapper for tarantool's `coio_*` functions.

## Install

```
tarantoolctl rocks install coio
```

or add `coio` to `dependencies` section in rockspec.

## Usage

```lua
local coio = require('coio')

coio.wait(fd, events, timeout)
-- - `fd` can be a file descriptor, `fio` or `io` object.
-- - `events` can be given as `coio.events.READ`, `coio.events.WRITE`.
--   It also supports `'READ'` & `'WRITE'`, and `{'READ', 'WRITE'}` combination.

coio.close(fd)
-- Same as for `wait`.
```

## License

MIT
