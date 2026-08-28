
/*
- Check for unwanted spaces
- - CHECK: spaces at start or end of data
- - EXPECTATION: No results
- - FINDINGS: prd_id: No unwanted spaces✅
 */

SELECT *
FROM  silver.erp_px_cat_g1v2
WHERE  cat != TRIM(CHAR(13) + CHAR(10) + ' ' FROM cat);

SELECT *
FROM  silver.erp_px_cat_g1v2
WHERE  subcat != TRIM(CHAR(13) + CHAR(10) + ' ' FROM subcat);

SELECT *
FROM  silver.erp_px_cat_g1v2
WHERE  maintenance != TRIM(CHAR(13) + CHAR(10) + ' ' FROM maintenance);

/*
    - Check for consistency of low cardinality columns
    - - CHECK: values within a specific range of options
    - - EXPECTATION: Results to match known list of option 
    - - FINDINGS: No extra options ✅
*/
select DISTINCT 
maintenance
FROM  silver.erp_px_cat_g1v2;

select DISTINCT 
cat
FROM  silver.erp_px_cat_g1v2;

select DISTINCT 
subcat
FROM  silver.erp_px_cat_g1v2;