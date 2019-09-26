#include <lauxlib.h>
#include <tarantool/module.h>

static int
lua_coio_wait(struct lua_State *L)
{
    int fd = luaL_checkint(L, 1);
    int event = luaL_checkint(L, 2);
    long timeout = luaL_checklong(L, 3);
    lua_pushinteger(L, coio_wait(fd, event, timeout));
    return 1;
}

static int
lua_coio_close(struct lua_State *L)
{
    int fd = luaL_checkint(L, 1);
    lua_pushinteger(L, coio_close(fd));
    return 1;
}

#define SET_TABLE_KEY(key, method, value) { \
    lua_push##method(L, value);             \
    lua_setfield(L, -2, key);               \
}

LUA_API int
luaopen_coio_ext(lua_State *L)
{
    lua_newtable(L); {
        SET_TABLE_KEY("wait", cfunction, lua_coio_wait);
        SET_TABLE_KEY("close", cfunction, lua_coio_close);

        lua_newtable(L); {
            SET_TABLE_KEY("READ", integer, COIO_READ);
            SET_TABLE_KEY("WRITE", integer, COIO_WRITE);
        }
        lua_setfield(L, -2, "events");
    }
    return 1;
}
