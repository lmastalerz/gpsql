/******************************************************************************
* File             dep.sql
* Description      Display table dependencies
* Parameters       
*    nspname       Schema name 
*      tname       Table name 
* 
* History          
*      Date        Change
*      07/11/2016  Initial version 
******************************************************************************/
\prompt 'Schema name: ' nspname_noquote
\set nspname '\'' :nspname_noquote '\''
\prompt 'Table name: ' tname_noquote
\set tname '\'' :tname_noquote '\''
SELECT  classid::regclass depclass
      , CASE deptype
          WHEN 'p' THEN 'pinned'
          WHEN 'i' THEN 'internal'
          WHEN 'a' THEN 'automatic'
          WHEN 'n' THEN 'normal'
        END AS deptype
      , d.nspname depnamespace
      , d.relname depname
FROM  ( -- Class dependencies
        SELECT pdep.refobjid
             , pdep.deptype
             , pdep.classid
             , depns.nspname
             , pcla.relname
        FROM   pg_depend pdep
        LEFT JOIN  pg_class pcla
          ON ( pdep.objid = pcla.oid )
        LEFT JOIN pg_namespace depns
          ON ( pcla.relnamespace = depns.oid )
        WHERE  pdep.classid = 1259
        UNION ALL
        -- Rewrite dependencies
        SELECT pdep.refobjid
             , pdep.deptype
             , pdep.classid
             , depns.nspname viewnamespace
             , depview.relname
        FROM   pg_depend pdep
        LEFT JOIN  pg_rewrite prew
          ON ( pdep.objid = prew.oid )
        LEFT JOIN  pg_class depview
          ON ( prew.ev_class = depview.oid )
        LEFT JOIN pg_namespace depns
          ON ( depview.relnamespace = depns.oid )
        WHERE  pdep.classid = 2618
        UNION ALL
        -- Type dependencies
        SELECT pdep.refobjid
             , pdep.deptype
             , pdep.classid
             , depns.nspname typnamespace
             , ptyp.typname
        FROM   pg_depend pdep
        LEFT JOIN  pg_type ptyp
          ON ( pdep.objid = ptyp.oid )
        LEFT JOIN pg_namespace depns
          ON ( ptyp.typnamespace = depns.oid)
        WHERE  pdep.classid = 1247
        UNION ALL
        -- Other dependencies
        SELECT pdep.refobjid
             , pdep.deptype
             , pdep.classid
             , NULL
             , NULL
        FROM   pg_depend pdep
        WHERE  pdep.classid NOT IN (1259, 1247, 2618 )
               AND  refobjid = 227546 ) d
JOIN  pg_class pcla
  ON ( d.refobjid = pcla.oid )
JOIN  pg_namespace pnsp
  ON ( pcla.relnamespace = pnsp.oid )
WHERE UPPER(pcla.relname) = UPPER(:tname)
  AND UPPER(pnsp.nspname) = UPPER(:nspname)
ORDER BY 1, 2, 3, 4; 
