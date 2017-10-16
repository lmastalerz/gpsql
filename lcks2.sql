-- Sessions waiting for locked objects
SELECT psa.datname, psa.sess_id, psa.usename, SUBSTR(psa.current_query, 1, 30), psa.waiting, psa.waiting_reason, pn.nspname, pc.relname, pc.oid
FROM   pg_stat_activity AS psa 
LEFT JOIN pg_locks pl 
    ON (psa.sess_id = pl.mppsessionid) 
LEFT JOIN pg_class pc 
  ON (pl.relation = pc.oid) 
LEFT JOIN pg_namespace pn 
  ON (pc.relnamespace = pn.oid) 
WHERE NOT pl.granted 
  AND psa.waiting;
