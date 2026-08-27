/*
    - Check for nulls or negative numbers in numerical columns
    - - CHECK: signed values and nulls
    - - EXPECTATION: No results
    - - FINDINGS: some null values ✅
*/

-- Example check with the prd_cost column --
SELECT
    prd_cost,
    COUNT(*)
FROM
    silver.crm_prd_info
WHERE
    prd_cost is  NULL or prd_cost < 0
GROUP BY prd_cost;

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: Data now normalised/standardised ✅
*/

SELECT DISTINCT 
    prd_line
FROM silver.crm_prd_info;

-- Date checks--
/*
    - Check 1: Chronology of start and end dates
    - - CHECK: Valid date order
    - - EXPECTATION: End date must be after start date
    - - FINDINGS: All the data has valid date order ✅
*/

SELECT
    *
FROM
    silver.crm_prd_info
WHERE
    prd_end_dt < prd_start_dt;

