/*
- Check for unwanted spaces
- - CHECK: spaces at start or end of data
- - EXPECTATION: No results
- - FINDINGS: prd_id: No results✅
 */
-- Example check with the sls_ord_num column --
SELECT cntry
FROM     silver.erp_loc_a101
WHERE    cntry != TRIM(CHAR(13) + CHAR(10) + ' ' FROM cntry);

-- compare customer ids
-- FINDINGS: ids are identical✅
SELECT TOP 5 cid FROM silver.erp_loc_a101;
SELECT TOP 5 * FROM silver.crm_cust_info;

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: Only the expected options ✅
*/
select DISTINCT cntry from silver.erp_loc_a101 ORDER BY cntry;