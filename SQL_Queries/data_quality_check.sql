-- Data Quality Check: Identify missing values in key business columns.
-- Checks NULL values in sales, profit, discount, and quantity
-- to assess data completeness before performing analysis.


SELECT
    COUNT(*) FILTER (WHERE sales IS NULL) AS missing_sales,
    COUNT(*) FILTER (WHERE profit IS NULL) AS missing_profit,
    COUNT(*) FILTER (WHERE discount IS NULL) AS missing_discount,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS missing_quantity
FROM superstore;

SELECT
    COUNT(*) FILTER (WHERE sales IS NULL) AS missing_sales,
    COUNT(*) FILTER (WHERE profit IS NULL) AS missing_profit,
    COUNT(*) FILTER (WHERE discount IS NULL) AS missing_discount,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS missing_quantity
FROM superstore;


