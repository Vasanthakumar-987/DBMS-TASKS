-- Task X: Advanced SQL Query System (MySQL 8.0+)
-- Run setup once. On later runs, execute USE and the queries only.
CREATE DATABASE amazon_task10;
USE amazon_task10;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES
(1, 'Arun'), (2, 'Priya'), (3, 'Vasanth'), (4, 'Divya');
INSERT INTO Products VALUES
(101, 'Mouse', 500), (102, 'Keyboard', 1500),
(103, 'Headphones', 2000), (104, 'USB Cable', 200);
INSERT INTO Orders VALUES
(1, 1, 1000), (2, 2, 3500), (3, 1, 1500), (4, 3, 500);
INSERT INTO Order_Details VALUES
(1, 101, 2, 500), (2, 102, 1, 1500),
(2, 103, 1, 2000), (3, 102, 1, 1500), (4, 101, 1, 500);

-- QUERIES
-- 1. Products above average price (subquery).
SELECT product_name, price FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- 2. Customers with maximum purchase amount (includes ties).
SELECT c.customer_name, SUM(o.total_amount) AS total_spent
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total) FROM (
        SELECT SUM(total_amount) AS total
        FROM Orders GROUP BY customer_id
    ) AS purchases
);

-- 3. Customers with maximum number of orders (includes ties).
SELECT c.customer_name, COUNT(*) AS order_count
FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) = (
    SELECT MAX(total) FROM (
        SELECT COUNT(*) AS total FROM Orders GROUP BY customer_id
    ) AS purchases
);

-- 4. Customers who bought above-average-priced products (nested queries).
-- Price comparison uses the current product catalogue.
SELECT customer_name FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Orders WHERE order_id IN (
        SELECT order_id FROM Order_Details WHERE product_id IN (
            SELECT product_id FROM Products
            WHERE price > (SELECT AVG(price) FROM Products)
        )
    )
);

-- 5. Products never ordered (correlated subquery).
SELECT product_name FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Order_Details d WHERE d.product_id = p.product_id
);

-- 6. Advanced customer report, including customers without orders.
SELECT c.customer_name, COUNT(o.order_id) AS order_count,
       COALESCE(SUM(o.total_amount), 0) AS total_spent,
       CASE WHEN MAX(o.total_amount) > (SELECT AVG(total_amount) FROM Orders)
            THEN 'Yes' ELSE 'No' END AS has_above_average_order
FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC, c.customer_id;
