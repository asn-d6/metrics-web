-- Copyright 2017--2020 The Tor Project
-- See LICENSE for licensing information

CREATE TABLE IF NOT EXISTS measurements (
  measurement_id SERIAL PRIMARY KEY,
  source CHARACTER VARYING(32) NOT NULL,
  filesize INTEGER NOT NULL,
  start TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  socket INTEGER,
  connect INTEGER,
  negotiate INTEGER,
  request INTEGER,
  response INTEGER,
  datarequest INTEGER,
  dataresponse INTEGER,
  datacomplete INTEGER,
  writebytes INTEGER,
  readbytes INTEGER,
  didtimeout BOOLEAN,
  dataperc0 INTEGER,
  dataperc10 INTEGER,
  dataperc20 INTEGER,
  dataperc30 INTEGER,
  dataperc40 INTEGER,
  dataperc50 INTEGER,
  dataperc60 INTEGER,
  dataperc70 INTEGER,
  dataperc80 INTEGER,
  dataperc90 INTEGER,
  dataperc100 INTEGER,
  launch TIMESTAMP WITHOUT TIME ZONE,
  used_at TIMESTAMP WITHOUT TIME ZONE,
  timeout INTEGER,
  quantile REAL,
  circ_id INTEGER,
  used_by INTEGER,
  endpointlocal CHARACTER VARYING(64),
  endpointproxy CHARACTER VARYING(64),
  endpointremote CHARACTER VARYING(96),
  hostnamelocal CHARACTER VARYING(64),
  hostnameremote CHARACTER VARYING(64),
  sourceaddress CHARACTER VARYING(64),
  UNIQUE (source, filesize, start)
);

CREATE TABLE IF NOT EXISTS buildtimes (
  measurement_id INTEGER REFERENCES measurements (measurement_id) NOT NULL,
  position INTEGER NOT NULL,
  buildtime INTEGER NOT NULL,
  delta INTEGER NOT NULL,
  UNIQUE (measurement_id, position)
);

CREATE TYPE server AS ENUM ('public', 'onion');

CREATE OR REPLACE VIEW onionperf AS
SELECT date,
  filesize,
  source,
  server,
  CASE WHEN q IS NULL THEN NULL ELSE q[1] END AS q1,
  CASE WHEN q IS NULL THEN NULL ELSE q[2] END AS md,
  CASE WHEN q IS NULL THEN NULL ELSE q[3] END AS q3,
  timeouts,
  failures,
  requests
FROM (
SELECT DATE(start) AS date,
  filesize,
  source,
  CASE WHEN endpointremote LIKE '%.onion:%' THEN 'onion'
    ELSE 'public' END AS server,
  CASE WHEN COUNT(*) > 0 THEN
    PERCENTILE_CONT(ARRAY[0.25,0.5,0.75]) WITHIN GROUP(ORDER BY datacomplete)
    ELSE NULL END AS q,
  COUNT(CASE WHEN didtimeout OR datacomplete < 1 THEN 1 ELSE NULL END)
    AS timeouts,
  COUNT(CASE WHEN NOT didtimeout AND datacomplete >= 1
    AND readbytes < filesize THEN 1 ELSE NULL END) AS failures,
  COUNT(*) AS requests
FROM measurements
WHERE DATE(start) < current_date - 1
GROUP BY date, filesize, source, server
UNION
SELECT DATE(start) AS date,
  filesize,
  '' AS source,
  CASE WHEN endpointremote LIKE '%.onion:%' THEN 'onion'
    ELSE 'public' END AS server,
  CASE WHEN COUNT(*) > 0 THEN
    PERCENTILE_CONT(ARRAY[0.25,0.5,0.75]) WITHIN GROUP(ORDER BY datacomplete)
    ELSE NULL END AS q,
  COUNT(CASE WHEN didtimeout OR datacomplete < 1 THEN 1 ELSE NULL END)
    AS timeouts,
  COUNT(CASE WHEN NOT didtimeout AND datacomplete >= 1
    AND readbytes < filesize THEN 1 ELSE NULL END) AS failures,
  COUNT(*) AS requests
FROM measurements
WHERE DATE(start) < current_date - 1
GROUP BY date, filesize, 3, server) sub
ORDER BY date, filesize, source, server;

