# Task9 — Executed Query Outputs

Engine: SQLite 3.53.1. MySQL CREATE DATABASE and USE were skipped; all queries, including RIGHT JOIN, ran as written. NULL means no matching record. Amounts are in INR. These are actual execution results, not MySQL Workbench captures.

## Q1: COUNT, SUM, AVG, MIN and MAX - successfully paid orders

```sql
-- COUNT counts orders rather than order-item rows.
SELECT COUNT(*) AS paid_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_sales,
       ROUND(AVG(o.total_amount), 2) AS average_order_value,
       MIN(o.total_amount) AS minimum_order_value,
       MAX(o.total_amount) AS maximum_order_value
FROM Orders o
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS';
```

| paid_orders | total_sales | average_order_value | minimum_order_value | maximum_order_value |
| --- | --- | --- | --- | --- |
| 4 | 8492 | 2123.0 | 1299 | 3298 |

1 rows returned.


## Q2: Daily total sales report

```sql
SELECT o.order_date, COUNT(*) AS paid_orders,
       SUM(o.total_amount) AS daily_sales
FROM Orders o
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY o.order_date
ORDER BY o.order_date;
```

| order_date | paid_orders | daily_sales |
| --- | --- | --- |
| 2026-09-01 | 1 | 1597 |
| 2026-09-02 | 1 | 3298 |
| 2026-09-03 | 1 | 2298 |
| 2026-09-04 | 1 | 1299 |

4 rows returned.


## Q3: Top three customers based on paid purchase amount

```sql
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS paid_orders,
       SUM(o.total_amount) AS purchase_amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY c.customer_id, c.customer_name
ORDER BY purchase_amount DESC, c.customer_id
LIMIT 3;
```

| customer_id | customer_name | paid_orders | purchase_amount |
| --- | --- | --- | --- |
| 2 | Priya | 1 | 3298 |
| 1 | Arun Kumar | 2 | 2896 |
| 3 | Vasanth | 1 | 2298 |

3 rows returned.


## Q4: Best-selling products ranked by quantity, then sales value

```sql
-- Only paid purchases count. Ties in both measures use product_id.
SELECT p.product_id, p.product_name,
       SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.unit_price) AS sales_amount
FROM Products p
INNER JOIN Order_Details od ON p.product_id = od.product_id
INNER JOIN Orders o ON od.order_id = o.order_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, sales_amount DESC, p.product_id;
```

| product_id | product_name | units_sold | sales_amount |
| --- | --- | --- | --- |
| 107 | DBMS Fundamentals | 2 | 1300 |
| 101 | Wireless Mouse | 2 | 1198 |
| 104 | T-Shirt | 2 | 998 |
| 102 | Mechanical Keyboard | 1 | 2499 |
| 105 | Jeans | 1 | 1299 |
| 106 | Java Programming Book | 1 | 799 |
| 103 | USB-C Cable | 1 | 399 |

7 rows returned.


## Q5: Category-wise paid sales, including categories with zero sales

```sql
-- Aggregate paid items first, then LEFT JOIN to keep zero-sales categories.
SELECT cat.category_name,
       COALESCE(SUM(s.units_sold), 0) AS units_sold,
       COALESCE(SUM(s.sales_amount), 0) AS sales_amount
FROM Category cat
LEFT JOIN Products p ON cat.category_id = p.category_id
LEFT JOIN (
    SELECT od.product_id, SUM(od.quantity) AS units_sold,
           SUM(od.quantity * od.unit_price) AS sales_amount
    FROM Order_Details od
    INNER JOIN Orders o ON od.order_id = o.order_id
    INNER JOIN Payment pay ON o.order_id = pay.order_id
    WHERE pay.payment_status = 'SUCCESS'
    GROUP BY od.product_id
) s ON p.product_id = s.product_id
GROUP BY cat.category_id, cat.category_name
ORDER BY sales_amount DESC, cat.category_id;
```

| category_name | units_sold | sales_amount |
| --- | --- | --- |
| Electronics | 4 | 4096 |
| Clothing | 3 | 2297 |
| Books | 3 | 2099 |
| Home Appliances | 0 | 0 |

4 rows returned.


## Q6: Sales by payment method

```sql
SELECT pay.payment_mode, COUNT(o.order_id) AS paid_orders,
       SUM(o.total_amount) AS sales_amount
FROM Orders o
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY pay.payment_mode
ORDER BY sales_amount DESC, pay.payment_mode;
```

| payment_mode | paid_orders | sales_amount |
| --- | --- | --- |
| Credit Card | 1 | 3298 |
| UPI | 2 | 2896 |
| Debit Card | 1 | 2298 |

3 rows returned.
