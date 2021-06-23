local dm = require("src")
local db = require("__test__.lua.database.db")
local linktype = require("__test__.lua.database.entity.three.linktype")
local system = require("__test__.lua.database.entity.three.system")

local link = dm.entity:new{
    db = db,
    schema = "three",
    table = "link",
    pk = "uid",
    fields = {
      uid = {
        type = 'string',
      },
      sid_linktype = {
        type = 'string',
        alias = 'linktype',
        foreign_key = true,
        table = linktype,
        fetch = true
      },
      uid_system = {
        type = 'string',
        alias = 'system',
        foreign_key = true,
        table = system,
        fetch = true
      },
      tsfrom = {
        type = 'string',
      },
      tsto = {
        type = 'string',
      },
      tsupdate = {
        type = 'string',
      },
      ordr = {
        type = 'number',
      },
    }
}

return link
