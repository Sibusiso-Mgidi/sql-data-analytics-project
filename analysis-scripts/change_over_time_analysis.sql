/*
===============================================================================
Change Over Time Analysis (Optimized)
===============================================================================
Purpose:
    - Reduce repeated function calls for improved performance.
    - Improve readability while maintaining identical output.

Function used:
    - CTE
===============================================================================
*/

WITH sales AS (
    SELECT
        order_date,
        sales_amount,
        customer_key,
        quantity,

        -- Pre-calc for YEAR() + MONTH()
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,

        -- Pre-calc for DATETRUNC()
        DATETRUNC(month, order_date) AS order_month_start,

        -- Pre-calc for FORMAT()
        FORMAT(order_date, 'yyyy-MMM') AS order_month_label
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
)

-- ===========================
-- 1. YEAR + MONTH Breakdown
-- ===========================
SELECT
    order_year,
    order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- ===========================
-- 2️. DATETRUNC(MONTH) Version
-- ===========================
SELECT
    order_month_start AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY order_month_start
ORDER BY order_month_start;


-- ===========================
-- 3️. FORMAT(MONTH) Version
-- ===========================
SELECT
    order_month_label AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY order_month_label
ORDER BY order_month_label;
