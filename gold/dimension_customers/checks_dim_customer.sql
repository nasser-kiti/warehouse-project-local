/* =============================================================================
   Exploration notes for gold.dim_customers
   These queries were used during development to investigate data quality
   after joining the CRM/ERP source tables, and to decide how to integrate
   the two gender columns (CRM vs ERP) into a single column.
   They are not part of the production view (see dimension_customers.sql)
   and are kept here for reference / re-use if the source data changes.
   ============================================================================= */

-- 1. Preview the joined result across CRM + ERP customer/location tables
SELECT
    ci.cst_id,
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    ci.cst_marital_status,
    ci.cst_gndr,
    ci.cst_create_date,
    ca.bdate,
    ca.gen,
    li.cntry
FROM
    silver.crm_cust_info AS ci
    -- Considering the CRM customer information as the master table, using a left join instead of inner join ensures no data is lost.
    LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS li ON ci.cst_key = li.cid;
GO

-- 2. Check if the join introduced duplicate customer records
-- (i.e. more than one row per cst_id after the left joins)
SELECT
    cst_id,
    COUNT(*) --💡 After joining the table, check if any duplicates were introduced by the join logic
FROM
    (
        SELECT
            ci.cst_id,
            ci.cst_key,
            ci.cst_firstname,
            ci.cst_lastname,
            ci.cst_marital_status,
            ci.cst_gndr,
            ci.cst_create_date,
            ca.bdate,
            ca.gen,
            li.cntry
        FROM
            silver.crm_cust_info AS ci
            LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
            LEFT JOIN silver.erp_loc_a101 AS li ON ci.cst_key = li.cid
    ) a
WHERE
    bdate is NULL
GROUP BY
    a.cst_id
HAVING
    COUNT(*) > 1;
GO

-- 3. Data integration on the gender column since we have two columns, each from a different table
SELECT DISTINCT
    ci.cst_gndr,
    ca.gen
FROM
    silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS li ON ci.cst_key = li.cid
ORDER BY
    1,
    2;
GO

-- Findings show some differences in the gender data. Such scenarios call for expert interviews to agree on a data integration strategy
----------

-- 4. Test the proposed gender integration logic before adding it to the view
SELECT DISTINCT
    ci.cst_gndr,
    ca.gen,
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS new_gen
FROM
    silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS li ON ci.cst_key = li.cid
ORDER BY
    1,
    2;
GO

-- 5. Post-deployment sanity check to confirm gold.dim_customers only contains expected gender values
SELECT DISTINCT gender FROM gold.dim_customers;
