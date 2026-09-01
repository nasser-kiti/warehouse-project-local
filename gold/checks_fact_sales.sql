/* =============================================================================
   Validation checks for gold.fact_sales
   Run these after (re)creating the view to confirm it looks correct and
   that every fact row successfully resolves to a customer and product
   dimension. A non-empty result from the integrity check means a fact
   row has no matching dimension row and should be investigated.
   ============================================================================= */

-- 1. Preview the finished fact table
SELECT * FROM gold.fact_sales;

-- 2. Referential integrity check and flag any fact rows that failed to join
-- to a dimension (should return zero rows in a healthy load)
SELECT * FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc ON fs.customer_key = dc.customer_key
LEFT JOIN gold.dim_products AS dp ON fs.product_key = dp.product_key
WHERE dc.customer_key IS NULL
OR dp.product_key IS NULL;
