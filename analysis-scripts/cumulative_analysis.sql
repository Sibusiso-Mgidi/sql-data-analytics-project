/*
================================================================================
Cumulative Metrics Overview
================================================================================
Objective:
    - Generate time-based cumulative insights for long-term performance tracking.
    - Compute yearly totals alongside running sales and moving average indicators.

Core Techniques Used:
    - Window functions: SUM() OVER(), AVG() OVER()
    - Time bucketing with DATETRUNC()

================================================================================
*/

-- ============================================================================
-- Yearly Sales Summary with Running & Moving Metrics
-- ============================================================================
SELECT
    sales_year,
    yearly_sales,
    SUM(yearly_sales) OVER (ORDER BY sales_year) AS cumulative_sales,
    AVG(yearly_avg_price) OVER (ORDER BY sales_year) AS rolling_avg_price
FROM (
    /*----------------------------------------------------------------------
      Step 1: Aggregate base metrics at the yearly level
    ----------------------------------------------------------------------*/
    SELECT
        DATETRUNC(year, order_date) AS sales_year,
        SUM(sales_amount) AS yearly_sales,
        AVG(price) AS yearly_avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) AS base;
