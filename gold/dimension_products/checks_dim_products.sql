/* =============================================================================
   Exploration notes for gold.dim_products
   These queries were used during development to inspect the raw source
   tables and check for duplicate product keys after joining CRM product
   info with the ERP product category table.
   They are not part of the production view (see dimension_products.sql)
   and are kept here for reference / re-use if the source data changes.
   ============================================================================= */

-- 1. Raw preview of the two source tables before any joins/transformations
SELECT TOP 3 *
FROM silver.crm_prd_info;

SELECT TOP 3 * FROM silver.erp_px_cat_g1v2;
GO

-- 2. Check for duplicate product keys introduced by the join
-- (i.e. more than one row per prd_key after joining to the category table)
SELECT
    prd_key,
    COUNT(*)
FROM
    ( -- checking for duplicates
        SELECT
            ROW_NUMBER() OVER (ORDER BY p.prd_start_dt, p.prd_key) AS product_key,
            p.prd_id AS product_id,
            p.prd_key AS product_number,
            p.prd_nm AS product_name,
            p.cat_id AS category_id,
            pc.cat AS category,
            pc.subcat AS subcategory,
            p.prd_line AS product_line,
            pc.maintenance,
            p.prd_cost AS product_cost,
            p.prd_start_dt AS start_date
        FROM
            silver.crm_prd_info AS p
            LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON p.cat_id = pc.id
        WHERE
            prd_end_dt is NULL -- filter the table to only have recent products since there is no need for historisation.
    ) b
GROUP BY
    prd_key
HAVING
    count(*) > 1;
GO

-- 3. Post-deployment sanity check to preview the finished view
SELECT * FROM gold.dim_products;
