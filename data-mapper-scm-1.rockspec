package = "data-mapper"
version = "scm-1"
source = {
   url = "git+ssh://git@github.com/get-net/data-mapper.git"
}
description = {
    summary = "Data mapper for lua",
    detailed = [[
        Lightweight data mapper for lua, support mysql and postgresql backend
    ]],
    homepage = "https://github.com/get-net/data-mapper",
    license = "GPLv2"
}
dependencies = {
   "lua ~> 5.1, <5.3"
}
build = {
  type = "builtin",
  modules = {
    ["data-mapper.db"] = "src/db.lua",
    ["data-mapper.db.mysql"] = "src/db/mysql.lua",
    ["data-mapper.db.postgres"] = "src/db/postgres.lua",
    ["data-mapper.db.lapis"] = "src/db/lapis.lua",
    ["data-mapper.db.pg"] = "src/db/pg.lua",
    ["data-mapper.entity"] = "src/entity.lua",
    ["data-mapper.cond"] = "src/cond.lua",
    ["data-mapper.schema"] = "src/schema.lua",
    ["data-mapper.field"] = "src/field.lua",
    ["data-mapper.relation"] = "src/relation.lua",
    ["data-mapper.init"] = "src/init.lua"
  }
}
