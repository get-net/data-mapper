local dm = require("src")
local db = require("__test__.lua.database.db")
local system = require("__test__.lua.database.entity.three.system")

local agent = dm.entity:new{
    schema = 'one',
    table = 'agent',
    pk = 'uid',
    db = db,
    fields = {
        uid = {
            type = 'string'
        },
        login = {
            type = 'string'
        },
        admin = {
            type = 'boolean',
            hide = true
        },
        uid_system = {
            type = 'string',
            alias = 'system',
            table = system,
            foreign_key = true,
            fetch = true
        }
    }
}

return agent
