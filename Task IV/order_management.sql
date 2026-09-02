DROP DATABASE IF EXISTS amazon_order_management;
CREATE DATABASE amazon_order_management;
USE amazon_order_management;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

-- 3. Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Customers VALUES
(1, 'Arun Kumar', 'arun@gmail.com'),
(2, 'Priya', 'priya@gmail.com'),
(3, 'Vasanth', 'vasanth@gmail.com');
INSERT INTO Products VALUES
(101, 'Wireless Mouse', 599.00, 50),
(102, 'Mechanical Keyboard', 2499.00, 30),
(103, 'USB-C Cable', 399.00, 100),
(104, 'Laptop Stand', 1299.00, 25),
(105, 'Web Camera', 1999.00, 20);
INSERT INTO Orders (order_id, customer_id, order_date, total_amount) VALUES
(1001, 1, '2026-09-01', 0),
(1002, 2, '2026-09-01', 0),
(1003, 3, '2026-09-02', 0);
INSERT INTO Order_Details VALUES
(1, 1001, 101, 2, 599.00),
(2, 1001, 103, 1, 399.00),
(3, 1002, 102, 1, 2499.00),
(4, 1002, 104, 1, 1299.00),
(5, 1003, 105, 1, 1999.00),
(6, 1003, 103, 2, 399.00);

UPDATE Orders o
SET total_amount = (
    SELECT SUM(od.quantity * od.unit_price)
    FROM Order_Details od
    WHERE od.order_id = o.order_id
);
SELECT * FROM Orders;

SELECT * FROM Order_Details;
UPDATE Order_Details
SET quantity = 3
WHERE order_detail_id = 1;
UPDATE Orders o
SET total_amount = (
    SELECT SUM(od.quantity * od.unit_price)
    FROM Order_Details od
    WHERE od.order_id = o.order_id
)
WHERE order_id = 1001;

SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    p.product_name,
    od.quantity,
    od.unit_price,
    (od.quantity * od.unit_price) AS item_total,
    o.total_amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
ORDER BY c.customer_id, o.order_date, o.order_id;

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;
