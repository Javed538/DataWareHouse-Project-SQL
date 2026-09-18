-- =============================================================================
-- File: Magnitude_exploration.sql
-- Purpose: Magnitude & Distribution Comparison Exploration
-- Description: Measures relative scale, contribution percentages, and 
--              segmented distributions across core business dimensions.
-- Target Engine: Microsoft SQL Server (T-SQL)
-- Layer Target: Gold Layer (Star Schema Facts & Dimensions)
-- =============================================================================

-- =============================================================================
-- 1. Revenue & Quantity Breakdown by Product Category
-- Purpose: Evaluate total revenue contribution and volume share per category.
-- =============================================================================
SELECT 
    p.category,
    SUM(f.sales_amount) AS total_revenue,
    SUM(f.quantity) AS total_units_sold,
    ROUND(SUM(f.sales_amount) * 100.0 / SUM(SUM(f.sales_amount)) OVER(), 2) AS pct_revenue_share
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- =============================================================================
-- 2. Geographic Revenue Distribution
-- Purpose: Compare country-level magnitude to identify top revenue-generating markets.
-- =============================================================================
SELECT 
    c.country,
    COUNT(DISTINCT f.order_number) AS total_orders,
    SUM(f.sales_amount) AS total_revenue,
    ROUND(SUM(f.sales_amount) * 100.0 / SUM(SUM(f.sales_amount)) OVER(), 2) AS pct_revenue_share
FROM gold.fact_sales f
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_revenue DESC;


-- =============================================================================
-- 3. Customer Spend Tier Segmentation
-- Purpose: Group customers into spending brackets to inspect value distribution.
-- =============================================================================
WITH customer_spending AS (
    SELECT 
        c.customer_key,
        SUM(f.sales_amount) AS total_spent
    FROM gold.fact_sales f
    JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT 
    CASE 
        WHEN total_spent >= 5000 THEN 'VIP (>= $5,000)'
        WHEN total_spent BETWEEN 1000 AND 4999 THEN 'Mid-Tier ($1,000 - $4,999)'
        ELSE 'Low-Tier (< $1,000)'
    END AS spend_tier,
    COUNT(customer_key) AS customer_count,
    SUM(total_spent) AS aggregate_tier_revenue,
    ROUND(SUM(total_spent) * 100.0 / SUM(SUM(total_spent)) OVER(), 2) AS pct_tier_revenue
FROM customer_spending
GROUP BY 
    CASE 
        WHEN total_spent >= 5000 THEN 'VIP (>= $5,000)'
        WHEN total_spent BETWEEN 1000 AND 4999 THEN 'Mid-Tier ($1,000 - $4,999)'
        ELSE 'Low-Tier (< $1,000)'
    END
ORDER BY aggregate_tier_revenue DESC;
