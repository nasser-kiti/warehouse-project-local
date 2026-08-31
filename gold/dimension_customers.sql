/* SELECT
cst_id,
COUNT(*) --💡 After joining the table, check if any duplicates were introduced by the join logic
FROM
( */
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
--     ) a
-- WHERE bdate is NULL
-- GROUP BY
--     a.cst_id
-- HAVING
--     COUNT(*) > 1;
-- Data integration on the gender column since we have two columns, eeach from a different table
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
--=============================--
CREATE VIEW
    gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            ci.cst_id
    ) as customer_key, -- generating a surrogate key for more control over how to connect the data model
    -- Update the columns to more freindly names following naming conventions
    -- Sort the column order to one that is most relevant for the entity
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --data integration for the (2) gender columns -> the CRM is the source of the master data
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ci.cst_marital_status AS marital_status,
    li.cntry AS country,
    ca.bdate AS birth_date,
    ci.cst_create_date AS creation_date
FROM
    silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS li ON ci.cst_key = li.cid;

GO

SELECT DISTINCT gender FROM gold.dim_customers;