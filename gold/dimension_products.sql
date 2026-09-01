-- See checks_dim_products.sql for the raw table previews and duplicate-key
-- check that informed this view.

CREATE VIEW gold.dim_products
AS
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
LEFT JOIN silver.erp_px_cat_g1v2  AS pc on p.cat_id = pc.id
WHERE prd_end_dt is NULL; -- filter the table to only have recent products since there is no need for historisation.

GO
