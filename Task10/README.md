# Task X — Advanced SQL Query System

[SQL code](advanced_sql.sql)

1. Subquery to find products above average price.
2. Find customers with maximum total order value, including ties.
3. Nested queries to find customers ordering above-average-priced products.
4. NOT EXISTS query to find products never ordered.
5. Customer report with order count, total spending and an above-average-order indicator.

Purchases here mean all recorded orders, regardless of payment status. Query 3 compares current catalogue prices. The report includes customers without orders.

## Run
Open the SQL file in MySQL and run it against the existing `amazon_db`. It starts with `USE amazon_db;` and reads your existing records. Empty tables produce empty reports.

Uses the main repository schema: `USER` (customers), `PRODUCT` (`title`), `ORDERS`, `ORDER_ITEM` (`price`) and `PAYMENT` (`payment_method`, `status`).

## Validation
Queries were executed on a matching SQLite test schema, excluding USE. Native MySQL and your local data were not available for testing.
