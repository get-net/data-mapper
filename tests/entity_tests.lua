

local dm = require('data-mapper.init')
local config = require('config')

-- local db = dm.db:new(config)

local first = dm.entity:new{
    schema = 'test',
    table = 'first',
    pk = 'id',
    fields = {
        id = {
            type = 'number'
        },
        firstfield = {
            type = 'string'
        },
    }
}

local second = dm.entity:new{
    schema = 'test',
    table = 'second',
    pk = 'id',
    fields = {
        id = {
            type = 'number'
        },
        secondfield = {
            type = 'string'
        },
    }
}


local first_second = dm.entity:new{
    schema = 'test',
    table = 'first_second',
    pk = 'id',
    fields = {
        id = {
            type = 'number'
        },
        id_first = {
            type = 'number',
            alias = 'first',
            foreign_key = true,
            table = first
        },
        id_second = {
            type = 'number',
            alias = 'second',
            foreign_key = true,
            table = second
        },
        tsfrom = {
            type = 'string'
        },
        tsto = {
            type = 'string'
        }
    }
}

local sql =  first_second:select():join('first', {type='many', id='id', fkey='id_first'}):build_sql()
print(string.format("SQL:[%s]", sql))
local sql =  first:select():join(first_second, {type='many', id='id', fkey='id_first'}):build_sql()
print(string.format("SQL:[%s]", sql))