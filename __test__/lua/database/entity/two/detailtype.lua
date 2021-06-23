local dm = require("src")
local db = require("__test__.lua.database.db")

local counterparty = require('__test__.lua.database.entity.two.counterparty')

local detailtype = dm.entity:new{
    db = db,
    schema = 'two',
    table = 'detailtype',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        name = {
            type = 'string'
        },
        data = {
            type = 'string'
        },
        description = {
            type = 'string'
        },
        uid_counterparty = {
            type = 'string',
            alias = 'counterparty',
            foreign_key = true,
            table = counterparty
        },
    }
}

return detailtype
