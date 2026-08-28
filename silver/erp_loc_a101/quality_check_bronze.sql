/*
- Check for unwanted spaces
- - CHECK: spaces at start or end of data
- - EXPECTATION: No results
- - FINDINGS: prd_id: Trailing Spaces❌
 */
-- Example check with the sls_ord_num column --
SELECT cntry
FROM     bronze.erp_loc_a101
WHERE    cntry != TRIM(CHAR(13) + CHAR(10) + ' ' FROM cntry);

-- compare customer ids
-- FINDINGS: crm_cust_info has no hyphen ❌
SELECT TOP 5 cid FROM bronze.erp_loc_a101;
SELECT TOP 5 * FROM silver.crm_cust_info;

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: There are some null columns alongside the options expected options ❌
*/
select DISTINCT cntry from bronze.erp_loc_a101 ORDER BY cntry;