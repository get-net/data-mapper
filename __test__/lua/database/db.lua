local dm = require('src')

local config = {
    driver      = "tarantool-pg",
    host        = 'localhost',
    port        = 9432,
    username    = 'datamapper',
    password    = 'datamapper',
    database    = 'datamapper',
    size        = 2,
}
return dm.db:new({config = config})
