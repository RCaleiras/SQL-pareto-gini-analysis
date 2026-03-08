"-- ========================================================================================
-- PURPOSE: Perform a Pareto Analysis (80/20 Rule) + Gini Coefficient (Inequality Metric) to identify customer concentration.
-- TARGET: Find the minimum number of customers that represent 80% of total revenue.
-- AUTHOR: Rui Caleiras
-- ========================================================================================

-- Declare the threshold variable for easy adjustments (e.g., 0.70, 0.80, 0.90)
DECLARE target_sales_pct FLOAT64 DEFAULT 0.80;

-- CTE 1: Calculate raw sales per transaction and filter invalid data
WITH base_sales AS (
  SELECT 
    CustomerID,
    (Quantity * UnitPrice) as sales
  FROM `pareto-analysis-sql.pareto.sales`
  WHERE CustomerID IS NOT NULL -- Ensures data quality by removing anonymous transactions
),

-- CTE 2: Aggregate total revenue at the customer level
customer_sales AS (
  SELECT 
    CustomerID,
    SUM(sales) as customer_revenue
  FROM base_sales
  GROUP BY CustomerID
  HAVING customer_revenue > 0 -- Focus only on customers with a positive financial impact
),

-- CTE 3: Calculate running totals and rankings using Window Functions
ranked AS (
  SELECT
    CustomerID,
    customer_revenue,
    ROW_NUMBER() OVER(ORDER BY customer_revenue DESC) AS running_customers,
    COUNT(*) OVER() AS total_customers,
    -- Compute cumulative revenue from highest to lowest spender
    SUM(customer_revenue) OVER(ORDER BY customer_revenue DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_revenue,
    SUM(customer_revenue) OVER() as total_revenue
  FROM customer_sales
),

-- CTE 4: Calculation for Gini: (2 * Sum of (rank * revenue) / (n * Sum of revenue)) - (n + 1) / n
-- This is a standard statistical approach for discrete data
gini_calc AS (
  SELECT
    (2 * SUM(running_customers * customer_revenue) / (MAX(total_customers) * SUM(customer_revenue))) 
    - (MAX(total_customers) + 1) / MAX(total_customers) AS gini_index
  FROM ranked
),

-- CTE 5: Transform absolute values into cumulative percentages
with_pct AS (
  SELECT
    *,
    running_revenue / total_revenue as running_sales_share,
    running_customers / CAST(total_customers AS FLOAT64) as running_pct_customers
  FROM ranked
)

-- FINAL SELECT: Identify the first customer that crosses the % threshold
-- This returns a single row representing the 'tipping point' of the analysis
SELECT
  MIN(running_customers) AS number_of_customers,
  ROUND(MIN(running_revenue), 2) AS running_revenue,
  ROUND(MIN(total_revenue), 2) AS total_revenue,
  target_sales_pct * 100 AS target_sales_percent,
  ROUND(MIN(total_revenue * target_sales_pct), 2) AS target_sales_threshold,
  ROUND(MIN(running_sales_share) * 100, 2) as actual_revenue_pct,
  ROUND(MIN(running_pct_customers) * 100, 2) as customers_pct_share,
  CASE 
    WHEN MIN(g.gini_index) > 0.7 THEN 'High Concentration (Risky)'
    WHEN MIN(g.gini_index) BETWEEN 0.4 AND 0.7 THEN 'Moderate (Healthy Pareto)'
    ELSE 'Low Concentration (Diverse)'
  END AS distribution_health
FROM with_pct
CROSS JOIN gini_calc g
WHERE running_sales_share >= target_sales_pct;"
