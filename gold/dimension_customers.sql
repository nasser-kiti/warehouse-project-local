-- See dim_customer_checks.sql for the data-quality checks and gender-integration
-- analysis that informed the logic in this view.

CREATE VIEW
    gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            ci.cst_id
    ) as customer_key, -- generating a surrogate key for more control over how to connect the data model
    -- Update the columns to more friendly names following naming conventions
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
