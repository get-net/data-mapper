# data-mapper

Data mapper for lua

## Contents

[API](#api)

- [Entity](#entity)
- [Field](#field)
- [Relation](#relation)
- [Condition](#condition)
- [Limit](#limit)
- [Order](#order)
[Dependencies](#dependencies)

[Usage](#usage)

## Dependencies

- [Pgmoon](https://github.com/leafo/pgmoon "Pgmoon github")
- [LuaSQL](https://keplerproject.github.io/luasql/index.html "LuaSQL home page")

## API

### Entity

Entity - use for description table in database. For example

```lua
local db = require("data-mapper.db"):new{
        config = {
            driver = "postgres",
            host = "localhost",
            port = "5432",
            user = "test",
            password = "testpw",
            database = "test",
            -- optional parameter for tarantool-db driver only. default value is 1
            size = 2
        }
    }
local entity = require('data-mapper.entity')

local testtype = entity:new{
    table = 'testtype',
    pk = 'sid',
    db = db,
    fields = {
        sid = {
            type = 'string'
        },
        name = {
            type = 'string'
        }
    }
}

local test = entity:new{
    table = 'test',
    pk = 'id',
    db = db,
    fields = {
        id = {
            type = 'number'
        },
        sid_testtype = {
                alias ='testtype',
                type = 'string',
                foreign_key = true,
                table = testtype
        },
        name = {
            type = 'string'
        },
        dt = {
            type = 'string'
        },
        balance = {
            type = 'number'
        }
    }
}
```

In entity you can define properties:

- **schema** - table schema. If not defined used _public_
- **table** - table name
- **pk** - table primary key. If not defined used _id_
- **prefix** - used table prefix. If not defined used first char from _schema_ and _table_ for example
  _public.test_ get prefix **pt**
- **db** - used database
- **fields** - defined fields in table

Entity provide those methods:

- [**add**](#add) - insert new record in table and return create record
- [**update**](#update) - update record in table
- [**delete**](#delete) - delete record in table
- [**get_by_pk**](#get_by_pk) - get records from table by primary key value
- [**get_by_field**](#get_by_field) - get records from table by field value
- [**get**](#get) - get records from table by fields parameters

#### add

For add new record:

```lua
test = test:add({id=1,testtype = 'test1', name='test', dt='1970-01-01'})
print(inspect(test))

{
    dt = "1970-01-01",
    id = 1,
    name = "test",
    testtype = "test1"
}
```

#### update

For update record:

```lua
test = test:update({dt='2018-01-01', name='update-test'}, {id=1})
print(inspect(test))

{
    dt = "2018-01-01",
    id = 1,
    name = "update-test",
    testtype = "test1"
}
```

#### delete

For delete record:

```lua
test:delete{id=1}
```

#### get_by_pk

```lua
test = test:get_by_pk(1)
print(inspect(test))

{
    dt = "2018-01-01",
    id = 1,
    name = "update-test",
    testtype = "test1"
}
```

#### get_by_field

```lua
test = test:get_by_field('name', 'update-test')
print(inspect(test))
{
    dt = "2018-01-01",
    id = 1,
    name = "update-test",
    testtype = "test1"
}
```

#### get

Simple usage:

```lua
test = test:get{ id=1, name= "update-test"}
print(inspect(test))

{
    dt = "2018-01-01",
    id = 1,
    name = "update-test",
    testtype = "test1"
}
```

Advanced usage:

```lua
test = test:get{ name = {value = "update", op = 'ilike' }}
print(inspect(test))
{
    dt = "2018-01-01",
    id = 1,
    name = "update-test",
    testtype = "test1"
}
```

Now supported operation:

- ilike
- =,<,>,<=,>=

This operation also supported in update filter

### Field

Definition fields in entity constructor generate Field object
Field object support

- foreign keys
- alias
- prefetch (use LEFT JOIN)

Field object type can be:

- string
- number
- boolean
- json (you need json module for support it)

For example add link one to many

```lua
uid_role = {
    type = "string",
    alias = "role",
    table = role,
    foreign_key = true
    fetch = true
}
```

### Condition

Use condition for complex query in where. Now supported _and_, _or_

#### \_and

For example:

```lua
local sql = user:select():join(orders):where(
   cond:_and(
           { user, name="test" },
           { orders, status = true }
   ))
```

#### \_or

For example

```lua
local sql = user:select():join(orders):where(
   cond:_and(
           { user, name="test" },
           cond:_or(
                { user, status = true },
                { user, expires_in = -1 }),
           { orders, status = true }
   ))
```

You can combine **\_or** and **\_and** where relation method. Also field in cond support operators
_IN_, _<=_, _>=_, _IS_.
For example

```lua
cond:_and({user, name = {op='IN', value = {"test", "test2"} } })
```

### Limit
    To limit the number of rows returned by the query you can use complex query with limit() function
    For example:

    ```lua
    local sql = token:user():limit(1)
    ```

### Order

    To order rows returned by the query you can use complex query with order() function
    avaliable order types ASC (default) | DESC
    For example:

    ```lua
    local sql = token:user():orderby({field = "name", ordertype = "DESC"})
    ```
