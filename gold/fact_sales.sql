-- See checks_fact_sales to preview this view and check referential
-- integrity against gold.dim_customers / gold.dim_products after creation.

CREATE VIEW gold.fact_sales 
AS
SELECT
    -- column sorting schema: KEYS | DATES | MEASURES
    s.sls_ord_num AS order_number,
    -- Replace the id columns of the fact table with the surrogate key columns
    dp.product_key,
    dc.customer_key,
    s.sls_order_dt AS order_date,
    s.sls_ship_dt AS shipping_date,
    s.sls_due_dt AS due_date,
    s.sls_sales AS sales_amount,
    s.sls_quantity AS quantity,
    s.sls_price AS price
FROM silver.crm_sales_details AS s
-- Using the surrogate keys in the dimension tables to join to the fact table
LEFT JOIN gold.dim_products as dp on s.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers as dc on s.sls_cust_id = dc.customer_id;

GO
