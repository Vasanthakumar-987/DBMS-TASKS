-- Standalone e-commerce sample for this task.
-- MySQL 8.0.16+ target. Run setup once, then rerun only the query section.
-- Standalone academic example using the naming style of Tasks II and IV.
-- This creates a new database and does not reset earlier task databases.
CREATE DATABASE amazon_task9;
USE amazon_task9;

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

-- Q1: COUNT, SUM, AVG, MIN and MAX - successfully paid orders
-- COUNT counts orders rather than order-item rows.
SELECT COUNT(*) AS paid_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_sales,
       ROUND(AVG(o.total_amount), 2) AS average_order_value,
       MIN(o.total_amount) AS minimum_order_value,
       MAX(o.total_amount) AS maximum_order_value
FROM Orders o
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS';

-- Q2: Daily total sales report
SELECT o.order_date, COUNT(*) AS paid_orders,
       SUM(o.total_amount) AS daily_sales
FROM Orders o
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY o.order_date
ORDER BY o.order_date;

-- Q3: Top three customers based on paid purchase amount
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS paid_orders,
       SUM(o.total_amount) AS purchase_amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY c.customer_id, c.customer_name
ORDER BY purchase_amount DESC, c.customer_id
LIMIT 3;

-- Q4: Best-selling products ranked by quantity, then sales value
-- Only paid purchases count. Ties in both measures use product_id.
SELECT p.product_id, p.product_name,
       SUM(od.quantity) AS units_sold,
       SUM(od.quantity * od.unit_price) AS sales_amount
FROM Products p
INNER JOIN Order_Details od ON p.product_id = od.product_id
INNER JOIN Orders o ON od.order_id = o.order_id
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, sales_amount DESC, p.product_id;

-- Q5: Category-wise paid sales, including categories with zero sales
-- Aggregate paid items first, then LEFT JOIN to keep zero-sales categories.
SELECT cat.category_name,
       COALESCE(SUM(s.units_sold), 0) AS units_sold,
       COALESCE(SUM(s.sales_amount), 0) AS sales_amount
FROM Category cat
LEFT JOIN Products p ON cat.category_id = p.category_id
LEFT JOIN (
    SELECT od.product_id, SUM(od.quantity) AS units_sold,
           SUM(od.quantity * od.unit_price) AS sales_amount
    FROM Order_Details od
    INNER JOIN Orders o ON od.order_id = o.order_id
    INNER JOIN Payment pay ON o.order_id = pay.order_id
    WHERE pay.payment_status = 'SUCCESS'
    GROUP BY od.product_id
) s ON p.product_id = s.product_id
GROUP BY cat.category_id, cat.category_name
ORDER BY sales_amount DESC, cat.category_id;

-- Q6: Sales by payment method
SELECT pay.payment_mode, COUNT(o.order_id) AS paid_orders,
       SUM(o.total_amount) AS sales_amount
FROM Orders o
INNER JOIN Payment pay ON o.order_id = pay.order_id
WHERE pay.payment_status = 'SUCCESS'
GROUP BY pay.payment_mode
ORDER BY sales_amount DESC, pay.payment_mode;
