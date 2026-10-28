-- TASK XI: DATABASE AUTOMATION USING VIEWS AND PROCEDURES
USE amazon_db;

-- View 1: frequently used order/customer/payment report
CREATE OR REPLACE VIEW vw_order_summary AS
SELECT
    o.order_id,
    o.order_date,
    u.user_id,
    u.name AS customer_name,
    o.total_amount,
    pay.payment_method,
    pay.status AS payment_status
FROM ORDERS AS o
JOIN `USER` AS u ON u.user_id = o.user_id
LEFT JOIN PAYMENT AS pay ON pay.order_id = o.order_id;

-- View 2: product sales report
CREATE OR REPLACE VIEW vw_product_sales AS
SELECT
    p.product_id,
    p.title AS product_name,
    COALESCE(SUM(i.quantity), 0) AS units_sold,
    COALESCE(SUM(i.quantity * i.price), 0.00) AS sales_value
FROM PRODUCT AS p
LEFT JOIN ORDER_ITEM AS i ON i.product_id = p.product_id
GROUP BY p.product_id, p.title;

DELIMITER //

-- Function: calculate the value of one order-item line
CREATE FUNCTION fn_order_item_total(p_quantity INT, p_unit_price DECIMAL(10,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
NO SQL
BEGIN
    RETURN COALESCE(p_quantity, 0) * COALESCE(p_unit_price, 0.00);
END //

-- Procedure: recalculate an existing order's total from its line items
CREATE PROCEDURE sp_refresh_order_total(IN p_order_id INT)
BEGIN
    UPDATE ORDERS
    SET total_amount = (
        SELECT COALESCE(SUM(quantity * price), 0.00)
        FROM ORDER_ITEM
        WHERE order_id = p_order_id
    )
    WHERE order_id = p_order_id;
END //

DELIMITER ;

-- TESTS: run after the objects above are created
SELECT * FROM vw_order_summary ORDER BY order_date DESC;
SELECT * FROM vw_product_sales ORDER BY sales_value DESC;
SELECT fn_order_item_total(2, 125.50) AS sample_line_total;

-- Optional: run for an order that already exists, then verify its total.
-- CALL sp_refresh_order_total(1001);
-- SELECT order_id, total_amount FROM ORDERS WHERE order_id = 1001;
