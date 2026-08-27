-----------------------------------------------------------------------------
-- DATA CLEANING --
-----------------------------------------------------------------------------
INSERT INTO silver.crm_cust_info 
(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
(
    SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    --- Applying UPPER() to catch any future data that comes in as lower case --
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END cst_marital_status,  -- Normalise the marital status to readable values
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END cst_gndr,  -- Normalise the gender to readable values
    cst_create_date
FROM
    (
        -- Remove duplicates
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    cst_id
                ORDER BY
                    cst_create_date DESC
            ) as flag_last
        FROM
            bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
WHERE
    flag_last = 1 -- Use the most recent data 
);
