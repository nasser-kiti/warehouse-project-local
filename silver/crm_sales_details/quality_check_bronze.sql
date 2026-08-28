/*
- Check for unwanted spaces
- - CHECK: spaces at start or end of data
- - EXPECTATION: No results
- - FINDINGS: prd_id: No results ✅
 */
-- Example check with the sls_ord_num column --
SELECT
    sls_ord_num,
    COUNT(*)
FROM
    bronze.crm_sales_details
WHERE
    sls_ord_num != TRIM(sls_ord_num)
GROUP BY
    sls_ord_num;

SELECT
    sls_prd_key,
    COUNT(*)
FROM
    bronze.crm_sales_details
WHERE
    sls_prd_key != TRIM(sls_prd_key)
GROUP BY
    sls_prd_key;

/*
Since the sls_prd_key and sls_cust_id columns will be used to connect to the products(crm_prd_info) and customer (crm_cust_info) tables,
thias check will confirm if ther are any data in the sales table that are not in both those tables.

- Check for sales of non-existing products
- - CHECK:  Sold products that do not exist in the products table
- - EXPECTATION: No results
- - FINDINGS: prd_id: No results ✅
 */
SELECT
    *
FROM
    bronze.crm_sales_details
WHERE
    sls_prd_key NOT IN (
        SELECT
            prd_key
        FROM
            silver.crm_prd_info
    );

/*
- Check for sales by either non-existing customers 
- - CHECK: purchases by customers that do not exist in the customers table
- - EXPECTATION: No results
- - FINDINGS: prd_id: No results ✅
 */
SELECT
    *
FROM
    bronze.crm_sales_details
WHERE
    sls_cust_id NOT IN (
        SELECT
            cst_id
        FROM
            silver.crm_cust_info
    );

-- Date checks--
/*
- Check 1: Validity of date columns
- - CHECK: Valid date format
- - EXPECTATION: Date columns must be YYYY-MM-DD
- - FINDINGS: 
- - - - Date columns do match the format❌
- - - - sls_order_dt column has some invalid data❌
 */
-- check if there are negatives in the date columns
SELECT
    sls_order_dt
FROM
    bronze.crm_sales_details
WHERE
    sls_order_dt < 0;

--check if is 0
SELECT
    sls_order_dt
FROM
    bronze.crm_sales_details
WHERE
    sls_order_dt = 0
    OR LEN (sls_order_dt) != 8 -- most columns are in the format ;YYYYMMDD. This checks for those that don't
    OR sls_order_dt > 20500101 -- check for sales done in the future/ boundaries of the business operations
    OR sls_order_dt < 19000101;

-- check for sales done before start of the business
-- Repeat Check with Shipping date
-- Check passes✅
SELECT
    sls_ship_dt
FROM
    bronze.crm_sales_details
WHERE
    sls_ship_dt = 0
    OR LEN (sls_ship_dt) != 8
    OR sls_ship_dt > 20500101
    OR sls_ship_dt < 19000101;

-- Repeat Check with Due date
-- Check passes✅
SELECT
    sls_due_dt
FROM
    bronze.crm_sales_details
WHERE
    sls_due_dt = 0
    OR LEN (sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

/*
Hypotheses:
1. Shipping date must be after the order date
2. Due date must be the same as the shipping date or after it 
 */
/*
- Check: Hypotheses
- - FINDINGS:  Order tracking information is chronologically correct ✅
 */
SELECT
    *
FROM
    bronze.crm_sales_details
WHERE
    sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt
    OR sls_due_dt < sls_ship_dt;

/*
- Check for nulls or negative numbers in sales data
- - CHECK: signed values and nulls
- - EXPECTATION: No results
- - FINDINGS: some null values ❌
 */
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM
    bronze.crm_sales_details
WHERE
    sls_sales != sls_price * sls_quantity
    OR sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR sls_sales <= 0
    OR sls_quantity <= 0
    OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;

/* 
The findings show poor data quality in the sales data columns; sls_sales,sls_quantity,sls_price.
This calls for consultaion with the data experts. 
The solutions could be(refer to the business rules in the root README.md):
1. Data issues will be fixed in the source systems
2. Data issues should be fixed in the warehouse
 */