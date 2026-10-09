USE amazon_db;

-- 1. Aggregate functions and total sales (completed payments only).
SELECT COUNT(*) AS paid_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_sales,
       AVG(o.total_amount) AS average_order,
       MIN(o.total_amount) AS minimum_order,
       MAX(o.total_amount) AS maximum_order
FROM ORDERS o JOIN PAYMENT pay ON o.order_id = pay.order_id
WHERE pay.status = 'Completed';

-- 2. Daily sales report.
SELECT DATE(o.order_date) AS sale_date, SUM(o.total_amount) AS sales
FROM ORDERS o JOIN PAYMENT pay ON o.order_id = pay.order_id
WHERE pay.status = 'Completed'
GROUP BY DATE(o.order_date)
ORDER BY sale_date;

-- 3. Top customers by paid purchase amount.
SELECT u.name, SUM(o.total_amount) AS total_spent
FROM `USER` u
JOIN ORDERS o ON u.user_id = o.user_id
JOIN PAYMENT pay ON o.order_id = pay.order_id
WHERE pay.status = 'Completed'
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC, u.user_id;

-- 4. Best-selling products, ranked by units sold.
SELECT p.title, SUM(i.quantity) AS units_sold,
       SUM(i.quantity * i.price) AS sales
FROM PRODUCT p
JOIN ORDER_ITEM i ON p.product_id = i.product_id
JOIN PAYMENT pay ON i.order_id = pay.order_id
WHERE pay.status = 'Completed'
GROUP BY p.product_id, p.title
ORDER BY units_sold DESC, sales DESC, p.product_id;

-- 5. Category-wise sales requires a product-to-category relationship.
-- The existing amazon_db schema has no category table or column.
-- This report is pending the actual category mapping; see README.md.
