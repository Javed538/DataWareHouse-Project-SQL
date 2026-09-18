-- =============================================================================
-- File: measure_exploration.sql
-- Purpose: Metric & High-Level Summary Exploration
-- Description: Computes key summary statistics (Sum, Avg, Min, Max) 
--              for numerical business metrics across Gold layer tables.
-- Target Engine: Microsoft SQL Server (T-SQL)
-- Layer Target: Gold Layer (Facts & Dimensions)
-- =============================================================================

-- =============================================================================
-- 1. High-Level Revenue & Sales KPIs
-- Purpose: Calculate global sales performance, units sold, and average transaction values.
-- =============================================================================
SELECT 
    SUM(sales_amount) AS total_revenue,
    AVG(sales_amount) AS avg_order_value,
    MIN(sales_amount) AS min_sales_amount,
    MAX(sales_amount) AS max_sales_amount,
    SUM(quantity) AS total_units_sold,
    AVG(quantity) AS avg_units_per_order,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;


-- =============================================================================
-- 2. Product Catalog Pricing Exploration
-- Purpose: Analyze minimum, maximum, and average product price distribution.
-- =============================================================================
SELECT 
    MIN(cost) AS min_product_cost,
    MAX(cost) AS max_product_cost,
    AVG(cost) AS avg_product_cost,
    COUNT(product_key) AS total_catalog_items
FROM gold.dim_products;


-- =============================================================================
-- 3. Average Order Value (AOV) by Order Level
-- Purpose: Aggregate metrics to the unique order boundary to calculate true basket size.
-- =============================================================================
WITH order_aggregates AS (
    SELECT 
        order_number,
        SUM(sales_amount) AS total_order_value,
        SUM(quantity) AS total_order_items
    FROM gold.fact_sales
    GROUP BY order_number
)
SELECT 
    AVG(total_order_value) AS avg_basket_value,
    MIN(total_order_value) AS min_basket_value,
    MAX(total_order_value) AS max_basket_value,
    AVG(total_order_items) AS avg_items_per_basket
FROM order_aggregates;
