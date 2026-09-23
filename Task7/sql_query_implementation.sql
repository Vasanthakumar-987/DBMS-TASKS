-- Task VII: SQL Query Implementation for E-Commerce Database
-- MySQL 8.0+. Run setup once; rerun the SELECT queries as needed.
-- Standalone academic example using the naming style of Tasks II and IV.
-- This creates a new database and does not reset earlier task databases.
CREATE DATABASE amazon_query_implementation;
USE amazon_query_implementation;

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

-- QUERY SECTION: execute this section again without rerunning setup.

-- 1. SELECT: display all products.
SELECT * FROM Products;

-- 2. WHERE: products priced below Rs. 1000.
SELECT product_id, product_name, price
FROM Products
WHERE price < 1000;

-- 3. ORDER BY: products from lowest to highest price.
SELECT product_name, price
FROM Products
ORDER BY price ASC, product_id;

-- 4. DISTINCT: category IDs represented in the product catalogue.
SELECT DISTINCT category_id
FROM Products
ORDER BY category_id;

-- 5. Price search: BETWEEN includes both endpoints.
SELECT product_name, price
FROM Products
WHERE price BETWEEN 500 AND 1500
ORDER BY price, product_id;

-- 6. Category search: Electronics products.
SELECT p.product_name, c.category_name, p.price
FROM Products p
JOIN Category c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics'
ORDER BY p.product_id;

-- 7. Availability search: products currently in stock.
SELECT product_name, stock
FROM Products
WHERE stock > 0
ORDER BY product_id;

-- 8. Availability search: products currently out of stock.
SELECT product_name, stock
FROM Products
WHERE stock = 0
ORDER BY product_id;

-- 9. Combined search: available Electronics products costing at most Rs. 1000.
SELECT p.product_name, c.category_name, p.price, p.stock
FROM Products p
JOIN Category c ON p.category_id = c.category_id
WHERE p.price <= 1000
  AND c.category_name = 'Electronics'
  AND p.stock > 0
ORDER BY p.price, p.product_id;

-- 10. Retrieve customer information.
SELECT customer_id, customer_name, email
FROM Customers
ORDER BY customer_id;

-- 11. Retrieve product information with category names.
SELECT p.product_id, p.product_name, c.category_name, p.price, p.stock
FROM Products p
JOIN Category c ON p.category_id = c.category_id
ORDER BY p.product_id;

-- 12. Retrieve customers and the products they ordered.
SELECT c.customer_name, o.order_id, o.order_date,
       p.product_name, od.quantity, od.unit_price,
       od.quantity * od.unit_price AS item_total
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
ORDER BY o.order_id, od.order_detail_id;

-- 13. LIKE: search for a word in a product name.
SELECT product_name, price
FROM Products
WHERE product_name LIKE '%Book%';

-- 14. IN: filter multiple categories.
SELECT p.product_name, c.category_name, p.price
FROM Products p
JOIN Category c ON p.category_id = c.category_id
WHERE c.category_name IN ('Clothing', 'Books')
ORDER BY c.category_name, p.product_id;

-- 15. OR: products needing restocking (including zero stock).
SELECT product_name, stock
FROM Products
WHERE stock = 0 OR stock BETWEEN 1 AND 10
ORDER BY stock, product_id;

-- 16. Date filtering: orders in the specified inclusive date range.
SELECT order_id, customer_id, order_date, total_amount
FROM Orders
WHERE order_date BETWEEN '2026-09-01' AND '2026-09-03'
ORDER BY order_date, order_id;

-- 17. Business report: category-wise product count, average price and stock.
SELECT c.category_name,
       COUNT(p.product_id) AS product_count,
       ROUND(AVG(p.price), 2) AS average_price,
       COALESCE(SUM(p.stock), 0) AS total_stock
FROM Category c
LEFT JOIN Products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY c.category_id;

-- 18. Business report: catalogue value at current selling prices.
-- Inventory value is not sales revenue or profit.
SELECT COUNT(*) AS total_products,
       SUM(stock) AS total_units_in_stock,
       SUM(price * stock) AS inventory_value
FROM Products;

-- 19. Business report: order count and total order value.
-- No payment/status model is used here; this is not confirmed cash received.
SELECT COUNT(*) AS total_orders,
       SUM(total_amount) AS total_order_value
FROM Orders;

-- 20. Business report: customer-wise order value (including no-order customers).
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders,
       COALESCE(SUM(o.total_amount), 0) AS total_order_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_order_value DESC, c.customer_id;

-- 21. Business report: product-wise ordered quantities and historical value.
SELECT p.product_name,
       COALESCE(SUM(od.quantity), 0) AS units_ordered,
       COALESCE(SUM(od.quantity * od.unit_price), 0) AS ordered_sales_value
FROM Products p
LEFT JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY ordered_sales_value DESC, p.product_id;

-- 22. Business report: daily order totals.
SELECT order_date, COUNT(*) AS total_orders,
       SUM(total_amount) AS total_order_value
FROM Orders
GROUP BY order_date
ORDER BY order_date;

-- 23. HAVING: customers whose total order value exceeds Rs. 2500.
SELECT c.customer_id, c.customer_name,
       SUM(o.total_amount) AS total_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > 2500
ORDER BY total_order_value DESC, c.customer_id;
