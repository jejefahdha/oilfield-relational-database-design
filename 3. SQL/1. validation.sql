-- Validation: did my transformation from a flat table into normalized tables preserve the data correctly?
-- Row count validation
SELECT COUNT(*)
FROM `project-83169f7d-3cfe-4a70-90a.datavolve.dim_date`;
-- 3327, valid

SELECT COUNT(*)
FROM datavolve.dim_facility;
-- 1, valid

SELECT COUNT(*)
FROM datavolve.dim_field;
-- 1, valid

SELECT COUNT(*)
FROM datavolve.dim_well;
-- 7, valid

SELECT COUNT(*)
FROM datavolve.fact_daily_log;
-- 15634, valid

-- Primary key validation (uniqueness)
SELECT DATE_ID
FROM `project-83169f7d-3cfe-4a70-90a`.`datavolve`.`dim_date`
GROUP BY DATE_ID
HAVING COUNT(*) > 1;

SELECT FACILITY_ID
FROM `project-83169f7d-3cfe-4a70-90a`.`datavolve`.`dim_facility`
GROUP BY FACILITY_ID
HAVING COUNT(*) > 1;

SELECT FIELD_ID
FROM `project-83169f7d-3cfe-4a70-90a`.`datavolve`.`dim_field`
GROUP BY FIELD_ID
HAVING COUNT(*) > 1;

SELECT WELL_ID
FROM `project-83169f7d-3cfe-4a70-90a`.`datavolve`.`dim_well`
GROUP BY WELL_ID
HAVING COUNT(*) > 1;

SELECT LOG_ID
FROM `project-83169f7d-3cfe-4a70-90a`.`datavolve`.`fact_daily_log`
GROUP BY LOG_ID
HAVING COUNT(*) > 1;
-- all is clear

-- Foreign key validation (no null)
SELECT COUNT(*)
FROM `project-83169f7d-3cfe-4a70-90a.datavolve.fact_daily_log`
WHERE DATE_ID IS NULL OR
      FACILITY_ID IS NULL OR
      FIELD_ID IS NULL OR
      WELL_ID IS NULL;
-- no null

-- Join validation
SELECT COUNT(*)
FROM `project-83169f7d-3cfe-4a70-90a.datavolve.fact_daily_log` f
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_date` dd
ON f.DATE_ID = dd.DATE_ID
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_facility` dfa
ON f.FACILITY_ID = dfa.FACILITY_ID
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_field` dfi
ON f.FIELD_ID = dfi.FIELD_ID
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_well`dw
ON f.WELL_ID = dw.WELL_ID;
-- 15634, valid
