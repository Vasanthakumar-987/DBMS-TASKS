# Task IV – Order Management System

## Objective
Design and implement an Order Management System for the Amazon E-Commerce Database project.

## Requirements Covered
1. Design `Orders` and `Order_Details` tables.
2. Manage customer product orders.
3. Store order date, quantity, unit price and total amount.
4. Perform order insertion and modification operations.
5. Generate customer order history reports.

## Tables
- `Customers` – stores customer information.
- `Products` – stores product information.
- `Orders` – stores order header information.
- `Order_Details` – stores products included in each order.

## SQL File
See `order_management.sql` for table creation, sample data, insertion, modification and order-history report queries.

## Relationship
`Customers 1 ───< Orders 1 ───< Order_Details >─── 1 Products`

Prepared by: Vasanthakumar  
Register Number: AADS25031  
Program: B.Sc. AI & Data Science
