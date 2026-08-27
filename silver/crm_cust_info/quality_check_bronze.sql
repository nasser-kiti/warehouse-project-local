SELECT
    *
FROM
    bronze.crm_cust_info;

/*
- Check for Nulls or Duplicates in the primary key
- - CHECK: Unique and Not nullNo results
- - EXPECTATION: No results
- - FINDINGS: 6 non_unique records ❌
 */
SELECT
    cst_id,
    COUNT(*)
FROM
    bronze.crm_cust_info
GROUP BY
    cst_id
HAVING
    COUNT(*) > 1;

-- Once we know the data with multiple records, then we use the ROW_NUMBER() window function to assign  a unique number to each record
SELECT
    *
FROM
    (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    cst_id
                ORDER BY
                    cst_create_date DESC
            ) as flag_last
        FROM
            bronze.crm_cust_info
    ) t
WHERE
    flag_last = 1;

/*
    - Check for unwanted spaces
    - - CHECK: spaces at start or end of data
    - - EXPECTATION: No results
    - - FINDINGS:  Multiple columns have leading or trailing spaces ❌
*/

-- Example check with the firstname column --
SELECT
    cst_firstname,
    COUNT(*)
FROM
    bronze.crm_cust_info
WHERE
    cst_firstname != TRIM(cst_firstname)
GROUP BY cst_firstname;

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: There are some null columns alongside the options expected options ❌
    - - We need to:
    - - - Store data with clear meaningful values instead of abbreviations. For example: Male instead of M or Single instead of S
    - - - Decide what to do with the null values. For this case, use a default value of 'n/a'
*/

SELECT DISTINCT 
    cst_marital_status
FROM bronze.crm_cust_info;

SELECT DISTINCT 
    cst_gndr
FROM bronze.crm_cust_info;