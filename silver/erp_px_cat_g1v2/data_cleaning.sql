INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
(
    SELECT 
        id,
        cat,
        subcat,
        TRIM(CHAR(13) + CHAR(10) + ' ' FROM maintenance) AS maintenance
    FROM   
        bronze.erp_px_cat_g1v2 
);

SELECT *
FROM   silver.erp_px_cat_g1v2;