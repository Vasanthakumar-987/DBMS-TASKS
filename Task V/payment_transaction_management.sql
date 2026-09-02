-- TASK V: PAYMENT TRANSACTION MANAGEMENT SYSTEM
-- Amazon E-Commerce Database Project

DROP DATABASE IF EXISTS amazon_payment_management;
CREATE DATABASE amazon_payment_management;
USE amazon_payment_management;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Payment table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_mode VARCHAR(30) NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    transaction_reference VARCHAR(50) UNIQUE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Sample customers
INSERT INTO Customers VALUES
(1, 'Arun Kumar', 'arun@gmail.com'),
(2, 'Priya', 'priya@gmail.com'),
(3, 'Vasanth', 'vasanth@gmail.com'),
(4, 'Karthik', 'karthik@gmail.com');

-- Sample orders
INSERT INTO Orders VALUES
(1001, 1, '2026-09-01', 1598.00),
(1002, 2, '2026-09-01', 3798.00),
(1003, 3, '2026-09-02', 1999.00),
(1004, 4, '2026-09-02', 2499.00),
(1005, 1, '2026-09-02', 599.00);

-- Successful and failed payment transactions
INSERT INTO Payment VALUES
(1, 1001, 'UPI', '2026-09-01', 1598.00, 'SUCCESS', 'TXN10001'),
(2, 1002, 'Credit Card', '2026-09-01', 3798.00, 'SUCCESS', 'TXN10002'),
(3, 1003, 'Debit Card', '2026-09-02', 1999.00, 'FAILED', 'TXN10003'),
(4, 1004, 'Net Banking', '2026-09-02', 2499.00, 'SUCCESS', 'TXN10004'),
(5, 1005, 'UPI', '2026-09-02', 599.00, 'FAILED', 'TXN10005');

-- View all payment transactions
SELECT * FROM Payment;

-- Modify a failed transaction after successful retry
UPDATE Payment
SET payment_status = 'SUCCESS'
WHERE payment_id = 3;

-- Analyze payment methods used by customers
SELECT
    payment_mode,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_mode
ORDER BY transaction_count DESC;

-- Count successful and failed transactions
SELECT
    payment_status,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM Payment
GROUP BY payment_status;

-- Payment transaction report
SELECT
    p.payment_id,
    c.customer_name,
    p.order_id,
    p.payment_mode,
    p.payment_date,
    p.amount,
    p.payment_status,
    p.transaction_reference
FROM Payment p
JOIN Orders o ON p.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
ORDER BY p.payment_date, p.payment_id;

-- Successful payment report
SELECT *
FROM Payment
WHERE payment_status = 'SUCCESS';
