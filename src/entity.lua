---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by norguhtar.
--- DateTime: 06.12.18 11:45
---

local schema = require('data-mapper.schema')
local field = require('data-mapper.field')
local relation = require('data-mapper.relation')

local entity = {
    schema = 'public',
    table = '',
    pk = 'id'
}

function entity:new(obj)
    obj = obj or {}

    if type(obj.fields) == 'table' then
        for key, value in pairs(obj.fields) do
            value.name = key
            obj.fields[key] = field:new(value)
        end
    end

    obj.relation = relation:new{entity = obj}

    setmetatable(obj, self)
    self.__index = self

    schema:add(obj)

    return obj
end

function entity:set_db(db)
    self.db = db
end

function entity:get_prefix(root)
    local prefix = string.sub(self.schema,1,1) .. string.sub(self.table,1,1)
    if root then
        return prefix
    end

    if not self.prefix then
        self.prefix = prefix
    end

    return self.prefix
end

function entity:set_prefix(prefix)
    self.prefix = prefix
    return self.prefix
end

function entity:get_field(name)
    for _, value in pairs(self.fields) do
        if name == value.name or name == value.alias then
            return value
        end
    end
end

function entity:get_foreign_link(table)
    for key, value in pairs(self.fields) do
        if value.foreign_key and value.table and value.table.table == table
        then
            return { table = value.table, used_key = key }
        end
    end
end

function entity:get_table()
    return string.format('%s.%s AS %s', self.schema, self.table, self:get_prefix())
end

function entity:get_col(name)
    name = name or self.pk
    return string.format("%s_%s", self:get_prefix(), name)
end

function entity:mapper(row)
    local res = {}
    local row_idx
    local idx
    for key, f in pairs(self.fields) do
        if not f.hide then
            row_idx = self.prefix .. '_' .. key
            idx = key
            if f.alias then
                row_idx = self.prefix .. '_' .. f.alias
                idx = f.alias
            end
            if row[row_idx:lower()] then
                res[idx] = row[row_idx:lower()]
            end
            if row[row_idx:upper()] then
                res[idx] = row[row_idx:upper()]
            end
        end
    end
    return res
end

function entity:select()
    return self.relation:select()
end

function entity:get(fields, force)
    if fields == nil and not force then
        return nil, error("can't get all from fields without force")
    end
    if self.db then
        local rel = self.relation:select():where(fields)
        return rel:mapper()
    end
end

function entity:get_by_field(field, value)
    local fields = {}
    if field == nil or value == nil then
        return nil, error("field or value can't be nil")
    end
    fields[field]=value
    return self:get(fields)
    end

function entity:get_by_pk(value)
    if not value then return nil, error("value can't be nil") end
    local list = self:get_by_field(self.pk, value)
    if next(list) then
        return list[1]
    end
end

function entity:add(fields)
    if not fields or not next(fields) then
        return nil, error("fields is empty")
    end
    local query = self.relation:insert(fields):build_sql()
    local res = self.db:query(query)
    if next(res) then
        return self:get_by_pk(res[1][self.pk])
    end
end

function entity:update(fields, filter_values)
    if filter_values and (type(filter_values) ~= "table" or type(filter_values) ~= "string" or filter_values~="") then
        return nil, error("filter must be table or string")
    end
    if not fields or not next(fields) then
        return nil, error("fields can't be empty")
    end
    local query = self.relation:update(fields):where(filter_values):build_sql()
    local res = self.db:query(query)
    if res and next(res) then
        return self:get_by_pk(res[1][self.pk])
    end
end

function entity:delete(fields, force)
    if not fields or not next(fields) or not force then
        return nil, error("can't run mass delete set force if you need this")
    end
    local query = self.relation:delete():where(fields):build_sql()
    local res = self.db:query(query)
    if res and next(res) then
        return res
    end
end

return entity
