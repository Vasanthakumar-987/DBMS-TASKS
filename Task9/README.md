# Task IX — Sales and Customer Analytics System

[SQL code](sales_customer_analytics.sql)

1. COUNT, SUM, AVG, MIN and MAX for paid orders and total sales.
2. Daily sales report.
3. Customer ranking by purchase amount.
4. Best-selling products ranked by quantity, then sales value.
5. **Pending: category-wise sales.** The existing `amazon_db.PRODUCT` has only `product_id`, `title`, `price` and `stock`; no category relationship exists. A verified category mapping is required to write this query. The separate Task II database is not linked to these products, so its IDs cannot be assumed to match.

Sales include only `PAYMENT.status = 'Completed'`. Product sales use historical `ORDER_ITEM.price`. AVG, MIN and MAX return NULL when there are no paid orders.

## Run
Open the SQL file in MySQL and run it against the existing `amazon_db`. It starts with `USE amazon_db;` and reads your existing records. Empty tables produce empty reports.

Uses the main repository schema: `USER` (customers), `PRODUCT` (`title`), `ORDERS`, `ORDER_ITEM` (`price`) and `PAYMENT` (`payment_method`, `status`).

## Validation
Queries were executed on a matching SQLite test schema, excluding USE. Native MySQL and your local data were not available for testing.
