# Task IX — Sales and Customer Analytics System

## Objective
Use SQL aggregate functions to analyse sales, identify top customers and best-selling products, and compare category performance.

**SQL file:** [sales_customer_analytics.sql](sales_customer_analytics.sql)

## Requirements Covered
| Requirement | Implementation |
| --- | --- |
| COUNT(), SUM(), AVG(), MIN(), MAX() | Q1: paid order count, total, average, minimum and maximum value |
| Total sales reports | Q1 overall and Q2 daily sales |
| Top customers by purchase amount | Q3 top three customers |
| Best-selling products | Q4 ranks products by paid quantity, then sales value |
| Category-wise sales | Q5 includes categories with zero paid sales |
| Additional business report | Q6 sales by payment method |

Only orders with `payment_status = 'SUCCESS'` count as sales. Pending, failed and missing payments are excluded. Best-selling means highest units sold; equal quantities are ordered by sales value and then product ID. Q3 returns exactly three customers when available, using customer ID to break equal purchase totals.

## Key Results
| Metric | Result |
| --- | --- |
| Paid orders | 4 |
| Total sales | Rs. 8,492.00 |
| Average order value | Rs. 2,123.00 |
| Minimum order value | Rs. 1,299.00 |
| Maximum order value | Rs. 3,298.00 |
| Top customer | Priya — Rs. 3,298.00 |
| Highest-sales category | Electronics — Rs. 4,096.00 |

DBMS Fundamentals, Wireless Mouse and T-Shirt each sold 2 units. DBMS Fundamentals appears first under the sales-value tie-break rule. Home Appliances shows zero paid sales.

## Database and Sample Data
The script creates a separate database and uses the naming conventions from earlier tasks: `Category`, `Customers`, `Products`, `Orders`, `Order_Details` and `Payment`.

Sample data: 4 customers, 4 categories, 8 products, 6 orders, 9 order items and 5 payment records. All records are fictional. Divya has no orders; order 1005 has no payment record; order 1006 has a failed payment. Home Appliances has no paid sales.

The simplified payment model allows one payment record per order (`order_id UNIQUE`). SUCCESS means fully paid. Partial payments, repeated payment attempts, refunds, taxes and shipping are outside this example. Sales use historical `unit_price` from order items, not the current catalogue price. Order totals are never summed after joining to multiple order-item rows.

## How to Run in MySQL
1. Open MySQL Workbench and connect to your MySQL 8.0.16+ server.
2. Open the SQL file linked above and run the full script once.
3. To repeat queries, execute the `USE` statement and only the numbered queries below `QUERY SECTION`.

The scripts create new databases (`amazon_task8` / `amazon_task9`) and contain no DROP statements. If a database already exists, rerun only its queries or choose a different name in CREATE DATABASE and USE.

## Validation
All queries were executed using SQLite 3.53.1 with foreign keys enabled. MySQL-specific CREATE DATABASE and USE statements were skipped. The SELECT queries, including RIGHT JOIN, ran as written. Order totals, paid sales and unmatched-record cases were checked. A native MySQL run was not available.

## Result
Implemented all five aggregate functions and verified that customer, product, category, daily and payment-method sales reports reconcile to Rs. 8,492.00.
