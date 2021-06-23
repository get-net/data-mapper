local dm = require("src")
local db = require("__test__.lua.database.db")

local linktype = dm.entity:new{
    db = db,
    schema = "three",
    table = "linktype",
    pk = "sid",
    fields = {
      sid = {
        type = 'string'
      },
      in_schema = {
        type = 'string'
      },
      in_table = {
        type = 'string'
      }
    }
}

return linktype
