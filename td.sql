/******************************************************************************
* File             td.sql
* Description      Display table distribution columns
*
* History
*      Date        Change
*      12/12/2016  Initial version
******************************************************************************/
SELECT nam.nspname, c.relname, dp.attrnum, att.attname
FROM   pg_class c
JOIN   pg_namespace nam
  ON ( c.relnamespace = nam.oid )
LEFT JOIN (SELECT localoid, UNNEST(attrnums) AS attrnum FROM gp_distribution_policy) dp
  ON ( c.oid = dp.localoid)
LEFT JOIN pg_attribute att
  ON (     c.oid = att.attrelid
       AND dp.attrnum = att.attnum )
ORDER BY 1, 2, 3;
