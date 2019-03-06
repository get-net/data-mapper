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
	"pgmoon",
	"luasql-mysql"
}
build = {
  type = "builtin",
  modules = {
    ["data-mapper.db"] = "db.lua",
    ["data-mapper.db.mysql"] = "db/mysql.lua",
    ["data-mapper.db.postgres"] = "db/postgres.lua",
    ["data-mapper.entity"] = "core/entity.lua",
    ["data-mapper.field"] = "core/field.lua",
    ["data-mapper.relation"] = "core/relation.lua"
  }
}
