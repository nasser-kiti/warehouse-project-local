SELECT top 3 *
FROM
silver.crm_prd_info;
SELECT top 3 * from silver.erp_px_cat_g1v2;
GO

/*SELECT prd_key, COUNT(*) 
FROM
( -- checking for duplicates*/
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
/*) b 
GROUP BY prd_key
HAVING count(*) > 1;*/
GO
/*============================*/



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
WHERE prd_end_dt is NULL;

GO
SELECT * from gold.dim_products;