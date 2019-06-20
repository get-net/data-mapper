

local dm = require('data-mapper.init')
local config = require('config')

local counterpartytype = dm.entity:new{
    schema = 'client',
    table = 'counterpartytype',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        name = {
            type = 'string'
        }
    }
}

local section = dm.entity:new{
    schema = 'client',
    table = 'section',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        name = {
            type = 'string'
        },
        uid_counterpartytype = {
            alias = 'counterpartytype',
            type = 'string',
            foreign_key = true,
            table = counterpartytype
        },
        ordr = {
            type= 'string'
        }
    }
}

local detailtype = dm.entity:new{
    schema = 'client',
    table = 'detailtype',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        name = {
            type = 'string'
        },
        data = {
            type = 'string'
        }
    }

}

local section_detailtype = dm.entity:new{
    schema = 'client',
    table = 'section_detailtype',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        uid_section = {
            type = 'string',
            alias = 'section',
            foreign_key = true,
            table = section
        },
        uid_detailtype = {
            type = 'string',
            alias= 'detailtype',
            foreign_key = true,
            table = detailtype
        },
        ordr = {
            type = 'number'
        }
    }
}

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
    table = 'fsecond',
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

--local sql = section:select():join(section_detailtype, { type="many", link=section_detailtype})
--                   :where({uid_counterpartytype= '40758ed0-d1e8-11e8-ba29-3f106df57ce2'}):build_sql()
local sql = section:select():join(section_detailtype, { type="many", link=section_detailtype})
         :where({uid_counterpartytype= '40758ed0-d1e8-11e8-ba29-3f106df57ce2'}):build_sql()
print(string.format("SQL:[%s]", sql))