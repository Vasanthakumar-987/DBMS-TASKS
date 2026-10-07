-- Standalone e-commerce sample for this task.
-- MySQL 8.0.16+ target. Run setup once, then rerun only the query section.
-- Standalone academic example using the naming style of Tasks II and IV.
-- This creates a new database and does not reset earlier task databases.
CREATE DATABASE amazon_task8;
USE amazon_task8;

-- SETUP: tables and fictional sample data
CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Category VALUES
(1, 'Electronics'), (2, 'Clothing'), (3, 'Books'), (4, 'Home Appliances');

INSERT INTO Customers VALUES
(1, 'Arun Kumar', 'arun@example.com'),
(2, 'Priya', 'priya@example.com'),
(3, 'Vasanth', 'vasanth@example.com'),
(4, 'Divya', 'divya@example.com');

INSERT INTO Products VALUES
(101, 'Wireless Mouse', 1, 599.00, 50),
(102, 'Mechanical Keyboard', 1, 2499.00, 0),
(103, 'USB-C Cable', 1, 399.00, 100),
(104, 'T-Shirt', 2, 499.00, 40),
(105, 'Jeans', 2, 1299.00, 8),
(106, 'Java Programming Book', 3, 799.00, 25),
(107, 'DBMS Fundamentals', 3, 650.00, 0),
(108, 'Electric Kettle', 4, 999.00, 5);

-- Historical purchases; stock above represents current availability.
INSERT INTO Orders VALUES
(1001, 1, '2026-09-01', 1597.00),
(1002, 2, '2026-09-02', 3298.00),
(1003, 3, '2026-09-03', 2298.00),
(1004, 1, '2026-09-04', 1299.00);

INSERT INTO Order_Details VALUES
(1, 1001, 101, 2, 599.00),
(2, 1001, 103, 1, 399.00),
(3, 1002, 102, 1, 2499.00),
(4, 1002, 106, 1, 799.00),
(5, 1003, 104, 2, 499.00),
(6, 1003, 107, 2, 650.00),
(7, 1004, 105, 1, 1299.00);



-- Two more orders demonstrate missing and failed payments.
INSERT INTO Orders VALUES
(1005, 2, '2026-09-05', 999.00),
(1006, 3, '2026-09-05', 399.00);
INSERT INTO Order_Details VALUES
(8, 1005, 108, 1, 999.00),
(9, 1006, 103, 1, 399.00);

-- Simplified model: at most one payment record per order.
-- SUCCESS means the order is fully paid. No partial payments or refunds.
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_mode VARCHAR(30) NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_status VARCHAR(20) NOT NULL
        CHECK (payment_status IN ('SUCCESS', 'FAILED', 'PENDING')),
    transaction_reference VARCHAR(50) UNIQUE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO Payment VALUES
(1, 1001, 'UPI', '2026-09-01', 1597.00, 'SUCCESS', 'DEMO1001'),
(2, 1002, 'Credit Card', '2026-09-02', 3298.00, 'SUCCESS', 'DEMO1002'),
(3, 1003, 'Debit Card', '2026-09-03', 2298.00, 'SUCCESS', 'DEMO1003'),
(4, 1004, 'UPI', '2026-09-04', 1299.00, 'SUCCESS', 'DEMO1004'),
(5, 1006, 'UPI', '2026-09-05', 399.00, 'FAILED', 'DEMO1006');

-- QUERY SECTION

-- Q1: INNER JOIN - customer, order, product and payment details
-- One result row per order item. Orders without payment records are excluded.
SELECT c.customer_name, o.order_id, p.product_name,
       od.quantity, od.unit_price,
       od.quantity * od.unit_price AS item_total,
       pay.payment_mode, pay.payment_status
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
ORDER BY o.order_id, od.order_detail_id;

-- Q2: LEFT JOIN - all customers, including customers with no orders
SELECT c.customer_id, c.customer_name, o.order_id, o.total_amount
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_id;

-- Q3: RIGHT JOIN - all orders, including orders with no payment record
SELECT o.order_id, o.total_amount, pay.payment_id,
       pay.payment_mode, pay.payment_status
FROM Payment pay
RIGHT JOIN Orders o ON pay.order_id = o.order_id
ORDER BY o.order_id;

-- Q4: Complete order details, retaining unpaid orders
SELECT o.order_id, o.order_date, c.customer_name,
       p.product_name, cat.category_name, od.quantity,
       od.unit_price, od.quantity * od.unit_price AS item_total,
       o.total_amount AS order_total, pay.amount AS payment_amount,
       COALESCE(pay.payment_status, 'NO PAYMENT') AS payment_status
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id
INNER JOIN Category cat ON p.category_id = cat.category_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
ORDER BY o.order_id, od.order_detail_id;

-- Q5: Customer purchase history - Arun Kumar (customer_id = 1)
-- Change the customer ID to view another customer's history.
SELECT c.customer_name, o.order_id, o.order_date,
       p.product_name, od.quantity,
       od.quantity * od.unit_price AS item_total,
       COALESCE(pay.payment_status, 'NO PAYMENT') AS payment_status
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Order_Details od ON o.order_id = od.order_id
INNER JOIN Products p ON od.product_id = p.product_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
WHERE c.customer_id = 1
ORDER BY o.order_date, o.order_id, od.order_detail_id;

-- Q6: Multi-table customer report - order value and successfully paid value
-- Do not join Order_Details here: that would repeat order/payment amounts.
SELECT c.customer_name, COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS ordered_value,
       COALESCE(SUM(CASE WHEN pay.payment_status = 'SUCCESS'
                         THEN pay.amount ELSE 0 END), 0) AS paid_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;

-- Q7: Multi-table product report - only successfully paid orders
SELECT p.product_name, SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.unit_price) AS sales_amount
FROM Products p
INNER JOIN Order_Details od ON p.product_id = od.product_id
INNER JOIN Orders o ON od.order_id = o.order_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY p.product_id, p.product_name
ORDER BY sales_amount DESC, p.product_id;

-- Q8: Orders needing payment follow-up
SELECT o.order_id, c.customer_name, o.total_amount,
       COALESCE(pay.payment_status, 'NO PAYMENT') AS payment_status
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
LEFT JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_id IS NULL OR pay.payment_status <> 'SUCCESS'
ORDER BY o.order_id;
