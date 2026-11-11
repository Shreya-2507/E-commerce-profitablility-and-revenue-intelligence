-- =====================================================
-- PROJECT: E-Commerce Profitability & Revenue Intelligence
-- SECTION: Exploratory Data Analysis (EDA)
-- PURPOSE: Explore sales, profitability, discount patterns,
--          and unusual profit values across categories.
-- =====================================================


-- 1. Category Sales Analysis
-- Identify product categories generating the highest sales
-- to understand overall revenue contribution.

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;


-- 2. Category Profitability Analysis
-- Compare total profit across categories to identify
-- the strongest contributors to business profitability.

SELECT
    category,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_profit DESC;


-- 3. Sub-Category Profitability Analysis
-- Identify poorly performing and loss-making sub-categories
-- by ranking them according to total profit.

SELECT
    category,
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category, sub_category
ORDER BY total_profit ASC;


-- 4. Discount Distribution Analysis
-- Group transactions into discount ranges to examine
-- discount patterns and their relationship with sales,
-- quantity sold, and profitability.

SELECT
    category,
    sub_category,

    CASE
        WHEN discount = 0 THEN '0% (No Discount)'
        WHEN discount <= 0.10 THEN '1-10%'
        WHEN discount <= 0.20 THEN '11-20%'
        WHEN discount <= 0.30 THEN '21-30%'
        WHEN discount <= 0.40 THEN '31-40%'
        ELSE 'Above 40%'
    END AS discount_group,

    COUNT(*) AS transaction_count,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit

FROM superstore

GROUP BY 1, 2, 3

ORDER BY 1, 2, 3;


-- 5. Highest Profit Transactions
-- Examine the top 5 transactions with the highest profit
-- to understand which transactions generated the most profit.

SELECT
    category,
    sub_category,
    sales,
    quantity,
    discount,
    profit
FROM superstore
ORDER BY profit DESC
LIMIT 5;


-- 6. Lowest Profit Transactions
-- Examine the 5 transactions with the lowest profit
-- to identify potentially loss-making transactions.

SELECT
    category,
    sub_category,
    sales,
    quantity,
    discount,
    profit
FROM superstore
ORDER BY profit ASC
LIMIT 5;
