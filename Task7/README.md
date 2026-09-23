# Task VII — SQL Query Implementation for E-Commerce Database

## Objective
Use SQL to retrieve e-commerce data, search products, apply filtering conditions and generate basic business reports.

## Files
- [sql_query_implementation.sql](sql_query_implementation.sql): table creation, sample records and 23 numbered queries.

## Database
**Target:** MySQL 8.0+  
**Database name:** `amazon_query_implementation`

This is a standalone academic example following the naming style of Tasks II and IV. It combines categories with customer, product and order data in a separate database. Earlier task databases are not required.

| Table | Purpose |
| --- | --- |
| Category | Product category names |
| Customers | Customer names and email addresses |
| Products | Product name, category, price and current stock |
| Orders | Customer orders, dates and total amounts |
| Order_Details | Ordered products, quantities and historical unit prices |

Primary and foreign keys connect the tables. Sample data contains 4 categories, 4 customers, 8 products, 4 orders and 7 order details. All customer records are fictional.

## Task Requirements Covered

| Requirement | Queries |
| --- | --- |
| SELECT, WHERE, ORDER BY and DISTINCT | 1–4 |
| Search by price, category and availability | 5–9 |
| Retrieve customer and product information | 10–12 |
| Apply LIKE, IN, OR and date filters | 13–16 |
| Generate business reports using aggregates, GROUP BY and HAVING | 17–23 |

## How to Run
1. Open a MySQL connection in MySQL Workbench.
2. Open `sql_query_implementation.sql`.
3. On the first run, execute the full script to create the database, insert sample values and display results.
4. For later runs, execute `USE amazon_query_implementation;`, then select and execute only the numbered queries below **QUERY SECTION**.

The setup is intended to run once. If that database already exists, use the existing setup and rerun only the query section, or choose a new database name in both the CREATE DATABASE and USE statements. No DROP statements are included.

## Sample Results

| Report | Expected result |
| --- | --- |
| Total products | 8 |
| Total units in stock | 228 |
| Inventory value at current selling prices | Rs. 125,172.00 |
| Total orders | 4 |
| Total order value | Rs. 8,492.00 |
| Out-of-stock products | Mechanical Keyboard; DBMS Fundamentals |
| Available Electronics costing at most Rs. 1,000 | USB-C Cable; Wireless Mouse |

### Customer-wise Order Report

| Customer | Orders | Total order value (Rs.) |
| --- | ---: | ---: |
| Priya | 1 | 3,298.00 |
| Arun Kumar | 2 | 2,896.00 |
| Vasanth | 1 | 2,298.00 |
| Divya | 0 | 0.00 |

The LEFT JOIN includes customers with no orders and products with no sales. Product sales values use historical `Order_Details.unit_price`, while inventory value uses current `Products.price`. Order value is not confirmed payment revenue; this example does not model payment status, cancellations, refunds, taxes or shipping.

## Validation
All 23 SELECT queries were executed against the sample data using SQLite with foreign keys enabled, excluding the MySQL-specific CREATE DATABASE and USE statements. Order totals were checked against their detail rows, including zero-stock and no-order cases. A native MySQL run was not available in the validation environment.

## Result
Implemented product searches, customer and product retrieval, filtering conditions, category summaries, inventory valuation, customer-wise order totals, product-wise sales values and daily order reports.
