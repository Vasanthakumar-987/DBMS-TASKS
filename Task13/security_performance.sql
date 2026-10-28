-- TASK XIII: DATABASE SECURITY AND PERFORMANCE OPTIMIZATION
USE amazon_db;

-- SECURITY: run with a privileged MySQL account.
-- Change the example password before using this account outside a lab.
CREATE ROLE IF NOT EXISTS 'amazon_report_reader';
CREATE USER IF NOT EXISTS 'amazon_report_user'@'localhost'
    IDENTIFIED BY 'ChangeThis_StrongPassword_123!';

GRANT SELECT ON amazon_db.* TO 'amazon_report_reader';
GRANT 'amazon_report_reader' TO 'amazon_report_user'@'localhost';
SET DEFAULT ROLE 'amazon_report_reader' TO 'amazon_report_user'@'localhost';

-- Demonstrate REVOKE (commented to preserve the reporting role's SELECT access).
-- REVOKE SELECT ON amazon_db.PAYMENT FROM 'amazon_report_reader';

-- PERFORMANCE: create indexes for frequently joined/searched columns.
-- If an equivalent index already exists, skip that CREATE INDEX statement.
CREATE INDEX idx_orders_user_date ON ORDERS (user_id, order_date);
CREATE INDEX idx_order_item_order ON ORDER_ITEM (order_id);
CREATE INDEX idx_order_item_product ON ORDER_ITEM (product_id);
CREATE INDEX idx_payment_order_status ON PAYMENT (order_id, status);
CREATE INDEX idx_product_title ON PRODUCT (title);

-- EXPLAIN: inspect query plan before and after indexing.
EXPLAIN
SELECT o.order_id, o.order_date, o.total_amount
FROM ORDERS AS o
WHERE o.user_id = 1
ORDER BY o.order_date DESC;

EXPLAIN
SELECT p.product_id, p.title, SUM(i.quantity) AS units_sold
FROM PRODUCT AS p
JOIN ORDER_ITEM AS i ON i.product_id = p.product_id
GROUP BY p.product_id, p.title;

-- To remove an index during lab cleanup, use:
-- DROP INDEX idx_product_title ON PRODUCT;
