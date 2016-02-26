/******************************************************************************
* File             xt.sql
* Description      Display Greenplum external table
* Parameters
*      tname       Name of external table to display
*
* History
*      Date        Change
*      26/02/2016  Initial version
******************************************************************************/
\prompt 'External Table: ' tname_noquote
\set tname '\'' :tname_noquote '\''
SELECT a.rolname owner, ns.nspname schema, pc.relname table_name
     , et.fmttype fmt
     , et.fmtopts
     , et.rejectlimit::TEXT || et.rejectlimittype AS reject
     , pce.relname
     , et.encoding enc
     , et.writable w
     , et.location
FROM   pg_catalog.pg_exttable et
JOIN   pg_catalog.pg_class pc
  ON ( et.reloid = pc.oid)
JOIN   pg_authid a
  ON ( pc.relowner = a.oid)
JOIN   pg_catalog.pg_namespace ns
  ON ( pc.relnamespace = ns.oid )
JOIN   pg_catalog.pg_class pce
 ON (  et.fmterrtbl = pce.oid )
WHERE  UPPER(pc.relname) LIKE '%' || UPPER(:tname) || '%';
