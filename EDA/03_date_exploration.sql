-- =============================================================================
-- File:date_exploration.sql
-- Purpose: Temporal & Date Range Exploration
-- Description: Verifies historical date boundaries, identifies time gaps,
--              and evaluates transaction distribution across time dimensions.
-- Target Engine: Microsoft SQL Server (T-SQL)
-- Layer Target: Gold Layer (Fact Tables)
-- =============================================================================

-- =============================================================================
-- 1. Date Range & Lifespan Boundaries
-- Purpose: Determine start date, end date, and overall historical duration spanned.
-- =============================================================================
SELECT 
    MIN(order_date) AS earliest_order_date,
    MAX(order_date) AS latest_order_date,
    DATEDIFF(day, MIN(order_date), MAX(order_date)) AS total_days_spanned,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS total_months_spanned,
    DATEDIFF(year, MIN(order_date), MAX(order_date)) AS total_years_spanned
FROM gold.fact_sales;


-- =============================================================================
-- 2. Customer Age & Birthdate Boundary Exploration
-- Purpose: Audit demographic date boundaries (youngest & oldest customer).
-- =============================================================================
SELECT 
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate,
    DATEDIFF(year, MIN(birthdate), GETDATE()) AS max_customer_age,
    DATEDIFF(year, MAX(birthdate), GETDATE()) AS min_customer_age
FROM gold.dim_customers;


-- =============================================================================
-- 3. Yearly & Monthly Order Volume Distribution
-- Purpose: Identify record volumes per year/month to ensure no missing periods.
-- =============================================================================
-- Annual Distribution
SELECT 
    YEAR(order_date) AS order_year,
    COUNT(order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS unique_active_customers
FROM gold.fact_sales
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Monthly Breakdown for Granular Time Assessment
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(order_number) AS total_orders,
    SUM(sales_amount) AS monthly_sales_revenue
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


-- =============================================================================
-- 4. Shipping Lead Time & Fulfillment Delay Exploration
-- Purpose: Measure temporal differences between order date and shipping date.
-- =============================================================================
SELECT 
    MIN(DATEDIFF(day, order_date, shipping_date)) AS min_shipping_days,
    MAX(DATEDIFF(day, order_date, shipping_date)) AS max_shipping_days,
    AVG(DATEDIFF(day, order_date, shipping_date)) AS avg_shipping_days
FROM gold.fact_sales
WHERE shipping_date IS NOT NULL;
