local dm = require("src")
local db = require("__test__.lua.database.db")

local counterparty = require('__test__.lua.database.entity.two.counterparty')
local detailtype = require('__test__.lua.database.entity.two.detailtype')
local system = require('__test__.lua.database.entity.three.system')


local detail = dm.entity:new{
    db = db,
    schema = "two",
    table = "detail",
    pk = "uid",
    fields = {
        uid = {
            type = "string"
        },
        uid_counterparty = {
            type = "string",
            alias = "counterparty",
            foreign_key = true,
            table = counterparty,
            fetch = true
        },
        uid_detailtype = {
            type = "string",
            alias = "detailtype",
            foreign_key = true,
            table = detailtype,
            fetch = true
        },
        uid_system = {
            type = "string",
            alias  = "system",
            foreign_key = true,
            table = system
        },
        data = {
            type = "string"
        },
        tsfrom = {
            type = "string"
        },
        tsto = {
            type = "string"
        }
    }
}

return detail
