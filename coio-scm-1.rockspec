package = 'coio'
version = 'scm-1'
source  = {
    url = 'git://github.com/tarantool/coio.git',
    branch = 'master',
}
-- Put any modules your app depends on here
dependencies = {
    'tarantool',
    'lua >= 5.1',
}
build = {
    type = 'builtin',
    modules = {
        coio = 'coio/init.lua',
        ['coio.ext'] = 'coio/ext.c',
    },
}
