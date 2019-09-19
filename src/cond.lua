---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by norguhtar.
--- DateTime: 18.09.2019 15:56
---

local cond = {}
local inspect = require("inspect")
local schema = require("data-mapper.schema")


local function get_str(params)

    local name
    local value
    local entity
    local prefix = ""
    local op = "="
    local res = params


    if type(params) == 'table' then
        for k, param in pairs(params) do
            if k == 1 then
                if type(param) == 'table' then
                    entity = param
                    prefix = param:get_prefix() .. "."
                else
                    op = param
                end
            end
            if k == 2 then
                op = param
            end
        end
        for k, param in pairs(params) do
            if type(k) == 'string' then
                name = k
                if param == 'NULL' then
                    op = 'IS'
                end
                if entity then
                    local field = entity:get_field(k)
                    value = field:get_value(param)
                else
                    value = param
                end
            end
        end
        res = string.format("%s%s %s %s", prefix, name, op, value)
    end

    return res
end

function cond:new(obj)
    obj = obj or {}

    obj.tree = {}
    obj.sql = {}

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function cond:op(op, params)
    local res = ""
    for _,val in pairs(params) do
        if res == "" then
            res = "("
        else
            res = string.format(" %s %s ", res, op)
        end
        res = res .. get_str(val)
    end
    if res ~= "" then
        res = res .. ")"
    end
    return res
end

function cond:_and(...)
    return self:op('AND', {...})
end

function cond:_or(...)
    return self:op('OR', {...})
end

return cond