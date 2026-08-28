INSERT INTO
    silver.erp_cust_az12(
        cid,
        bdate,
        gen
    ) (
        SELECT 
            CASE 
                WHEN cid LIKE 'NAS%' 
                    THEN SUBSTRING(cid, 4, LEN(cid)) 
                ELSE cid 
            END AS cid,

            CASE 
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate,
            
            CASE 
                WHEN UPPER(TRIM(CHAR(13) + CHAR(10) + ' ' FROM gen)) IN ('F', 'FEMALE') THEN 'Female' -- simple TRIM was not working -> CHAR(13) = Carriage Return (\r / CR) — ASCII code 13
                WHEN UPPER(TRIM(CHAR(13) + CHAR(10) + ' ' FROM gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS gen
        FROM   bronze.erp_cust_az12
    );

    SELECT * FROM silver.erp_cust_az12;