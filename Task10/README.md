# Task X — Advanced SQL Query System

## Objective
Use subqueries and nested queries to analyse products, customer purchases and order activity.

**Code:** [advanced_sql.sql](advanced_sql.sql)

## Queries Included
| Query | Purpose |
| --- | --- |
| 1 | Find products above the average price |
| 2 | Find customers with the highest total purchase amount |
| 3 | Find customers with the most orders |
| 4 | Find customers who bought above-average-priced products using nested queries |
| 5 | Find products never ordered using NOT EXISTS |
| 6 | Report customer order counts, total spending and above-average orders |

A **subquery** is a query inside another query. A **nested query** can contain further subqueries. Queries 2 and 3 include all customers tied for first place.

## How to Run
1. Open `advanced_sql.sql` in MySQL Workbench (MySQL 8.0+).
2. Run the full file once to create `amazon_task10`, insert sample values and execute the queries.
3. Later, run `USE amazon_task10;` and only the statements below `-- QUERIES`.

If the database already exists, reuse it and run only the queries, or change the database name in both CREATE DATABASE and USE. Earlier task databases are not required.

## Sample Findings
- Average product price: **Rs. 1,050**; Keyboard and Headphones are above average.
- Highest purchase amount: **Priya — Rs. 3,500**.
- Most orders: **Arun — 2 orders**.
- Product never ordered: **USB Cable**.
- Total order value: **Rs. 6,500**; Divya has no orders and appears with zero spending.

This short academic example treats all sample orders as completed purchases. It does not model payment status or refunds. Order details retain the unit price at purchase; query 4 compares current catalogue prices. Query 6 checks whether a customer has any individual order above the average order value.

## Validation
All six queries were executed and checked in SQLite with foreign keys enabled, skipping only MySQL's CREATE DATABASE and USE statements. Order totals match their order details. A native MySQL run was not available.
