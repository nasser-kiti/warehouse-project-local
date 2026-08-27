/*
- Check for Nulls or Duplicates in the primary key
- - CHECK: Unique and Not nullNo results
- - EXPECTATION: No results
- - FINDINGS: prd_id: No results ✅
 */
SELECT
    prd_id,
    COUNT(*)
FROM
    bronze.crm_prd_info
GROUP BY
    prd_id
HAVING
    COUNT(*) > 1;

/*
    - Check for unwanted spaces
    - - CHECK: spaces at start or end of data
    - - EXPECTATION: No results
    - - FINDINGS: prd_id: No results ✅
*/

-- Example check with the prd_nm column --
SELECT
    prd_nm,
    COUNT(*)
FROM
    bronze.crm_prd_info
WHERE
    prd_nm != TRIM(prd_nm)
GROUP BY prd_nm;

/*
    - Check for nulls or negative numbers in numerical columns
    - - CHECK: signed values and nulls
    - - EXPECTATION: No results
    - - FINDINGS: some null values ❌
*/

-- Example check with the prd_cost column --
SELECT
    prd_cost,
    COUNT(*)
FROM
    bronze.crm_prd_info
WHERE
    prd_cost is  NULL or prd_cost < 0
GROUP BY prd_cost;

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: There are some null columns alongside the options expected options ❌
    - - We need to:
    - - - Store data with clear meaningful values instead of abbreviations. In cases where it's not clear, ask the data expert of the source system
    - - - Decide what to do with the null values. For this case, use a default value of 'n/a'
*/

SELECT DISTINCT 
    prd_line
FROM bronze.crm_prd_info;

-- Date checks--
/*
    - Check 1: Chronology of start and end dates
    - - CHECK: Valid date order
    - - EXPECTATION: End date must be after start date
    - - FINDINGS: None of the data has valid date order❌
*/

SELECT
    *
FROM
    bronze.crm_prd_info
WHERE
    prd_end_dt < prd_start_dt;

/*
In such cases, it is importnat to get a few cases and analyse them in another tool like excel.
Create hypotheses that make sense, test them and validate with the data expert.
Hypotheses:
- Start date must be smaller than end date
- For the same product, the start date of a new price is the end date of the previous one; with a 1 day difference
- The current price has no end date

After testing and validating, then use the same subset to test the new logic before extending it to the whole dataset
*/

-- Testing the validated logic on two sample products: 'AC-HE-HL-U509-R' and 'AC-HE-HL-U509'
SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    CAST(prd_start_dt AS DATE),  -- Since this is always a date, then changing the dataype in the ddl makes sense, especially in the silver layer
    CAST(
        LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1  -- Removing one day to prevent overlaps
        AS DATE) AS prd_end_dt
FROM
    bronze.crm_prd_info
WHERE
    prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');
