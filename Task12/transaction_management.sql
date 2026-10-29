
USE amazon_db;

-- TASK XII: TRANSACTION MANAGEMENT SYSTEM

-- STEP 1: Check the existing table structure
DESCRIBE PRODUCT;
DESCRIBE ORDERS;
DESCRIBE ORDER_ITEM;
DESCRIBE PAYMENT;

-- STEP 2: Create a procedure for safe order placement
DROP PROCEDURE IF EXISTS sp_place_order;

DELIMITER $$

CREATE PROCEDURE sp_place_order(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_stock INT DEFAULT 0;
    DECLARE v_price DECIMAL(10,2) DEFAULT 0;
    DECLARE v_user_count INT DEFAULT 0;
    DECLARE v_product_count INT DEFAULT 0;
    DECLARE v_order_id INT DEFAULT 0;
    DECLARE v_item_id INT DEFAULT 0;
    DECLARE v_payment_id INT DEFAULT 0;

    -- Roll back automatically if any SQL error occurs
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validate the customer
    SELECT COUNT(*) INTO v_user_count
    FROM `USER`
    WHERE user_id = p_user_id;

    IF v_user_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer ID does not exist';
    END IF;

    -- Validate the product
    SELECT COUNT(*) INTO v_product_count
    FROM PRODUCT
    WHERE product_id = p_product_id;

    IF v_product_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product ID does not exist';
    END IF;

    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    -- Lock the product and check available stock
    SELECT stock, price
    INTO v_stock, v_price
    FROM PRODUCT
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock; order cancelled';
    END IF;

    -- Generate IDs for this academic example
    SELECT COALESCE(MAX(order_id), 0) + 1
    INTO v_order_id
    FROM ORDERS;

    SELECT COALESCE(MAX(order_item_id), 0) + 1
    INTO v_item_id
    FROM ORDER_ITEM;

    SELECT COALESCE(MAX(payment_id), 0) + 1
    INTO v_payment_id
    FROM PAYMENT;

    -- Create the order
    INSERT INTO ORDERS
        (order_id, user_id, order_date, total_amount)
    VALUES
        (v_order_id, p_user_id, CURDATE(),
         p_quantity * v_price);

    -- Add the ordered product
    INSERT INTO ORDER_ITEM
        (order_item_id, order_id, product_id, quantity, price)
    VALUES
        (v_item_id, v_order_id, p_product_id,
         p_quantity, v_price);

    -- Reduce stock
    UPDATE PRODUCT
    SET stock = stock - p_quantity
    WHERE product_id = p_product_id;

    -- Record payment as pending; no actual payment is processed
    INSERT INTO PAYMENT
        (payment_id, order_id, payment_method, status)
    VALUES
        (v_payment_id, v_order_id, 'UPI', 'Pending');

    -- Save all related changes together
    COMMIT;

    SELECT 'Order placed successfully' AS message,
           v_order_id AS order_id,
           p_product_id AS product_id,
           p_quantity AS quantity,
           p_quantity * v_price AS total_amount;
END $$

DELIMITER ;

-- STEP 3: Verify the procedure was created
SHOW PROCEDURE STATUS
WHERE Db = 'amazon_db'
  AND Name = 'sp_place_order';

-- STEP 4: Check available customer IDs
SELECT user_id, name FROM `USER`;

-- STEP 5: Check products and stock before ordering
SELECT product_id, title, price, stock
FROM PRODUCT;

-- STEP 6: Transaction rollback demonstration
-- This deliberately changes no real product row.
START TRANSACTION;

UPDATE PRODUCT
SET stock = stock + 1
WHERE product_id = -999999;

ROLLBACK;

-- STEP 7: Verify order and payment reports
SELECT * FROM ORDERS ORDER BY order_id;
SELECT * FROM ORDER_ITEM ORDER BY order_item_id;
SELECT * FROM PAYMENT ORDER BY payment_id;
