
USE amazon_db;

-- 1. INNER JOIN: Customer, Product, Order, Payment
SELECT u.name, o.order_id, p.title,
       i.quantity, i.price,
       pay.payment_method, pay.status
FROM `USER` u
INNER JOIN ORDERS o ON u.user_id = o.user_id
INNER JOIN ORDER_ITEM i ON o.order_id = i.order_id
INNER JOIN PRODUCT p ON i.product_id = p.product_id
INNER JOIN PAYMENT pay ON o.order_id = pay.order_id;

-- 2. LEFT JOIN: Display all customers
SELECT u.user_id, u.name,
       o.order_id, o.total_amount
FROM `USER` u
LEFT JOIN ORDERS o ON u.user_id = o.user_id;

-- 3. RIGHT JOIN: Display all orders
SELECT o.order_id, o.total_amount,
       pay.payment_method, pay.status
FROM PAYMENT pay
RIGHT JOIN ORDERS o ON pay.order_id = o.order_id;

-- 4. COMPLETE ORDER DETAILS
SELECT o.order_id, o.order_date,
       u.name AS customer_name,
       p.title AS product_name,
       i.quantity, i.price,
       pay.payment_method, pay.status
FROM ORDERS o
JOIN `USER` u ON o.user_id = u.user_id
LEFT JOIN ORDER_ITEM i ON o.order_id = i.order_id
LEFT JOIN PRODUCT p ON i.product_id = p.product_id
LEFT JOIN PAYMENT pay ON o.order_id = pay.order_id;

-- 5. CUSTOMER PURCHASE HISTORY
SELECT u.name, o.order_id,
       o.order_date, p.title,
       i.quantity, i.price
FROM `USER` u
JOIN ORDERS o ON u.user_id = o.user_id
JOIN ORDER_ITEM i ON o.order_id = i.order_id
JOIN PRODUCT p ON i.product_id = p.product_id
ORDER BY u.name, o.order_date;

-- 6. MULTI-TABLE SALES REPORT
SELECT p.title AS product_name,
       SUM(i.quantity) AS total_quantity,
       SUM(i.quantity * i.price) AS total_sales
FROM PRODUCT p
JOIN ORDER_ITEM i ON p.product_id = i.product_id
JOIN ORDERS o ON i.order_id = o.order_id
GROUP BY p.product_id, p.title
ORDER BY total_sales DESC;
