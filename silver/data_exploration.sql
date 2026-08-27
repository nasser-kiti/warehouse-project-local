-- Exploring the relationship between the CRM  sales and product tables --
SELECT
    TOP 1000 *
from
    bronze.crm_sales_details;

SELECT
    TOP 1000 *
from
    bronze.crm_cust_info;

-----------------------------------------------------------------------------
/*
- The customer id (cust_id) in bronze.crm_cst_info matches the one (sls_cst_id) in bronze.crm_sales_details
 */
-----------------------------------------------------------------------------
-- Exploring the relationship between the CRM  and ERP customer information  tables --
SELECT
    TOP 1000 *
from
    bronze.crm_cust_info;

SELECT
    TOP 1000 *
from
    bronze.erp_cust_az12;

-----------------------------------------------------------------------------
/*
- The bronze.erp_cust_az12 table hold biodata about the customers
- - Some of the gender info ends with a newline
-  The [cst_key] column in bronze.crm_cust_info can be joined to [cid] in bronze.erp_cust_az12
 */
-----------------------------------------------------------------------------
-- Exploring the relationship between the ERP and CRM product tables --
SELECT
    TOP 1000 *
from
    bronze.crm_cust_info;

SELECT
    TOP 1000 *
from
    bronze.erp_loc_a101;

-----------------------------------------------------------------------------
/*
- The first 5 characters of the product key (prd_key) in bronze.crm_prd_info are the category id (id) in bronze.erp_px_cat_g1v2
- - The category id has an underscore(_) as a separator while the product key in the products table uses a hyphen(-)
 */
-----------------------------------------------------------------------------
-- Exploring the relationship between the ERP and CRM product tables --
SELECT
    TOP 1000 *
from
    bronze.crm_prd_info;

SELECT
    TOP 1000 *
from
    bronze.erp_px_cat_g1v2;

-----------------------------------------------------------------------------
/*
- The first 5 characters of the product key (prd_key) in bronze.crm_prd_info are the category id (id) in bronze.erp_px_cat_g1v2
- - The category id has an underscore(_) as a separator while the product key in the products table uses a hyphen(-)
- - The product table has cost historisation on product cost using the [prd_start_dt] and [prd_start_dt] columns
- Some of the values of maintenance column end with a newline
 */
-----------------------------------------------------------------------------
-- Exploring the relationship between the CRM  sales and product tables --
SELECT
    TOP 1000 *
from
    bronze.crm_sales_details;

SELECT
    TOP 1000 *
from
    bronze.crm_prd_info;

-----------------------------------------------------------------------------
/*
- The sales product key (sls_prd_key) excludes the category id (id) in bronze.erp_px_cat_g1v2
- IThe sales table also contains details of the order/sale
 */
-----------------------------------------------------------------------------