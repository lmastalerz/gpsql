-- Sessions holding locks other sessions are/may be waiting for
SELECT a.datname, mppsessionid, a.usename, a.waiting, r.relname, mode, COUNT(*), a.current_query
FROM   pg_locks l
JOIN   pg_class r
  ON ( l.relation = r.oid)
JOIN   pg_stat_activity a
  ON ( l.mppsessionid = a.sess_id)
WHERE  relation IN (SELECT DISTINCT relation FROM pg_locks WHERE NOT granted)
   AND granted
GROUP BY 1, 2, 3, 4, 5, 6, 8
ORDER BY 1, 2;
