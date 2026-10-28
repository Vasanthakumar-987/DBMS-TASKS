-- TASK XIV: BUSINESS INTELLIGENCE AND AI DATA PREPARATION
USE amazon_db;

-- 1. Customer revenue and order-count analytics
SELECT
    u.user_id,
    u.name AS customer_name,
    COUNT(DISTINCT o.order_id) AS order_count,
    COALESCE(SUM(o.total_amount), 0.00) AS total_order_value,
    COALESCE(AVG(o.total_amount), 0.00) AS average_order_value
FROM `USER` AS u
LEFT JOIN ORDERS AS o ON o.user_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY total_order_value DESC;

-- 2. Rank products by sales value
WITH product_sales AS (
    SELECT p.product_id, p.title,
           COALESCE(SUM(i.quantity), 0) AS units_sold,
           COALESCE(SUM(i.quantity * i.price), 0.00) AS sales_value
    FROM PRODUCT AS p
    LEFT JOIN ORDER_ITEM AS i ON i.product_id = p.product_id
    GROUP BY p.product_id, p.title
)
SELECT product_id, title, units_sold, sales_value,
       RANK() OVER (ORDER BY sales_value DESC) AS sales_rank,
       ROW_NUMBER() OVER (ORDER BY sales_value DESC, product_id) AS row_num
FROM product_sales;

-- 3. Customer segmentation: simple, explainable rule-based groups
WITH customer_features AS (
    SELECT u.user_id, u.name,
           COUNT(o.order_id) AS order_count,
           COALESCE(SUM(o.total_amount), 0.00) AS total_spend,
           COALESCE(AVG(o.total_amount), 0.00) AS avg_order_value
    FROM `USER` AS u
    LEFT JOIN ORDERS AS o ON o.user_id = u.user_id
    GROUP BY u.user_id, u.name
)
SELECT user_id, name, order_count, total_spend, avg_order_value,
       CASE
           WHEN order_count = 0 THEN 'No Orders'
           WHEN total_spend >= 50000 THEN 'High Value'
           WHEN order_count >= 2 THEN 'Repeat Customer'
           ELSE 'Regular Customer'
       END AS customer_segment
FROM customer_features
ORDER BY total_spend DESC;

-- 4. AI-ready customer feature dataset (one row per customer)
SELECT
    u.user_id AS customer_id,
    COUNT(o.order_id) AS feature_order_count,
    COALESCE(SUM(o.total_amount), 0.00) AS feature_total_spend,
    COALESCE(AVG(o.total_amount), 0.00) AS feature_avg_order_value,
    COALESCE(MAX(o.order_date), '2000-01-01') AS feature_last_order_date
FROM `USER` AS u
LEFT JOIN ORDERS AS o ON o.user_id = u.user_id
GROUP BY u.user_id;

-- 5. AI-ready product demand features (one row per product)
SELECT
    p.product_id,
    p.price AS feature_current_price,
    COALESCE(SUM(i.quantity), 0) AS feature_units_sold,
    COUNT(DISTINCT i.order_id) AS feature_order_frequency
FROM PRODUCT AS p
LEFT JOIN ORDER_ITEM AS i ON i.product_id = p.product_id
GROUP BY p.product_id, p.price
ORDER BY feature_units_sold DESC;

-- Note: thresholds are illustrative for coursework and should be tuned to the dataset.
