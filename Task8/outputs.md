# Task8 — Executed Query Outputs

Engine: SQLite 3.53.1. MySQL CREATE DATABASE and USE were skipped; all queries, including RIGHT JOIN, ran as written. NULL means no matching record. Amounts are in INR. These are actual execution results, not MySQL Workbench captures.

## Q1: INNER JOIN - customer, order, product and payment details

```sql
-- One result row per order item. Orders without payment records are excluded.
SELECT c.customer_name, o.order_id, p.product_name,
       od.quantity, od.unit_price,
       od.quantity * od.unit_price AS item_total,
       pay.payment_mode, pay.payment_status
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
ORDER BY o.order_id, od.order_detail_id;
```

| customer_name | order_id | product_name | quantity | unit_price | item_total | payment_mode | payment_status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Arun Kumar | 1001 | Wireless Mouse | 2 | 599 | 1198 | UPI | SUCCESS |
| Arun Kumar | 1001 | USB-C Cable | 1 | 399 | 399 | UPI | SUCCESS |
| Priya | 1002 | Mechanical Keyboard | 1 | 2499 | 2499 | Credit Card | SUCCESS |
| Priya | 1002 | Java Programming Book | 1 | 799 | 799 | Credit Card | SUCCESS |
| Vasanth | 1003 | T-Shirt | 2 | 499 | 998 | Debit Card | SUCCESS |
| Vasanth | 1003 | DBMS Fundamentals | 2 | 650 | 1300 | Debit Card | SUCCESS |
| Arun Kumar | 1004 | Jeans | 1 | 1299 | 1299 | UPI | SUCCESS |
| Vasanth | 1006 | USB-C Cable | 1 | 399 | 399 | UPI | FAILED |

8 rows returned.


## Q2: LEFT JOIN - all customers, including customers with no orders

```sql
SELECT c.customer_id, c.customer_name, o.order_id, o.total_amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_id;
```

| customer_id | customer_name | order_id | total_amount |
| --- | --- | --- | --- |
| 1 | Arun Kumar | 1001 | 1597 |
| 1 | Arun Kumar | 1004 | 1299 |
| 2 | Priya | 1002 | 3298 |
| 2 | Priya | 1005 | 999 |
| 3 | Vasanth | 1003 | 2298 |
| 3 | Vasanth | 1006 | 399 |
| 4 | Divya | NULL | NULL |

7 rows returned.


## Q3: RIGHT JOIN - all orders, including orders with no payment record

```sql
SELECT o.order_id, o.total_amount, pay.payment_id,
       pay.payment_mode, pay.payment_status
FROM Payment pay
RIGHT JOIN Orders o ON pay.order_id = o.order_id
ORDER BY o.order_id;
```

| order_id | total_amount | payment_id | payment_mode | payment_status |
| --- | --- | --- | --- | --- |
| 1001 | 1597 | 1 | UPI | SUCCESS |
| 1002 | 3298 | 2 | Credit Card | SUCCESS |
| 1003 | 2298 | 3 | Debit Card | SUCCESS |
| 1004 | 1299 | 4 | UPI | SUCCESS |
| 1005 | 999 | NULL | NULL | NULL |
| 1006 | 399 | 5 | UPI | FAILED |

6 rows returned.


## Q4: Complete order details, retaining unpaid orders

```sql
SELECT o.order_id, o.order_date, c.customer_name,
       p.product_name, cat.category_name, od.quantity,
       od.unit_price, od.quantity * od.unit_price AS item_total,
       o.total_amount AS order_total, pay.amount AS payment_amount,
       COALESCE(pay.payment_status, 'NO PAYMENT') AS payment_status
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id
INNER JOIN Category cat ON p.category_id = cat.category_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
ORDER BY o.order_id, od.order_detail_id;
```

