USE amazon_order_management;

-- 1. Nested query:
-- Customers who ordered products priced above average.
SELECT u.user_id, u.name
FROM `USER` u
WHERE u.user_id IN (
    SELECT o.user_id
    FROM ORDERS o
    WHERE o.order_id IN (
        SELECT i.order_id
        FROM ORDER_ITEM i
        WHERE i.product_id IN (
            SELECT p.product_id
            FROM PRODUCT p
            WHERE p.price > (
                SELECT AVG(price)
                FROM PRODUCT
            )
        )
    )
);

-- 2. Products with a price above the average product price.
SELECT product_id, title, price
FROM PRODUCT
WHERE price > (
    SELECT AVG(price)
    FROM PRODUCT
)
ORDER BY price DESC;

-- 3. Customers with maximum purchases:
-- Here, purchases means the number of orders.
-- Includes all customers tied for the highest count.
SELECT u.user_id, u.name, COUNT(o.order_id) AS total_orders
FROM `USER` u
JOIN ORDERS o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
HAVING COUNT(o.order_id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT user_id, COUNT(*) AS order_count
        FROM ORDERS
        GROUP BY user_id
    ) AS customer_counts
);

-- 4. Complex business query:
-- Products that have never been ordered.
SELECT p.product_id, p.title, p.price
FROM PRODUCT p
WHERE NOT EXISTS (
    SELECT 1
    FROM ORDER_ITEM i
    WHERE i.product_id = p.product_id
);

-- 5. Advanced customer report:
-- Order count, total order value, average order value,
-- and comparison with average spending among buyers.
SELECT
    u.user_id,
    u.name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_order_value,
    COALESCE(ROUND(AVG(o.total_amount), 2), 0) AS average_order_value,
    CASE
        WHEN COUNT(o.order_id) = 0 THEN 'No Orders'
        WHEN SUM(o.total_amount) > (
            SELECT AVG(customer_total)
            FROM (
                SELECT user_id, SUM(total_amount) AS customer_total
                FROM ORDERS
                GROUP BY user_id
            ) AS customer_totals
        ) THEN 'Above Average'
        ELSE 'Average or Below'
    END AS purchase_category
FROM `USER` u
LEFT JOIN ORDERS o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name
ORDER BY total_order_value DESC;
