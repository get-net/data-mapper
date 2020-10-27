---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by norguhtar.
--- DateTime: 23.01.19 15:52
---

local field = {
    primary_key = false
}

local function escape_string(value)
   return value:gsub("['\\]", {["'"] = "''", ["\\"] = "\\\\"})
end

local function get_value(val_type, value)
    if val_type == 'string' then
        local str_value = escape_string(tostring(value))
        if  str_value == 'NULL' then
            return str_value
        end
        if string.len(str_value)>0 then
            return string.format("'%s'", str_value)
        end
    elseif val_type == 'number' then
        local int_value = tonumber(value)
        if int_value then
            return value
        end
    elseif val_type == 'boolean' then
        local bool_value
        if type(value) == 'boolean' then
            bool_value = tostring(value)
        elseif type(value) == 'string' then
            if string.lower(value) == 'true' or value == '1' then
                bool_value = 'TRUE'
            else
                bool_value = 'FALSE'
            end
        elseif type(value) == 'number' then
            if value then
                bool_value = 'TRUE'
            else
                bool_value = 'FALSE'
            end
        end
        return string.format("%s", bool_value)
    end
end

function field:new(obj)
    obj = obj or {}

    setmetatable(obj, self)
    self.__index = self
    return obj
end

function field:get_fkey_json()
    if self.type == 'foreign_key' then
        if string.len(self.table) > 0 then

        end
    else
        return ''
    end
end

function field:get_value(value)
    if value == nil then
        return 'NULL'
    end
    if type(value) == 'table' then
        local list = {}
        for _,item in pairs(value) do
            table.insert(list, get_value(self.type, item))
        end
        if next(list) then
            return string.format("(%s)", table.concat(list,","))
        end
    else
        return get_value(self.type, value)
    end
end

function field:get_filter(value)
    if not value then
        return ''
    end
    return string.format("%s=%s", self.name,  self:get_value(value))
end

return field
