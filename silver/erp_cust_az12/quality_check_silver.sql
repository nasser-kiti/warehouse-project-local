/*
- - CHECK:  timetravellers
- - EXPECTATION: Date columns must be YYYY-MM-DD
- - FINDINGS:  No timetravellers ✅
 */
SELECT DISTINCT bdate
FROM   silver.erp_cust_az12
WHERE bdate > GETDATE();

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS:  Only three options✅
*/
SELECT DISTINCT gen
FROM   silver.erp_cust_az12;
