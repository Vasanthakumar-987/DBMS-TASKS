
-- TASK VIII: DATABASE RELATIONSHIP ANALYSIS USING JOINS
-- AMAZON E-COMMERCE DATABASE

CREATE DATABASE IF NOT EXISTS amazon_db;
USE amazon_db;

-- 1. CREATE USER TABLE
CREATE TABLE IF NOT EXISTS `USER` (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- 2. CREATE PRODUCT TABLE
CREATE TABLE IF NOT EXISTS PRODUCT (
    product_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- 3. CREATE ORDERS TABLE
CREATE TABLE IF NOT EXISTS ORDERS (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (user_id) REFERENCES `USER`(user_id)
);

-- 4. CREATE ORDER_ITEM TABLE
CREATE TABLE IF NOT EXISTS ORDER_ITEM (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
);

-- 5. CREATE PAYMENT TABLE
CREATE TABLE IF NOT EXISTS PAYMENT (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    status VARCHAR(30),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
);


-- INSERT SAMPLE DATA

-- 6. INSERT USERS
INSERT INTO `USER` (user_id, name, email) VALUES
(1, 'Arun', 'arun@gmail.com'),
(2, 'Priya', 'priya@gmail.com'),
(3, 'Vasanth', 'vasanth@gmail.com'),
(4, 'Kumar', 'kumar@gmail.com'),
(5, 'Ravi', 'ravi@gmail.com');

-- 7. INSERT PRODUCTS
INSERT INTO PRODUCT (product_id, title, price) VALUES
(101, 'Laptop', 50000),
(102, 'Mobile', 20000),
(103, 'Headphones', 2000),
(104, 'Keyboard', 1500),
(105, 'Mouse', 500);

-- 8. INSERT ORDERS
INSERT INTO ORDERS
(order_id, user_id, order_date, total_amount) VALUES
(1001, 1, '2026-09-01', 50000),
(1002, 2, '2026-09-02', 20000),
(1003, 3, '2026-09-03', 3500),
(1004, 1, '2026-09-04', 2500),
(1005, 4, '2026-09-05', 2000);

-- 9. INSERT ORDER ITEMS
INSERT INTO ORDER_ITEM
(order_item_id, order_id, product_id, quantity, price) VALUES
(1, 1001, 101, 1, 50000),
(2, 1002, 102, 1, 20000),
(3, 1003, 103, 1, 2000),
(4, 1003, 104, 1, 1500),
(5, 1004, 103, 1, 2000),
(6, 1004, 105, 1, 500),
(7, 1005, 103, 1, 2000);

-- 10. INSERT PAYMENTS
INSERT INTO PAYMENT
(payment_id, order_id, payment_method, status) VALUES
(1, 1001, 'UPI', 'Success'),
(2, 1002, 'Card', 'Success'),
(3, 1003, 'Cash on Delivery', 'Pending'),
(4, 1004, 'UPI', 'Success');


-- TASK VIII: SQL JOINS


-- 11. INNER JOIN
-- Combine Customer, Product, Order and Payment

SELECT
    u.name AS customer_name,
    o.order_id,
    p.title AS product_name,
    i.quantity,
    i.price,
    pay.payment_method,
    pay.status
FROM `USER` u
INNER JOIN ORDERS o
    ON u.user_id = o.user_id
INNER JOIN ORDER_ITEM i
    ON o.order_id = i.order_id
INNER JOIN PRODUCT p
    ON i.product_id = p.product_id
INNER JOIN PAYMENT pay
    ON o.order_id = pay.order_id
ORDER BY o.order_id;


-- 12. LEFT JOIN
-- Display all customers including customers without orders

SELECT
    u.user_id,
    u.name,
    o.order_id,
    o.total_amount
FROM `USER` u
LEFT JOIN ORDERS o
    ON u.user_id = o.user_id
ORDER BY u.user_id;


-- 13. RIGHT JOIN
-- Display all orders including orders without payments

SELECT
    o.order_id,
    o.total_amount,
    pay.payment_method,
    pay.status
FROM PAYMENT pay
RIGHT JOIN ORDERS o
    ON pay.order_id = o.order_id
ORDER BY o.order_id;


-- 14. COMPLETE ORDER DETAILS

SELECT
    o.order_id,
    o.order_date,
    u.name AS customer_name,
    p.title AS product_name,
    i.quantity,
    i.price,
    o.total_amount,
    pay.payment_method,
    pay.status AS payment_status
FROM ORDERS o
INNER JOIN `USER` u
    ON o.user_id = u.user_id
LEFT JOIN ORDER_ITEM i
    ON o.order_id = i.order_id
LEFT JOIN PRODUCT p
    ON i.product_id = p.product_id
LEFT JOIN PAYMENT pay
    ON o.order_id = pay.order_id
ORDER BY o.order_id;


-- 15. CUSTOMER PURCHASE HISTORY

SELECT
    u.user_id,
    u.name AS customer_name,
    o.order_id,
    o.order_date,
    p.title AS product_name,
    i.quantity,
    i.price,
    (i.quantity * i.price) AS purchase_amount
FROM `USER` u
INNER JOIN ORDERS o
    ON u.user_id = o.user_id
INNER JOIN ORDER_ITEM i
    ON o.order_id = i.order_id
INNER JOIN PRODUCT p
    ON i.product_id = p.product_id
ORDER BY u.user_id, o.order_date;


-- 16. MULTI-TABLE SALES REPORT

SELECT
    p.product_id,
    p.title AS product_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(i.quantity) AS total_quantity,
    SUM(i.quantity * i.price) AS total_sales
FROM PRODUCT p
INNER JOIN ORDER_ITEM i
    ON p.product_id = i.product_id
INNER JOIN ORDERS o
    ON i.order_id = o.order_id
GROUP BY p.product_id, p.title
ORDER BY total_sales DESC;


-- 17. CUSTOMER-WISE PURCHASE REPORT

SELECT
    u.user_id,
    u.name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_purchase
FROM `USER` u
LEFT JOIN ORDERS o
    ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_purchase DESC;