CREATE OR REPLACE VIEW buildtimes_stats AS
SELECT date,
  source,
  position,
  TRUNC(q[1]) AS q1,
  TRUNC(q[2]) AS md,
  TRUNC(q[3]) AS q3
FROM (
SELECT DATE(start) AS date,
  source,
  position,
  PERCENTILE_CONT(ARRAY[0.25,0.5,0.75]) WITHIN GROUP(ORDER BY delta) AS q
FROM measurements NATURAL JOIN buildtimes
WHERE DATE(start) < current_date - 1
AND position <= 3
GROUP BY date, source, position
UNION
SELECT DATE(start) AS date,
  '' AS source,
  position,
  PERCENTILE_CONT(ARRAY[0.25,0.5,0.75]) WITHIN GROUP(ORDER BY delta) AS q
FROM measurements NATURAL JOIN buildtimes
WHERE DATE(start) < current_date - 1
AND position <= 3
GROUP BY date, 2, position) sub
ORDER BY date, source, position;

CREATE OR REPLACE VIEW latencies_stats AS
WITH filtered_measurements AS (
  SELECT DATE(start) AS date,
    source,
    CASE WHEN endpointremote LIKE '%.onion:%' THEN 'onion'
      ELSE 'public' END AS server,
    dataresponse - datarequest AS latency
  FROM measurements
  WHERE DATE(start) < current_date - 1
  AND datarequest > 0
  AND dataresponse > 0
), quartiles AS (
  SELECT date,
    source,
    server,
    PERCENTILE_CONT(ARRAY[0.25,0.5,0.75])
      WITHIN GROUP(ORDER BY latency) AS q
  FROM filtered_measurements
  GROUP BY date, source, server
)
SELECT date,
  source,
  server,
  MIN(CASE WHEN latency >= q[1] - ((q[3] - q[1]) * 1.5)
    THEN latency ELSE NULL END) AS low,
  TRUNC(AVG(q[1])) AS q1,
  TRUNC(AVG(q[2])) AS md,
  TRUNC(AVG(q[3])) AS q3,
  MAX(CASE WHEN latency <= q[3] + ((q[3] - q[1]) * 1.5)
    THEN latency ELSE NULL END) AS high
FROM filtered_measurements NATURAL JOIN quartiles
GROUP BY 1, 2, 3
ORDER BY date, source, server;

-- Explanation of the number 4194304 below for computing kbps: From the FILESIZE
-- and DATAPERC* fields we can compute the number of milliseconds that have
-- elapsed between receiving bytes 524,288 and 1,048,576, which is a total
-- amount of 524,288 bytes or 4,194,304 bits. If we divide that value by
-- 4,194,304 we obtain the number of milliseconds that have elapsed for
-- downloading 1 bit, which happens to be the same value as the number of
-- seconds for downloading 1 kilobit. We want the reciprocal of that value which
-- has the unit kilobits per second.
CREATE OR REPLACE VIEW throughput_stats AS
WITH filtered_measurements AS (
  SELECT DATE(start) AS date,
    source,
    CASE WHEN endpointremote LIKE '%.onion:%' THEN 'onion'
      ELSE 'public' END AS server,
    CASE WHEN filesize = 1048576 AND dataperc100 > dataperc50
      THEN 4194304 / (dataperc100 - dataperc50)
      WHEN filesize = 5242880 AND dataperc20 > dataperc10
      THEN 4194304 / (dataperc20 - dataperc10)
      ELSE NULL END AS kbps
  FROM measurements
  WHERE DATE(start) < current_date - 1
), quartiles AS (
  SELECT date,
    source,
    server,
    PERCENTILE_CONT(ARRAY[0.25,0.5,0.75])
      WITHIN GROUP(ORDER BY kbps) AS q
  FROM filtered_measurements
  GROUP BY date, source, server
)
SELECT date,
  source,
  server,
  MIN(CASE WHEN kbps >= q[1] - ((q[3] - q[1]) * 1.5)
    THEN kbps ELSE NULL END) AS low,
  TRUNC(AVG(q[1])) AS q1,
  TRUNC(AVG(q[2])) AS md,
  TRUNC(AVG(q[3])) AS q3,
  MAX(CASE WHEN kbps <= q[3] + ((q[3] - q[1]) * 1.5)
    THEN kbps ELSE NULL END) AS high
FROM filtered_measurements NATURAL JOIN quartiles
GROUP BY date, source, server
ORDER BY date, source, server;

