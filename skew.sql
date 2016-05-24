/******************************************************************************
* File             skew.sql
* Description      Display N most skewed tables
* Parameters
*      top_n       Number of tables to display
*      min_size   Display only tables larger than min_size MB
*
* History
*      Date        Change
*      24/05/2016  Initial version
******************************************************************************/
\prompt 'Number of tables to display: ' top_n
\prompt 'Tables larger than (in MB): ' min_size
SELECT sc.skcnamespace
     , pc.relname AS table_name
     , sotd.sotdsize / 1024 / 1024 as table_size_mb
     , sotd.sotdtoastsize / 1024 / 1024 as toast_mb
     , sotd.sotdadditionalsize / 1024 / 1024 as other_mb
     , sc.skccoeff
FROM   gp_toolkit.gp_size_of_table_disk AS sotd
JOIN   pg_class pc
  ON ( sotd.sotdoid=pc.oid )
JOIN   gp_toolkit.gp_skew_coefficients sc
  ON  ( sc.skcoid = pc.oid )
WHERE  sotd.sotdsize / 1024 / 1024 > :min_size
ORDER BY sc.skccoeff DESC
LIMIT :top_n
