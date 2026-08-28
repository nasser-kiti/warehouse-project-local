/*
- - CHECK:  Vampires and timetravellers
- - EXPECTATION: Date columns must be YYYY-MM-DD
- - FINDINGS:  Multiple residents of Transylvania ❌
 */
SELECT DISTINCT bdate
FROM   bronze.erp_cust_az12
WHERE  bdate < '1926-01-01'
       OR bdate > GETDATE();

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: There are some null columns alongside the options expected options ❌
    - - We need to:
    - - - Store data with clear meaningful values instead of abbreviations. For example: Male instead of M or Single instead of S
    - - - Decide what to do with the null values. For this case, use a default value of 'n/a'
*/
SELECT DISTINCT REPLACE(gen, '\n', '')
FROM   bronze.erp_cust_az12;
