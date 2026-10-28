# Task XII — Transaction Management System

## Objective
Demonstrate transactions for order totals, payment status, and inventory updates using COMMIT and ROLLBACK.

## Files
- [transaction_management.sql](transaction_management.sql) — transaction examples and consistency checks.

## Concepts covered
- Explicit transaction boundaries with START TRANSACTION.
- COMMIT to save successful changes.
- ROLLBACK to cancel uncommitted changes.
- Conditional stock updates to avoid selling more units than are available.
- ACID property notes and verification queries.

## Run
Use the existing `amazon_db` database in MySQL 8.0+. Review the example order/product IDs and quantities before executing the COMMIT example. The script does not create a new database or add sample records. Run transaction examples one at a time.