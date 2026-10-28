# Task XI — Database Automation using Views and Procedures

## Objective
Create reusable views, stored procedures, and functions to automate common e-commerce database operations.

## Files
- [database_automation.sql](database_automation.sql) — views, a sales function, order-total procedure, and validation queries.

## Objects implemented
1. `vw_order_summary` — customer, order, and payment summary.
2. `vw_product_sales` — quantity sold and sales value per product.
3. `fn_order_item_total` — calculates line-item value.
4. `sp_refresh_order_total` — recalculates an order total from its order items.
5. Validation SELECT statements to test the objects.

## Run
1. Open MySQL Workbench and select the existing `amazon_db` database.
2. Run the SQL script in order.
3. Execute the test calls at the bottom and inspect the results.

This task uses the existing `USER`, `PRODUCT`, `ORDERS`, `ORDER_ITEM`, and `PAYMENT` tables. It does not create a new database or insert sample data. MySQL 8.0+ is recommended.