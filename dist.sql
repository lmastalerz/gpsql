/******************************************************************************
* File             dist.sql
* Description      Display table distribution columns
* Parameters
*      tname       Name of object to display, can be part of the name
*
* History
*      Date        Change
*      29/07/2016  Initial version
******************************************************************************/
\prompt 'Table Name: ' tname_noquote
\set tname '\'' :tname_noquote '\''
SELECT pusr.usename
     , pnsp.nspname schema
     , pcla.relname table_name
     , patt.attname column_name
     , COUNT(gdpu.attrnums) OVER (PARTITION BY pcla.relname) num_key_cols
FROM ( SELECT gdpo.localoid
            , CASE
                WHEN ( ARRAY_UPPER(gdpo.attrnums, 1) > 0 ) THEN UNNEST(gdpo.attrnums)
                ELSE NULL
              END AS attrnums
       FROM   gp_distribution_policy gdpo ) gdpu
JOIN   pg_class pcla
  ON ( gdpu.localoid = pcla.oid )
JOIN   pg_namespace pnsp
  ON ( pcla.relnamespace = pnsp.oid )
JOIN   pg_attribute patt
  ON ( patt.attnum = gdpu.attrnums
       AND patt.attrelid = pcla.oid )
JOIN   pg_user pusr
  ON ( pcla.relowner = pusr.usesysid )
WHERE  UPPER(pcla.relname) LIKE '%' || UPPER(:tname) || '%'
ORDER BY 1, 2, 3, 4;