| order_id | order_date | customer_name | product_name | category_name | quantity | unit_price | item_total | order_total | payment_amount | payment_status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1001 | 2026-09-01 | Arun Kumar | Wireless Mouse | Electronics | 2 | 599 | 1198 | 1597 | 1597 | SUCCESS |
| 1001 | 2026-09-01 | Arun Kumar | USB-C Cable | Electronics | 1 | 399 | 399 | 1597 | 1597 | SUCCESS |
| 1002 | 2026-09-02 | Priya | Mechanical Keyboard | Electronics | 1 | 2499 | 2499 | 3298 | 3298 | SUCCESS |
| 1002 | 2026-09-02 | Priya | Java Programming Book | Books | 1 | 799 | 799 | 3298 | 3298 | SUCCESS |
| 1003 | 2026-09-03 | Vasanth | T-Shirt | Clothing | 2 | 499 | 998 | 2298 | 2298 | SUCCESS |
| 1003 | 2026-09-03 | Vasanth | DBMS Fundamentals | Books | 2 | 650 | 1300 | 2298 | 2298 | SUCCESS |
| 1004 | 2026-09-04 | Arun Kumar | Jeans | Clothing | 1 | 1299 | 1299 | 1299 | 1299 | SUCCESS |
| 1005 | 2026-09-05 | Priya | Electric Kettle | Home Appliances | 1 | 999 | 999 | 999 | NULL | NO PAYMENT |
| 1006 | 2026-09-05 | Vasanth | USB-C Cable | Electronics | 1 | 399 | 399 | 399 | 399 | FAILED |

9 rows returned.


## Q5: Customer purchase history - Arun Kumar (customer_id = 1)

```sql
-- Change the customer ID to view another customer's history.
SELECT c.customer_name, o.order_id, o.order_date,
       p.product_name, od.quantity,
       od.quantity * od.unit_price AS item_total,
       COALESCE(pay.payment_status, 'NO PAYMENT') AS payment_status
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
WHERE c.customer_id = 1
ORDER BY o.order_date, o.order_id, od.order_detail_id;
```

| customer_name | order_id | order_date | product_name | quantity | item_total | payment_status |
| --- | --- | --- | --- | --- | --- | --- |
| Arun Kumar | 1001 | 2026-09-01 | Wireless Mouse | 2 | 1198 | SUCCESS |
| Arun Kumar | 1001 | 2026-09-01 | USB-C Cable | 1 | 399 | SUCCESS |
| Arun Kumar | 1004 | 2026-09-04 | Jeans | 1 | 1299 | SUCCESS |

3 rows returned.


## Q6: Multi-table customer report - order value and successfully paid value

```sql
-- Do not join Order_Details here: that would repeat order/payment amounts.
SELECT c.customer_name, COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS ordered_value,
       COALESCE(SUM(CASE WHEN pay.payment_status = 'SUCCESS'
                         THEN pay.amount ELSE 0 END), 0) AS paid_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;
```

| customer_name | total_orders | ordered_value | paid_value |
| --- | --- | --- | --- |
| Arun Kumar | 2 | 2896 | 2896 |
| Priya | 2 | 4297 | 3298 |
| Vasanth | 2 | 2697 | 2298 |
| Divya | 0 | 0 | 0 |

4 rows returned.


## Q7: Multi-table product report - only successfully paid orders

```sql
SELECT p.product_name, SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.unit_price) AS sales_amount
FROM Products p
INNER JOIN Order_Details od ON p.product_id = od.product_id
INNER JOIN Orders o ON od.order_id = o.order_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY p.product_id, p.product_name
ORDER BY sales_amount DESC, p.product_id;
```

| product_name | units_sold | sales_amount |
| --- | --- | --- |
| Mechanical Keyboard | 1 | 2499 |
| DBMS Fundamentals | 2 | 1300 |
| Jeans | 1 | 1299 |
| Wireless Mouse | 2 | 1198 |
| T-Shirt | 2 | 998 |
| Java Programming Book | 1 | 799 |
| USB-C Cable | 1 | 399 |

7 rows returned.


## Q8: Orders needing payment follow-up

```sql
SELECT o.order_id, c.customer_name, o.total_amount,
       COALESCE(pay.payment_status, 'NO PAYMENT') AS payment_status
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_id IS NULL OR pay.payment_status <> 'SUCCESS'
ORDER BY o.order_id;
```

| order_id | customer_name | total_amount | payment_status |
| --- | --- | --- | --- |
| 1005 | Priya | 999 | NO PAYMENT |
| 1006 | Vasanth | 399 | FAILED |

2 rows returned.
