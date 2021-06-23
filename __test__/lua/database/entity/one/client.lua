local dm = require("src")
local db = require("__test__.lua.database.db")

local client = dm.entity:new{
    schema = 'one',
    table = 'client',
    pk = 'uid',
    db = db,
    fields = {
        uid = {
            type = 'string'
        },
        name = {
            type = 'string'
        },
        secret = {
            type = 'string'
        },
        status = {
            type = 'boolean'
        },
    }
}

return client
