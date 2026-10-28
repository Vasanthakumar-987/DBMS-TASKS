-- TASK XII: TRANSACTION MANAGEMENT SYSTEM
USE amazon_db;

-- A. ROLLBACK demonstration: this change should not persist.
START TRANSACTION;
UPDATE PRODUCT
SET stock = stock + 1
WHERE product_id = -999999; -- deliberately matches no real product
ROLLBACK;

-- B. Order placement transaction template.
-- IMPORTANT: Replace IDs and quantities with valid existing records.
-- Run this block only after confirming the product has enough stock.
-- The example assumes PRODUCT.stock exists in your amazon_db schema.
-- Replace @product_id, @quantity, @order_id and @payment_id with suitable values.

SET @product_id = 101;
SET @quantity = 1;
SET @order_id = 1001;
SET @payment_id = 900001;

START TRANSACTION;

-- Lock the selected product row and verify stock.
SELECT stock INTO @available_stock
FROM PRODUCT
WHERE product_id = @product_id
FOR UPDATE;

-- The conditional update prevents stock from going below zero.
UPDATE PRODUCT
SET stock = stock - @quantity
WHERE product_id = @product_id
  AND @quantity > 0
  AND stock >= @quantity;

-- Check ROW_COUNT() immediately after the UPDATE.
SET @stock_update_ok = ROW_COUNT();

-- If @stock_update_ok = 1, continue and COMMIT after validating the order.
-- If it is 0, issue ROLLBACK and do not process payment.
SELECT @available_stock AS stock_before,
       @stock_update_ok AS stock_update_succeeded;

-- SAFETY: rollback by default so this template does not alter your data.
-- After testing and verifying the values, replace ROLLBACK with COMMIT.
ROLLBACK;

-- C. Payment status update example (execute separately after choosing a real payment).
-- START TRANSACTION;
-- UPDATE PAYMENT SET status = 'Completed'
-- WHERE payment_id = 1 AND status = 'Pending';
-- SELECT ROW_COUNT() AS payment_rows_updated;
-- COMMIT;

-- D. Consistency checks
SELECT product_id, title, stock
FROM PRODUCT
ORDER BY product_id;

SELECT order_id, total_amount
FROM ORDERS
ORDER BY order_id;

SELECT payment_id, order_id, payment_method, status
FROM PAYMENT
ORDER BY payment_id;

-- ACID summary:
-- Atomicity: related changes are committed together or rolled back.
-- Consistency: constraints and conditional stock checks preserve valid data.
-- Isolation: SELECT ... FOR UPDATE locks the chosen product row in this transaction.
-- Durability: COMMIT persists changes after successful completion.
