package = "data-mapper"
version = "0.1-1"
source = {
	url = "git://github.com/get-net/data-mapper"
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
	"lua >=5.1, <5.3",
}
build = {
  type = "builtin",
  modules = {
    ["data-mapper.db"] = "src/db.lua",
    ["data-mapper.db.mysql"] = "src/db/mysql.lua",
    ["data-mapper.db.postgres"] = "src/db/postgres.lua",
    ["data-mapper.db.pg"] = "src/db/pg.lua",
    ["data-mapper.entity"] = "src/entity.lua",
    ["data-mapper.field"] = "src/field.lua",
    ["data-mapper.relation"] = "src/relation.lua",
    ["data-mapper.init"] = "src/init.lua"
  }
}
