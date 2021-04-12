local entity = require('entity')
local cond = require("cond")

local agent = entity:new{
    schema = 'oauth',
    table = 'agent',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        login = {
            type = 'string'
        },
        password = {
            type = 'string'
        },
        verified = {
            type = 'boolean'
        },
        status = {
            type = 'boolean'
        },
        admin = {
            type = 'boolean'
        },
        salt = {
            type = 'string'
        },
        sid_hashtype = {
            type  = 'string',
            alias = 'hashtype'
        }
    }
}


local client = entity:new{
    schema = 'oauth',
    table = 'client',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        name = {
            type = 'string'
        },
        secret = {
            type = 'string'
        },
        client_redirect_uri = {
            type = 'string'
        },
        status = {
            type = 'boolean'
        },
    }
}

local token = entity:new{
    schema = 'oauth',
    table = 'token',
    pk = 'uid',
    fields = {
        uid = {
            type = 'string'
        },
        uid_client = {
            type = 'string',
            alias = 'client',
            foreign_key = true,
            table = client
        },
        access = {
            type = 'string'
        },
        refresh = {
            type = 'string'
        },
        tscreate = {
            type = 'string'
        },
        expires_in = {
            type = 'number'
        },
        uid_agent = {
            type = 'string',
            alias = "agent",
            foreign_key = true,
            table = agent
        },
        code = {
            type = 'string'
        },
        uid_service = {
            type = 'string',
            alias = 'service'
        }
    }
}

local access="3009c18bf5090cbf4ecada5d349cb6d6ebda124445a1d5dd005e50b9c344be01"

local test = cond:_and(
        { token, access = { op = 'IN', value = { access, 'test' } } },
        cond:_or(
                { tscreate = "now() - (expires_in || ' sec')::INTERVAL", ">=" },
                {token, expires_in = -1 }),
        { client, status = true }
)
--local sql = token:select():join(client):where(
--       )
print(string.format("SQL:[%s]", test))
