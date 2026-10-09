# Task VIII — Database Relationship Analysis using Joins

[SQL code](database_relationship_joins.sql)

1. INNER JOIN combines customers, products, orders and payments.
2. LEFT JOIN includes customers without orders.
3. RIGHT JOIN includes orders without payments.
4. Retrieve complete order details.
5. Display purchase history (change `user_id = 1` as needed).
6. Generate a customer order/payment summary.

Paid value uses `PAYMENT.status = 'Completed'`, as described in the main README. Item rows repeat order totals for display; the summary counts each order only once.

## Run
Open the SQL file in MySQL and run it against the existing `amazon_db`. It starts with `USE amazon_db;` and reads your existing records. Empty tables produce empty reports.

Uses the main repository schema: `USER` (customers), `PRODUCT` (`title`), `ORDERS`, `ORDER_ITEM` (`price`) and `PAYMENT` (`payment_method`, `status`).

## Validation
Queries were executed on a matching SQLite test schema, excluding USE. Native MySQL and your local data were not available for testing.
