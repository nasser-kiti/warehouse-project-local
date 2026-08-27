SELECT
    *
FROM
    silver.crm_cust_info;

/*
- Check for Nulls or Duplicates in the primary key
- - CHECK: Unique and Not nullNo results
- - EXPECTATION: No results
- - FINDINGS: No nulls and duplicates ✅
 */
SELECT
    cst_id,
    COUNT(*)
FROM
    silver.crm_cust_info
GROUP BY
    cst_id
HAVING
    COUNT(*) > 1;

/*
    - Check for unwanted spaces
    - - CHECK: spaces at start or end of data
    - - EXPECTATION: No results
    - - FINDINGS:  No columns with leading or trailing spaces ✅
*/

-- Example check with the firstname column --
SELECT
    cst_firstname,
    COUNT(*)
FROM
    silver.crm_cust_info
WHERE
    cst_firstname != TRIM(cst_firstname)
GROUP BY cst_firstname;

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: Data now normalised/standardised ✅
*/

SELECT DISTINCT 
    cst_marital_status
FROM silver.crm_cust_info;

SELECT DISTINCT 
    cst_gndr
FROM silver.crm_cust_info;