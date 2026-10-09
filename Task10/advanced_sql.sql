USE amazon_db;

-- 1. Subquery: products above average price.
SELECT title, price FROM PRODUCT
WHERE price > (SELECT AVG(price) FROM PRODUCT);

-- 2. Maximum purchases by total order value (includes ties).
SELECT u.name, SUM(o.total_amount) AS total_spent
FROM `USER` u JOIN ORDERS o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total) FROM (
        SELECT SUM(total_amount) AS total FROM ORDERS
        WHERE user_id IS NOT NULL GROUP BY user_id
    ) AS purchases
);

-- 3. Nested queries: customers ordering above-average-priced products.
SELECT name FROM `USER`
WHERE user_id IN (
    SELECT user_id FROM ORDERS WHERE order_id IN (
        SELECT order_id FROM ORDER_ITEM WHERE product_id IN (
            SELECT product_id FROM PRODUCT
            WHERE price > (SELECT AVG(price) FROM PRODUCT)
        )
    )
);

-- 4. Business query: products never ordered.
SELECT title FROM PRODUCT p
WHERE NOT EXISTS (
    SELECT 1 FROM ORDER_ITEM i WHERE i.product_id = p.product_id
);

-- 5. Advanced customer report, including customers without orders.
SELECT u.name, COUNT(o.order_id) AS orders,
       COALESCE(SUM(o.total_amount), 0) AS total_spent,
       CASE WHEN MAX(o.total_amount) > (SELECT AVG(total_amount) FROM ORDERS)
            THEN 'Yes' ELSE 'No' END AS has_above_average_order
FROM `USER` u LEFT JOIN ORDERS o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC, u.user_id;
