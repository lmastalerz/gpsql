/******************************************************************************
* File             t.sql
* Description      Display core Greenplum object details 
* Parameters       
*      tname       name of table/object to display, can be part of the name only 
* 
* History          
*      Date        Change
*      25/02/2016  Initial version 
******************************************************************************/
\prompt 'Table Name: ' tname_noquote
\set tname '\'' :tname_noquote '\''
SELECT a.rolname owner, ns.nspname schame, c.relname, c.relfilenode file_name
     , c.relpages * 32 / 1024 MB, c.reltuples nrows, c.relhasindex idx
     , CASE c.relkind
         WHEN 'r' THEN 'r:table'
         WHEN 'i' THEN 'i:index'
         WHEN 'S' THEN 'S:sequence'
         WHEN 'v' THEN 'v:view'
         WHEN 'c' THEN 'c:composite'
         WHEN 't' THEN 't:toast'
         WHEN 'o' THEN 'o:internal'
         WHEN 'u' THEN 'u:uncataloged'
         ELSE 'unknown'
       END type
     , CASE c.relstorage
         WHEN 'a' THEN 'a:append-optimized'
         WHEN 'h' THEN 'h:heap'
         WHEN 'v' THEN 'v:virtual'
         WHEN 'x' THEN 'x:external'
         ELSE 'unknown'
       END storage
     , c.relnatts col
     , c.relchecks chk
     , c.reltriggers trg
     , c.relacl
     , c.reloptions
FROM pg_class c
JOIN pg_catalog.pg_namespace ns
 ON ( c.relnamespace = ns.oid )
JOIN pg_type t
 ON ( c.reltype = t.oid)
LEFT JOIN pg_authid a
 ON ( c.relowner = a.oid)
LEFT JOIN pg_tablespace ts
 ON ( c.reltablespace = ts.oid )
WHERE UPPER(relname) LIKE '%' || UPPER(:tname) || '%';
