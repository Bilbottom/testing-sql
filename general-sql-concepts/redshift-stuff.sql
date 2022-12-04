
/* Object Permissions */
DROP VIEW IF EXISTS analytics_sb.object_permissions;
CREATE VIEW analytics_sb.object_permissions AS

WITH
    views AS (
        SELECT
            'view' AS object,
            schemaname,
            viewname AS objname,
            viewowner AS objowner
        FROM pg_views
    ),
    tables AS (
        SELECT
            'table' AS object,
            schemaname,
            tablename AS objname,
            tableowner AS objowner
        FROM pg_tables
    )

SELECT
    usrs.username,
    usrs.groupname,
    objs.schemaname,
    HAS_SCHEMA_PRIVILEGE(usrs.username, objs.schemaname, 'CREATE') AS "create",
    HAS_SCHEMA_PRIVILEGE(usrs.username, objs.schemaname, 'USAGE') AS "usage",
    objs.object,
    objs.objname,
    objs.objowner,
    HAS_TABLE_PRIVILEGE(usrs.username, objs.schemaname + '.' + objs.objname, 'SELECT') AS "select",
    HAS_TABLE_PRIVILEGE(usrs.username, objs.schemaname + '.' + objs.objname, 'INSERT') AS "insert",
    HAS_TABLE_PRIVILEGE(usrs.username, objs.schemaname + '.' + objs.objname, 'UPDATE') AS "update",
    HAS_TABLE_PRIVILEGE(usrs.username, objs.schemaname + '.' + objs.objname, 'DELETE') AS "delete",
    HAS_TABLE_PRIVILEGE(usrs.username, objs.schemaname + '.' + objs.objname, 'REFERENCES') AS "references"
FROM (
              SELECT object, schemaname, objname, objowner FROM views
    UNION ALL SELECT object, schemaname, objname, objowner FROM tables
) AS objs
    CROSS JOIN analytics_sb.user_groups AS usrs
-- ORDER BY
--     objs.schemaname,
--     objs.objname,
--     usrs.username
;


GRANT SELECT ON analytics_sb.object_permissions TO alteryx, GROUP analytics, tableau;


/* User Groups */
DROP VIEW IF EXISTS analytics_sb.user_groups;
CREATE VIEW analytics_sb.user_groups AS

WITH
    groups AS (
        SELECT usename, groname
        FROM pg_user, pg_group
        WHERE pg_user.usesysid = ANY(pg_group.grolist)
    )

SELECT
    usename AS username,
    groname AS groupname
FROM pg_user
    LEFT JOIN groups USING(usename)
WHERE LEFT(usename, 2) != 'v-'
;


GRANT SELECT ON analytics_sb.user_groups TO alteryx, GROUP analytics, tableau;

