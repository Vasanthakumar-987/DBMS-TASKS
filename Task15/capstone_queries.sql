-- TASK XV: E-COMMERCE INTELLIGENCE PLATFORM CAPSTONE
-- Uses the existing amazon_db schema and records.
USE amazon_db;

-- 1. Integrated order and payment report
SELECT
    o.order_id,
    o.order_date,
    u.user_id,
    u.name AS customer_name,
    o.total_amount,
    p.payment_method,
    p.status AS payment_status
FROM ORDERS AS o
JOIN `USER` AS u ON u.user_id = o.user_id
LEFT JOIN PAYMENT AS p ON p.order_id = o.order_id
ORDER BY o.order_date DESC, o.order_id;

-- 2. Customer purchase summary
SELECT
    u.user_id,
    u.name AS customer_name,
    COUNT(DISTINCT o.order_id) AS order_count,
    COALESCE(SUM(o.total_amount), 0.00) AS total_order_value
FROM `USER` AS u
LEFT JOIN ORDERS AS o ON o.user_id = u.user_id
GROUP BY u.user_id, u.name
ORDER BY total_order_value DESC;

-- 3. Product performance report
SELECT
    p.product_id,
    p.title AS product_name,
    COALESCE(SUM(i.quantity), 0) AS units_sold,
    COALESCE(SUM(i.quantity * i.price), 0.00) AS sales_value
FROM PRODUCT AS p
LEFT JOIN ORDER_ITEM AS i ON i.product_id = p.product_id
GROUP BY p.product_id, p.title
ORDER BY sales_value DESC;

-- 4. Payment status distribution
SELECT status AS payment_status, COUNT(*) AS payment_count
FROM PAYMENT
GROUP BY status
ORDER BY payment_count DESC;

-- 5. Test views created in Task XI (run Task XI first).
-- SELECT * FROM vw_order_summary;
-- SELECT * FROM vw_product_sales;

-- 6. Test function created in Task XI (run Task XI first).
-- SELECT fn_order_item_total(2, 125.50) AS example_line_total;

-- 7. Example EXPLAIN for query performance review
EXPLAIN
SELECT order_id, order_date, total_amount
FROM ORDERS
WHERE user_id = 1
ORDER BY order_date DESC;

-- Business insight prompts:
-- Which customers have the highest total order value?
-- Which products generate the most recorded sales value?
-- What share of payment records is Pending vs Completed/Success?
-- Compare product demand with current prices before making stock decisions.
