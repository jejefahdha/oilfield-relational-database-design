-- Analysis
-- Create View production
CREATE VIEW datavolve.view_production
AS
SELECT
  f.LOG_ID,
  dd.DATEPRD,
  dw.WELL_BORE_CODE,
  f.BORE_GAS_VOL,
  f.BORE_OIL_VOL,
  f.ON_STREAM_HRS
FROM `project-83169f7d-3cfe-4a70-90a.datavolve.fact_daily_log` f
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_date` dd
ON f.DATE_ID = dd.DATE_ID
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_facility` dfa
ON f.FACILITY_ID = dfa.FACILITY_ID
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_field` dfi
ON f.FIELD_ID = dfi.FIELD_ID
JOIN `project-83169f7d-3cfe-4a70-90a.datavolve.dim_well`dw
ON f.WELL_ID = dw.WELL_ID
WHERE f.WELL_TYPE = 'OP';

-- range of period
SELECT EXTRACT(YEAR FROM DATEPRD) YEAR,
       EXTRACT(MONTH FROM DATEPRD) MONTH
FROM datavolve.view_production
GROUP BY 1,2
ORDER BY 1,2;
-- the data is from feb 2008 til march 2012

-- 1. production year by year
SELECT EXTRACT(YEAR FROM DATEPRD) YEAR,
       SUM(BORE_GAS_VOL) TOT_GAS, 
       SUM(BORE_OIL_VOL)  TOT_OIL
FROM datavolve.view_production
GROUP BY 1
ORDER BY 1;
-- for gas, constant decline from 2009 til 2013, then back increasing from 2014 and 2015, probably til 2016 because the 2016 only until 3 month and the amount is quiet good.
-- the same condition happened for oil

-- check if there is different well in 2014 that caused the increase
SELECT EXTRACT(YEAR FROM DATEPRD) YEAR, 
       WELL_BORE_CODE,
       SUM(BORE_GAS_VOL) TOT_GAS,
       SUM(BORE_OIL_VOL) TOT_OIL
FROM datavolve.view_production
GROUP BY 1,2
ORDER BY 1,2;
-- in 2008-2012 there was only 2 wells (NO 15/9-F-12 H, NO 15/9-F-14 H) which keeps declining year by year
-- in 2013 added one new well (NO 15/9-F-11 H)
-- in 2014 2015 using two other new well (NO 15/9-F-1 C and NO 15/9-F-15 D)
-- and in 2016 another new well added (NO 15/9-F-5 AH) so in total 6 wells
-- conc: the trend is declining in years but back increasing after adding new wells

-- -----------------------------------------------------------------------------------

-- 2. which wells produce most?
-- to answer this question, we need to split it in year as the wells contribution is different year by year
WITH gas_year AS
(SELECT EXTRACT(YEAR FROM DATEPRD) YEAR,
       WELL_BORE_CODE,
       SUM(BORE_GAS_VOL) TOT_GAS     
FROM datavolve.view_production
GROUP BY 1,2)
SELECT YEAR,
       WELL_BORE_CODE,
       TOT_GAS,
       SUM(TOT_GAS) OVER(PARTITION BY YEAR) TOT_GAS_YEAR,
       TOT_GAS/SUM(TOT_GAS) OVER(PARTITION BY YEAR) CONT_GAS_YEAR
FROM gas_year
ORDER BY 1,2;
-- in the span of 2008-2012 there is consitanly changed pattern of which NO 15/9-F-12 H contributed the most, changing to NO 15/9-F-14 H which more contributed  where both actually has declining production number.
-- if we look to recent data, which is in 2016, the most contributing well is NO 15/9-F-11 H which covers 52% production. prevented maintenance should focus on this well since the down time of this well will lead to more than 50% production lost.

-- check on oil production
WITH oil_year AS
(SELECT EXTRACT(YEAR FROM DATEPRD) YEAR,
       WELL_BORE_CODE,
       SUM(BORE_OIL_VOL) TOT_OIL    
FROM datavolve.view_production
GROUP BY 1,2)
SELECT YEAR,
       WELL_BORE_CODE,
       TOT_OIL,
       SUM(TOT_OIL) OVER(PARTITION BY YEAR) TOT_OIL_YEAR,
       TOT_OIL/SUM(TOT_OIL) OVER(PARTITION BY YEAR) CONT_OIL_YEAR
FROM oil_year
ORDER BY 1,2;
-- same pattern as gas

-- -----------------------------------------------------------------------------------

-- 3. Which wells are underutilized?
-- calculating efficiency
SELECT WELL_BORE_CODE,
       SUM(BORE_GAS_VOL)/SUM(ON_STREAM_HRS) GAS_PER_HOUR
FROM datavolve.view_production
GROUP BY 1
ORDER BY 2;
-- NO 15/9-F-15 D is the least productive well for oil. need to check by the mechanic/engineer.
SELECT WELL_BORE_CODE,
       SUM(BORE_OIL_VOL)/SUM(ON_STREAM_HRS) OIL_PER_HOUR
FROM datavolve.view_production
GROUP BY 1
ORDER BY 2;
-- NO 15/9-F-15 D is the least productive, same as gas.

-- -----------------------------------------------------------------------------------

-- 4. Which wells experience the most downtime?
SELECT WELL_BORE_CODE,
       SUM(24-ON_STREAM_HRS)/COUNT(*) AVG_DWTM
FROM datavolve.view_production
GROUP BY 1
ORDER BY 2 DESC;
-- NO 15/9-F-1 C significantly high which is 10 hours per day
