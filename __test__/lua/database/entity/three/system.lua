local dm = require("src")
local db = require("__test__.lua.database.db")

local system = dm.entity:new{
    db = db,
    schema = "three",
    table = "system",
    pk = "uid",
    fields = {
        uid = {
            type = "string"
        },
        name = {
            type = "string"
        },
        ip = {
            type = "string"
        }
    }
}

return system
