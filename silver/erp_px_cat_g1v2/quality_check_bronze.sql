
/*
- Check for unwanted spaces
- - CHECK: spaces at start or end of data
- - EXPECTATION: No results
- - FINDINGS: prd_id: trailing Spaces in maintenance data❌
 */

SELECT *
FROM  bronze.erp_px_cat_g1v2
WHERE  cat != TRIM(CHAR(13) + CHAR(10) + ' ' FROM cat);

SELECT *
FROM  bronze.erp_px_cat_g1v2
WHERE  subcat != TRIM(CHAR(13) + CHAR(10) + ' ' FROM subcat);

SELECT TRIM(CHAR(13) + CHAR(10) + ' ' FROM maintenance)
FROM  bronze.erp_px_cat_g1v2
WHERE  maintenance != TRIM(CHAR(13) + CHAR(10) + ' ' FROM maintenance);

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: There are some extra options in the maintenance column ❌
*/
select DISTINCT 
maintenance
FROM  bronze.erp_px_cat_g1v2;

select DISTINCT 
cat
FROM  bronze.erp_px_cat_g1v2;

select DISTINCT 
subcat
FROM  bronze.erp_px_cat_g1v2;