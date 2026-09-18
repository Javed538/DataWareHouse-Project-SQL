-- =============================================================================
-- File: dimension_exploration.sql
-- Purpose: Categorical & Attribute Exploration across Dimension Tables
-- Description: Analyzes geographic distributions, product catalog hierarchies,
--              and audits business key uniqueness in the Gold Layer.
-- Target Engine: Microsoft SQL Server (T-SQL)
-- Layer Target: Gold Layer (Star Schema Dimensions)
-- =============================================================================

-- =============================================================================
-- 1. Customer Geographic Distribution
-- Purpose: Identify regional concentration across country levels.
-- =============================================================================
SELECT 
    country,
    COUNT(customer_key) AS total_customers,
    ROUND(COUNT(customer_key) * 100.0 / SUM(COUNT(customer_key)) OVER(), 2) AS pct_share
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- =============================================================================
-- 2. Customer Segmentation & Demographic Breakdown
-- Purpose: Evaluate customer mix across gender and marital status (if applicable).
-- =============================================================================
SELECT 
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;


-- =============================================================================
-- 3. Product Catalog Hierarchy Analysis
-- Purpose: Understand product distribution across categories and sub-categories.
-- =============================================================================
SELECT
    category,
    subcategory,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category,subcategory
ORDER BY category, total_products DESC;


-- =============================================================================
-- 4. Business Key Uniqueness & Distinct Entity Audit
-- Purpose: Ensure surrogate keys map 1:1 with natural business keys (no duplicate entities).
-- =============================================================================
-- Check customer key vs. natural customer_id count
SELECT 
    COUNT(DISTINCT customer_key) AS total_surrogate_keys,
    COUNT(DISTINCT customer_id) AS total_natural_keys,
    COUNT(*) AS total_rows
FROM gold.dim_customers;

-- Check product key vs. natural product_id count
SELECT 
    COUNT(DISTINCT product_key) AS total_surrogate_keys,
    COUNT(DISTINCT product_id) AS total_natural_keys,
    COUNT(*) AS total_rows
FROM gold.dim_products;