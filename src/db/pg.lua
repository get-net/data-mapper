---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by norguhtar.
--- DateTime: 16.09.2019 15:45
---

local drv_status, pg = pcall(require,"pg")

local _M = {}

function _M:new(obj)
    obj = obj or {}

    if not drv_status then
        return error("pg module not found, please install it: tarantoolctl rocks install pg")
    end

    local config = obj.config
    if config then
        -- default pool size is set to 1
        obj.config.size = config.size or 1
        self.db = pg.pool_create({
            host     = config.host,
            port     = config.port,
            db       = config.database,
            user     = config.username,
            password = config.password,
            size     = config.size,
            timeout  = config.timeout
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
    if not self.db or not self.db.usable then
        error("pool's closed")
    end

    local conn = self.db:get()
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
        query = query:format(_G.unpack(params))
    end

    local ping_stat, ping = pcall(conn.ping, conn)
    if ping_stat and ping then
        local status, res = pcall(conn.execute, conn, query)
        -- just put the connection back, no matter what
        self.db:put(conn)
        if status and next(res) then
            return res[1]
        end
    end
    self.db:put(conn)
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
    if not self.db or not self.db.usable then
        error("already disconnected")
    end

    return self.db:close()
end


return _M
