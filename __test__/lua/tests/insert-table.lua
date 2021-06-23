require 'busted.runner'()
local dm = require'__test__.lua.database.entity'

describe("insert records into tables", function()
    describe("should insert no relation table", function()
        it('insert into table "client", schema "one"', function()
            local client, err = dm.client:add({name = 'client_name', secret = 'client_secret',  status = true})
            assert.are.equals(type(client), 'table')
            assert.are.equals(err, nil)

            dm.client:delete({ uid = client.uid}, {force = true })
        end )
    end)

    describe("should insert relation table", function()
        it('insert into table "linktype", "system" and "link", schema "one"', function()
            local linktype, linktype_err = dm.linktype:add({sid = 'linktype_sid', in_schema = 'in_schema',  in_table = 'in_table',})
            local system, system_err = dm.system:add({name = 'system_name', ip = '192.068.0.1'})

            local link, link_err = dm.link:add({sid_linktype = linktype.sid, uid_system = system.uid, ordr = 1})

            assert.are.equals(type(linktype), 'table')
            assert.are.equals(linktype_err, nil)

            assert.are.equals(type(system), 'table')
            assert.are.equals(system_err, nil)

            assert.are.equals(type(link), 'table')
            assert.are.equals(link_err, nil)

            dm.link:delete({ uid = link.uid}, {force = true })
            dm.linktype:delete({ sid = linktype.sid}, {force = true })
            dm.system:delete({ uid = system.uid}, {force = true })
        end )
    end)
end)

describe('update record', function()
    it('update record in table', function()
        local client, err = dm.client:add(
                {
                    name   = 'client_before_update',
                    secret = 'client_secret_before_update',
                    status = true
                }
        )

        local client_updated, client_updated_err = dm.client:update(
                { name   = 'client_after_update' },
                { uid = client.uid }
        )
        assert.are.equals(client_updated.name, 'client_after_update')
        dm.client:delete({ uid = client.uid}, {force = true })
    end)
end)
