DROP DATABASE IF EXISTS amazon_review_rating_management;
CREATE DATABASE amazon_review_rating_management;
USE amazon_review_rating_management;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Review (
    review_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    review_text VARCHAR(500),
    review_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Rating (
    rating_id INT PRIMARY KEY,
    review_id INT NOT NULL UNIQUE,
    product_id INT NOT NULL,
    rating DECIMAL(2,1) NOT NULL,
    FOREIGN KEY (review_id) REFERENCES Review(review_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES
(1, 'Arun Kumar', 'arun@gmail.com'),
(2, 'Priya', 'priya@gmail.com'),
(3, 'Vasanth', 'vasanth@gmail.com'),
(4, 'Karthik', 'karthik@gmail.com'),
(5, 'Divya', 'divya@gmail.com');

INSERT INTO Products VALUES
(101, 'Wireless Mouse', 599.00),
(102, 'Mechanical Keyboard', 2499.00),
(103, 'USB-C Cable', 399.00),
(104, 'Laptop Stand', 1299.00),
(105, 'Web Camera', 1999.00);

INSERT INTO Review VALUES
(1, 1, 101, 'Good quality and smooth performance.', '2026-08-25'),
(2, 2, 101, 'Value for money.', '2026-08-26'),
(3, 3, 102, 'Excellent keyboard for coding.', '2026-08-27'),
(4, 4, 102, 'Good product but a little expensive.', '2026-08-28'),
(5, 5, 103, 'Works well and charging is fast.', '2026-08-29'),
(6, 1, 104, 'Strong and useful stand.', '2026-08-30'),
(7, 2, 105, 'Clear video quality.', '2026-08-31'),
(8, 3, 105, 'Very good camera for online classes.', '2026-09-01');
INSERT INTO Rating VALUES
(1, 1, 101, 4.0),
(2, 2, 101, 4.5),
(3, 3, 102, 5.0),
(4, 4, 102, 4.0),
(5, 5, 103, 3.5),
(6, 6, 104, 4.5),
(7, 7, 105, 5.0),
(8, 8, 105, 4.5);

SELECT
    p.product_name,
    c.customer_name,
    r.review_text,
    r.review_date,
    rt.rating
FROM Review r
JOIN Rating rt ON r.review_id = rt.review_id
JOIN Customers c ON r.customer_id = c.customer_id
JOIN Products p ON r.product_id = p.product_id
ORDER BY p.product_id, r.review_date;

SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(rt.rating), 2) AS average_rating,
    COUNT(rt.rating) AS number_of_ratings
FROM Products p
JOIN Rating rt ON p.product_id = rt.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC;

SELECT
    p.product_id,
    p.product_name,
    ROUND(AVG(rt.rating), 2) AS average_rating
FROM Products p
JOIN Rating rt ON p.product_id = rt.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(rt.rating) >= 4.5
ORDER BY average_rating DESC;

SELECT
    p.product_name,
    ROUND(AVG(rt.rating), 2) AS average_rating
FROM Products p
JOIN Rating rt ON p.product_id = rt.product_id
GROUP BY p.product_id, p.product_name
ORDER BY average_rating DESC
LIMIT 1;

SELECT
    COUNT(*) AS total_ratings,
    ROUND(AVG(rating), 2) AS overall_average_rating,
    MAX(rating) AS highest_rating,
    MIN(rating) AS lowest_rating
FROM Rating;
