# Task XV — Industry Capstone Project: E-Commerce Intelligence Platform

## Objective
Integrate the DBMS tasks into one end-to-end e-commerce database solution and produce useful business insights.

## Files
- [capstone_queries.sql](capstone_queries.sql) — consolidated analytical reports and object checks.
- [ER_Diagram.md](ER_Diagram.md) — Mermaid ER diagram for GitHub preview.

## Project components
1. Integrate the existing user, product, order, order-item, and payment modules.
2. Include the ER diagram and normalized relational schema.
3. Use the existing `amazon_db` records; do not create a separate database.
4. Demonstrate basic and advanced SQL queries, joins, subqueries, views, procedures, and functions from earlier tasks.
5. Include trigger/index examples only after checking schema constraints and permissions.
6. Generate customer, product, payment, and sales insights.
7. Validate the database objects and document query outputs.

## ER diagram
Open [ER_Diagram.md](ER_Diagram.md). GitHub renders the Mermaid entity-relationship diagram in the file preview.

## How to run
Use MySQL 8.0+ and select the existing `amazon_db`. Run the analytical queries in `capstone_queries.sql`. The file reads existing data and does not create or populate a new database. Stored routines and views from Tasks XI–XIV should be created by running their task scripts first.

## Deliverables
- ER diagram and relational schema
- SQL scripts for core and advanced queries
- Views, procedures, functions, and index examples
- Analytical outputs and a short business-insights summary
