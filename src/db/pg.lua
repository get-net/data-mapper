---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by norguhtar.
--- DateTime: 16.09.2019 15:45
---

local err, pg = pcall(require,"pg")

local _M = {}

function _M:new(obj)
    obj = obj or {}

    if not err then
        return nil
    end

    local config = obj.config
    if config then
        self.db = pg.connect({
            host = config.host,
            port = config.port,
            db = config.database,
            user = config.username,
            password = config.password
        })
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end


function _M:connect()
    local db = self.db

    if db then
        return db
    end
end

local function validate(val)
    local val_type = type(val)
    val = tostring(val)
    if not val:find('\"') then
        val = val:gsub("['\\]", {["'"] = "''", ["\\"] = "\\\\"})
    end
    if val_type == 'string' and val~='NULL' then
        val = "'" .. val .. "'"
    end
    return val
end


function _M:query(sql, ...)
    local db = self.db
    local params = {...}
    if params then
        for key,val in pairs(params) do
            params[key] = validate(val)
        end
    end

    sql = sql:gsub('%%','%%%%')

    local query = sql
    if #params then
        query = sql:gsub("?", "%%s")
        query = query:format(unpack(params))
    end

    if db:ping() then
        local res = db:execute(query)
        if next(res) then
            return res[1]
        end
    end
end

function _M:begin()
    _M:query("rollback")
    _M:query("begin")
end

function _M:commit()
    _M:query("commit")
end

function _M:rollback()
    _M:query("rollback")
end

function _M:disconnect()
    local db = self.db
    db:close()
end


return _M