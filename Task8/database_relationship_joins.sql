USE amazon_db;

-- 1. INNER JOIN: customer, product, order and payment.
SELECT u.name, o.order_id, p.title, i.quantity, i.price,
       pay.payment_method, pay.status
FROM `USER` u
INNER JOIN ORDERS o ON u.user_id = o.user_id
INNER JOIN ORDER_ITEM i ON o.order_id = i.order_id
INNER JOIN PRODUCT p ON i.product_id = p.product_id
INNER JOIN PAYMENT pay ON o.order_id = pay.order_id
ORDER BY o.order_id, i.order_item_id;

-- 2. LEFT JOIN: include customers without orders.
SELECT u.name, o.order_id, o.total_amount
FROM `USER` u LEFT JOIN ORDERS o ON u.user_id = o.user_id
ORDER BY u.user_id, o.order_id;

-- 3. RIGHT JOIN: include orders without payments.
SELECT o.order_id, o.total_amount, pay.payment_method, pay.status
FROM PAYMENT pay RIGHT JOIN ORDERS o ON pay.order_id = o.order_id
ORDER BY o.order_id;

-- 4. Complete order details, including missing payment/item records.
SELECT o.order_id, o.order_date, u.name, p.title,
       i.quantity, i.price, i.quantity * i.price AS item_total,
       o.total_amount, pay.payment_method, pay.status
FROM ORDERS o
LEFT JOIN `USER` u ON o.user_id = u.user_id
LEFT JOIN ORDER_ITEM i ON o.order_id = i.order_id
LEFT JOIN PRODUCT p ON i.product_id = p.product_id
LEFT JOIN PAYMENT pay ON o.order_id = pay.order_id
ORDER BY o.order_id, i.order_item_id;

-- 5. Customer purchase history (change user_id as needed).
SELECT u.name, o.order_date, o.order_id, p.title,
       i.quantity, i.quantity * i.price AS item_total
FROM `USER` u
JOIN ORDERS o ON u.user_id = o.user_id
JOIN ORDER_ITEM i ON o.order_id = i.order_id
JOIN PRODUCT p ON i.product_id = p.product_id
WHERE u.user_id = 1
ORDER BY o.order_date, o.order_id, i.order_item_id;

-- 6. Multi-table customer report, counting each order once.
SELECT u.name, COUNT(o.order_id) AS orders,
       COALESCE(SUM(o.total_amount), 0) AS order_value,
       COALESCE(SUM(CASE WHEN pay.status = 'Completed'
                        THEN o.total_amount ELSE 0 END), 0) AS paid_value
FROM `USER` u
LEFT JOIN ORDERS o ON u.user_id = o.user_id
LEFT JOIN PAYMENT pay ON o.order_id = pay.order_id
GROUP BY u.user_id, u.name
ORDER BY paid_value DESC, u.user_id;
