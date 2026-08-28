INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)
(
    SELECT 
        REPLACE(cid, '-', '') AS cid,
        CASE WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(CHAR(13) + CHAR(10) + ' ' FROM cntry) = ' ' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(CHAR(13) + CHAR(10) + ' ' FROM cntry)
        END AS cntry
    FROM   
        bronze.erp_loc_a101
    );

SELECT *
FROM   silver.erp_loc_a101;