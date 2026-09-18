-- =============================================================================
-- File: Ranking_exploration.sql
-- Purpose: Ranking & Top/Bottom Entity Exploration
-- Description: Uses T-SQL window functions to identify top-performing products,
--              highest-value customers, and performance distribution rankings.
-- Target Engine: Microsoft SQL Server (T-SQL)
-- Layer Target: Gold Layer (Star Schema Facts & Dimensions)
-- =============================================================================

-- =============================================================================
-- 1. Top 5 Products by Revenue per Category
-- Purpose: Rank top-selling products partitioned within each category.
-- =============================================================================
WITH ranked_products AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        SUM(f.quantity) AS total_units_sold,
        DENSE_RANK() OVER (
            PARTITION BY p.category 
            ORDER BY SUM(f.sales_amount) DESC
        ) AS rank_in_category
    FROM gold.fact_sales f
    JOIN gold.dim_products p ON f.product_key = p.product_key
    GROUP BY p.category, p.product_name
)
SELECT 
    category,
    rank_in_category,
    product_name,
    total_revenue,
    total_units_sold
FROM ranked_products
WHERE rank_in_category <= 5
ORDER BY category, rank_in_category;


-- =============================================================================
-- 2. Top 10 High-Value Customers Globally
-- Purpose: Identify top customer accounts by lifetime spend contribution.
-- =============================================================================
SELECT TOP 10
    c.customer_key,
    c.country,
    SUM(f.sales_amount) AS total_lifetime_spend,
    COUNT(DISTINCT f.order_number) AS total_orders,
    DENSE_RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS global_rank
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.country
ORDER BY total_lifetime_spend DESC;


-- =============================================================================
-- 3. Bottom 5 Products by Revenue (Identify Low Performers)
-- Purpose: Pinpoint underperforming items to evaluate potential catalog pruning.
-- =============================================================================
WITH product_performance AS (
    SELECT 
        p.product_key,
        p.product_name,
        p.category,
        ISNULL(SUM(f.sales_amount), 0) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY ISNULL(SUM(f.sales_amount), 0) ASC) AS bottom_rank
    FROM gold.dim_products p
    LEFT JOIN gold.fact_sales f ON p.product_key = f.product_key
    GROUP BY p.product_key, p.product_name, p.category
)
SELECT 
    bottom_rank,
    product_name,
    category,
    total_revenue
FROM product_performance
WHERE bottom_rank <= 5
ORDER BY bottom_rank ASC;
