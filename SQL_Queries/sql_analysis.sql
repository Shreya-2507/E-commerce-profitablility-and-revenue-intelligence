```sql
-- ============================================================
-- PROJECT: E-Commerce Profitability & Revenue Intelligence
-- SECTION: Revenue, Profitability & Discount Analysis
-- PURPOSE: Evaluate business performance, identify profitability
--          risks, analyze discount patterns, and uncover
--          potential business growth opportunities.
-- ============================================================


-- ============================================================
-- 1. REVENUE ANALYSIS
-- ============================================================

-- Q1. Which categories generate the highest revenue?
-- Identify the top revenue-generating product categories
-- to understand their contribution to overall business sales.

SELECT 
    category,
    ROUND(SUM(sales), 2) AS category_total_sales
FROM superstore
GROUP BY category
ORDER BY category_total_sales DESC;


-- Q2. Which sub-categories generate the highest revenue?
-- Identify the sub-categories contributing the most to
-- overall sales performance.

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS subcategory_total_sales
FROM superstore
GROUP BY sub_category
ORDER BY subcategory_total_sales DESC;


-- Q3. Which sub-categories contribute most to total sales?
-- Calculate each sub-category's percentage contribution
-- to total revenue to identify major revenue contributors.

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,

    ROUND(
        SUM(sales) * 100.0 /
        NULLIF(SUM(SUM(sales)) OVER(), 0),
        2
    ) AS sales_contribution_percent

FROM superstore
GROUP BY sub_category
ORDER BY total_sales DESC;


-- Q4. Which regions generate the highest revenue?
-- Compare regional sales performance to identify
-- the strongest revenue-generating geographical regions.

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_revenue
FROM superstore
GROUP BY region
ORDER BY total_revenue DESC;



-- ============================================================
-- 2. PROFITABILITY ANALYSIS
-- ============================================================

-- Q5. Which categories generate the highest profit?
-- Compare total profit across product categories
-- to identify the strongest contributors to profitability.

SELECT 
    category,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;


-- Q6. Which sub-categories operate at a loss?
-- Identify loss-making sub-categories by ranking
-- their total profit from lowest to highest.

SELECT 
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY sub_category
ORDER BY total_profit ASC;


-- Q7. Which sub-categories have the lowest profit margins?
-- Calculate profit margins across sub-categories
-- to identify segments with weak profitability.

SELECT
    sub_category,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent

FROM superstore
GROUP BY sub_category
ORDER BY profit_margin_percent ASC;


-- Q8. Are high-revenue sub-categories necessarily profitable?
-- Compare revenue, total profit, and profit margins
-- to investigate the relationship between sales and profitability.

SELECT
    sub_category,

    ROUND(SUM(sales), 2) AS revenue,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent

FROM superstore
GROUP BY sub_category
ORDER BY revenue DESC;



-- ============================================================
-- 3. DISCOUNT ANALYSIS
-- ============================================================

-- Q9. Which sub-categories receive the highest discounts?
-- Calculate average discount percentages across sub-categories
-- to understand discount distribution across product segments.

SELECT
    sub_category,
    ROUND(AVG(discount) * 100.0, 2) AS average_discount_percent
FROM superstore
GROUP BY sub_category
ORDER BY average_discount_percent DESC;


-- Q10. How do discounts relate to quantity sold?
-- Group transactions into discount ranges and analyze
-- their relationship with quantity sold, revenue, and profit.

SELECT
    sub_category,

    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Medium Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END AS discount_group,

    SUM(quantity) AS total_quantity,

    ROUND(SUM(sales), 2) AS revenue,

    ROUND(SUM(profit), 2) AS total_profit

FROM superstore
GROUP BY sub_category, discount_group
ORDER BY sub_category, discount_group;


-- Q11. How do discounts relate to profit margins?
-- Evaluate profitability across different discount ranges
-- to identify discount levels associated with lower margins.

SELECT

    CASE
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Medium Discount'
        WHEN discount <= 0.30 THEN 'High Discount'
        ELSE 'Very High Discount'
    END AS discount_group,

    ROUND(SUM(sales), 2) AS total_sales,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent

FROM superstore
GROUP BY discount_group
ORDER BY discount_group;


-- Q12. Are some sub-categories profitable despite high discounts?
-- Identify profitable sub-category and regional combinations
-- operating under discounts greater than 20%.

SELECT
    sub_category,
    region,

    CASE
        WHEN discount > 0.20 AND discount <= 0.30
            THEN 'High Discount'
        WHEN discount > 0.30
            THEN 'Very High Discount'
    END AS discount_group,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent

FROM superstore

WHERE discount > 0.20

GROUP BY sub_category, region, discount_group

HAVING SUM(profit) > 0

ORDER BY discount_group DESC, region;



-- ============================================================
-- 4. BUSINESS PERFORMANCE ANALYSIS
-- ============================================================

-- Q13. Which sub-categories are strong performers?
-- Evaluate revenue, profit, profit margins, and average discounts
-- to identify sub-categories with strong business performance.

SELECT
    sub_category,

    ROUND(SUM(sales), 2) AS total_sales,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent,

    ROUND(AVG(discount) * 100.0, 2) AS average_discount_percent

FROM superstore
GROUP BY sub_category

ORDER BY total_sales DESC, total_profit DESC, profit_margin_percent DESC;


-- Q14. Which sub-categories need improvement?
-- Rank sub-categories by total profit to identify
-- poorly performing and loss-making business segments.

SELECT
    sub_category,

    ROUND(SUM(sales), 2) AS total_sales,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent,

    ROUND(AVG(discount) * 100.0, 2) AS average_discount_percent

FROM superstore
GROUP BY sub_category

ORDER BY total_profit ASC;


-- Q15. Which sub-categories represent potential growth opportunities?
-- Analyze revenue contribution, quantity sold, total profit,
-- and profit margins to identify potential growth opportunities.

SELECT
    sub_category,

    ROUND(SUM(sales), 2) AS total_sales,

    SUM(quantity) AS total_sold_quantity,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent,

    ROUND(
        SUM(sales) * 100.0 /
        NULLIF(SUM(SUM(sales)) OVER(), 0),
        2
    ) AS revenue_contribution_percent

FROM superstore
GROUP BY sub_category

ORDER BY revenue_contribution_percent DESC;


-- Q16. Which areas require further investigation?
-- Identify loss-making sub-categories and profitable segments
-- with profit margins below 5% for further business investigation.

SELECT
    sub_category,

    ROUND(SUM(sales), 2) AS total_sales,

    SUM(quantity) AS total_sold_quantity,

    ROUND(SUM(profit), 2) AS total_profit,

    ROUND(
        SUM(profit) * 100.0 /
        NULLIF(SUM(sales), 0),
        2
    ) AS profit_margin_percent,

    ROUND(
        SUM(sales) * 100.0 /
        NULLIF(SUM(SUM(sales)) OVER(), 0),
        2
    ) AS revenue_contribution_percent

FROM superstore

GROUP BY sub_category

HAVING
    SUM(profit) <= 0
    OR (
        SUM(profit) > 0
        AND SUM(profit) * 100.0 /
            NULLIF(SUM(sales), 0) < 5
    )

ORDER BY profit_margin_percent ASC;
