local dm = require("src")
local db = require("__test__.lua.database.db")

local agent = require('__test__.lua.database.entity.one.agent')

local counterparty = dm.entity:new{
    schema = 'two',
    table = 'counterparty',
    pk = 'uid',
    db = db,
    fields = {
        uid = {
            type = 'string'
        },
        name = {
            type = 'string'
        },
        uid_agent = {
            alias = 'agent',
            type = 'string',
            foreign_key = true,
            table = agent,
            fetch = true
        },
    }
}

return counterparty
