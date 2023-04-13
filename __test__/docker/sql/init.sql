CREATE SCHEMA one;
CREATE SCHEMA two;
CREATE SCHEMA three;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE one.agent (
    uid UUID NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    login VARCHAR NOT NULL,
    "admin" BOOLEAN NOT NULL DEFAULT false,
    uid_system UUID NULL
);

CREATE TABLE one.client (
    uid UUID NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    name VARCHAR NOT NULL,
    secret VARCHAR NOT NULL,
    status BOOLEAN NULL
);

CREATE TABLE three.link (
    uid uuid NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    sid_linktype varchar NOT NULL,
    uid_system uuid NOT NULL,
    tsfrom timestamp NOT NULL DEFAULT now(),
    tsto timestamp NULL,
    tsupdate timestamp NULL,
    ordr int4 NOT NULL DEFAULT 0
);

CREATE TABLE three.linktype (
    sid varchar NOT NULL PRIMARY KEY,
    in_schema varchar NOT NULL,
    in_table varchar NOT NULL
);

CREATE TABLE three."system" (
    uid uuid NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    "name" varchar NOT NULL,
    ip varchar NULL
);

CREATE TABLE two.counterparty (
    uid uuid NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    "name" varchar NOT NULL,
    uid_agent uuid NULL
);

CREATE TABLE two.detail (
   uid uuid NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
   uid_counterparty uuid NOT NULL,
   uid_detailtype uuid NOT NULL,
   "data" jsonb NOT NULL,
   tsfrom timestamp NOT NULL DEFAULT now(),
   tsto timestamp NULL,
   uid_system uuid NULL
);

CREATE TABLE two.detailtype (
    uid uuid NOT NULL DEFAULT uuid_generate_v1mc() PRIMARY KEY,
    "name" varchar NOT NULL,
    "data" jsonb NOT NULL,
    description varchar NULL,
    uid_counterparty uuid NULL
);

ALTER TABLE one.agent ADD CONSTRAINT system_agent_fk
    FOREIGN KEY (uid_system)
    REFERENCES three."system"(uid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE three.link ADD CONSTRAINT linktype_link_fk
    FOREIGN KEY (sid_linktype)
    REFERENCES three.linktype(sid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE three.link ADD CONSTRAINT system_link_fk
    FOREIGN KEY (uid_system)
    REFERENCES three."system"(uid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE two.counterparty ADD CONSTRAINT system_link_fk
    FOREIGN KEY (uid_agent)
    REFERENCES one.agent(uid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE two.detail ADD CONSTRAINT counterparty_detail_fk
    FOREIGN KEY (uid_counterparty)
    REFERENCES two.counterparty(uid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE two.detail ADD CONSTRAINT counterparty_detailtype_fk
    FOREIGN KEY (uid_detailtype)
    REFERENCES two.detailtype(uid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

ALTER TABLE two.detail ADD CONSTRAINT system_detail_fk
    FOREIGN KEY (uid_system)
    REFERENCES three."system"(uid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;

CREATE INDEX ON two.detail(tsfrom);
CREATE INDEX ON two.detail(tsto);
