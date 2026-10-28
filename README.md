# 🛒 Amazon E-Commerce Database Design

![DBMS](https://img.shields.io/badge/DBMS-Project-blue?style=for-the-badge&logo=mysql)
![SQL](https://img.shields.io/badge/SQL-MySQL-orange?style=for-the-badge&logo=mysql)
![Normalization](https://img.shields.io/badge/Database-3NF%20Normalized-success?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)
 
### 🎓 DBMS Academic Project (TASK-3)

- **Prepared by:** Vasanthakumar  
- **Register Number:** AADS25031  
- **Programme / Department:** B.sc AI&DS  
- **Institution:** AMET UNIVERSITY 
---

## 📌 Project Overview

This repository features a complete relational database design for an **Amazon-style E-Commerce Platform** developed for the **Database Management Systems (DBMS)** coursework.

The database models core operational workflows including **User Management**, **Product Catalogs**, **Shopping Carts**, **Order Processing**, **Payments**, and **Customer Reviews**. Developed conceptually using **StarUML**, converted into a **3NF Relational Schema**, and fully defined using **SQL Data Definition Language (DDL)**.

> ℹ️ **Note:** *This is an academic schema created for educational purposes and does not represent Amazon's proprietary enterprise architecture.*

---

## 📑 Table of Contents

- [📌 Project Overview](#-project-overview)
- [🎯 Objectives](#-objectives)
- [⚙️ Functional Requirements](#️-functional-requirements)
- [🔒 Non-Functional Requirements](#-non-functional-requirements)
- [🗂 Database Entities \& Schema Matrix](#-database-entities--schema-matrix)
- [📊 ER Diagram](#-er-diagram)
- [🔗 Relational Schema](#-relational-schema)
- [💻 SQL Schema Implementation](#-sql-schema-implementation)
- [📐 Database Normalization (3NF)](#-database-normalization-3nf)
- [🛠 Technologies Used](#-technologies-used)
- [🏁 Conclusion](#-conclusion)

---

## 🎯 Objectives

* **Conceptual Modeling:** Identify key business entities, relationships, attributes, primary keys, and foreign keys.
* **Diagrammatic Representation:** Build a clear Entity-Relationship (ER) Diagram using **Crow's Foot Notation** in StarUML.
* **Relational Mapping:** Convert the ER model into an optimized Relational Schema.
* **Database Implementation:** Write robust, production-ready SQL (DDL) scripts with foreign key cascading rules.
* **Data Integrity:** Eliminate redundant data and anomaly risks by adhering strictly to **Third Normal Form (3NF)** rules.

---

## ⚙️ Functional Requirements

### 1. 👤 User Management
- User registration, login authentication, and profile updates (`user_id`, `name`, `email`, `password`).

### 2. 📦 Product Catalog
- Product browsing with structured titles, unit pricing, and real-time inventory tracking (`stock`).

### 3. 🛒 Shopping Cart System
- Dynamic cart management enabling users to add, remove, or modify product quantities.

### 4. 🛍️ Order Management
- Order placement conversion from cart items, retaining historical unit prices and transaction totals.

### 5. 💳 Payment Processing
- Multi-mode payment support (UPI, Cards, Net Banking, COD) tracking explicit status states (`Pending`, `Completed`).

### 6. ⭐ Reviews & Ratings
- Verified customer feedback mechanism capturing numeric ratings and detailed product commentary.

---

## 🔒 Non-Functional Requirements

* **Performance:** Schema design optimized for quick query retrieval and join efficiency.
* **Data Integrity:** Enforced referential integrity using strict `FOREIGN KEY` constraints and `ON DELETE CASCADE`.
* **Scalability:** Modular structural footprint easily adaptable to new entity additions (e.g., Sellers, Shipping Tracking).
* **Security:** Structured fields capable of storing encrypted/hashed credentials.

---

## 🗂 Database Entities & Schema Matrix

| Entity | Primary Key (PK) | Foreign Keys (FK) | Description |
| :--- | :--- | :--- | :--- |
| **`USER`** | `user_id` | *None* | Customer registration details and login credentials |
| **`PRODUCT`** | `product_id` | *None* | Item details, pricing, and available stock levels |
| **`CART`** | `cart_id` | `user_id` | Active shopping cart assigned uniquely to a user |
| **`CART_ITEM`** | `cart_item_id` | `cart_id`, `product_id` | Specific product line-items contained in a shopping cart |
| **`ORDERS`** | `order_id` | `user_id` | Placed order records, execution timestamps, and total cost |
| **`ORDER_ITEM`** | `order_item_id` | `order_id`, `product_id` | Individual line-items and historical unit prices inside an order |
| **`PAYMENT`** | `payment_id` | `order_id` | Payment transaction records and execution status |
| **`REVIEW`** | `review_id` | `user_id`, `product_id` | Customer product ratings and written feedback |

---

## 📊 ER Diagram

The ER Diagram was modeled using **StarUML** with **Crow's Foot Notation** to visually define cardinality and relational bounds across all tables:

<p align="center">
  <img src="https://github.com/Vasanthakumar-987/DBMS-TASKS/blob/main/Task-3/Amozon-E-Commerce%20ER%20Diagram1%20jpg.jpg?raw=true" alt="Amazon E-Commerce ER Diagram" width="100%">
</p>

---

## 🔗 Relational Schema

Below is the normalized relational database schema mapped from the ER Diagram:

> 🗝️ **Legend:** **`Bold & Underlined`** = Primary Key (PK) | *Italics* = Foreign Key (FK)

* **USER** (**`user_id`**, name, email, password)
* **PRODUCT** (**`product_id`**, title, price, stock)
* **CART** (**`cart_id`**, *user_id*)
* **CART_ITEM** (**`cart_item_id`**, *cart_id*, *product_id*, quantity)
* **ORDERS** (**`order_id`**, *user_id*, order_date, total_amount)
* **ORDER_ITEM** (**`order_item_id`**, *order_id*, *product_id*, quantity, price)
* **PAYMENT** (**`payment_id`**, *order_id*, payment_method, status)
* **REVIEW** (**`review_id`**, *user_id*, *product_id*, rating, comment)

---

## 💻 SQL Schema Implementation

Below is the complete, runnable SQL Data Definition Language (DDL) script to set up the database tables and maintain integrity constraints:

```sql
-- Create Database
CREATE DATABASE IF NOT EXISTS amazon_db;
USE amazon_db;

-- 1. Create USER Table
CREATE TABLE USER (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- 2. Create PRODUCT Table
CREATE TABLE PRODUCT (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 3. Create CART Table
CREATE TABLE CART (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE,
    FOREIGN KEY (user_id) REFERENCES USER(user_id) ON DELETE CASCADE
);

-- 4. Create CART_ITEM Table
CREATE TABLE CART_ITEM (
    cart_item_id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES CART(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE
);

-- 5. Create ORDERS Table
CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USER(user_id) ON DELETE CASCADE
);

-- 6. Create ORDER_ITEM Table
CREATE TABLE ORDER_ITEM (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE
);

-- 7. Create PAYMENT Table
CREATE TABLE PAYMENT (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id) ON DELETE CASCADE
);

-- 8. Create REVIEW Table
CREATE TABLE REVIEW (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    FOREIGN KEY (user_id) REFERENCES USER(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) ON DELETE CASCADE
);
```

---

## 📐 Database Normalization (3NF)

To eliminate data redundancy, avoid anomalies (insertion, update, deletion), and maintain high performance, the schema follows standard database normalization rules up to **Third Normal Form (3NF)**:

### 1️⃣ First Normal Form (1NF)
* **Requirement:** Atomic values (no repeating groups or multi-valued attributes) and unique row keys.
* **Implementation:** Every column contains non-divisible scalar values (e.g., individual `quantity`, single `price`). Primary keys are defined for all entities.

### 2️⃣ Second Normal Form (2NF)
* **Requirement:** Must be in 1NF and have no partial dependencies (all non-key attributes must depend fully on the primary key).
* **Implementation:** Multi-item containers like carts and orders are decoupled into composite structure handling tables (`CART_ITEM` and `ORDER_ITEM`). Attributes like `quantity` and `price` depend on the explicit surrogate keys (`cart_item_id`, `order_item_id`).

### 3️⃣ Third Normal Form (3NF)
* **Requirement:** Must be in 2NF and have no transitive dependencies (non-key attributes depend *only* on the candidate primary key).
* **Implementation:** Payment processing details (`PAYMENT`), user credentials (`USER`), and order records (`ORDERS`) are segregated into dedicated tables linked strictly by Foreign Keys. Modifying user profile attributes does not spill over or affect historic order details.

---

## 🛠 Technologies Used

| Category | Tool / Technology |
| :--- | :--- |
| **Database Engine** | MySQL 8.0+ |
| **Language** | SQL (Structured Query Language - DDL) |
| **Data Modeling** | StarUML (Crow's Foot ER Notation) |
| **Documentation** | Markdown / Shields.io Badges |

---

## 🏁 Conclusion

This database design successfully establishes a robust relational foundation for an e-commerce platform. By modeling core operational entities, enforcing strict primary and foreign key constraints, and applying 3NF normalization guidelines, the system guarantees:

1. **Data Consistency:** Prevents orphaned records via `ON DELETE CASCADE` constraints.
2. **Elimination of Redundancy:** Decouples user data, products, orders, and payment tracking.
3. **Historical Accuracy:** Captures explicit line-item unit pricing (`ORDER_ITEM.price`) independently of future product catalog price adjustments (`PRODUCT.price`).

The structured SQL implementation provides a seamless path for integration into modern web backends (e.g., Node.js, Python/Django, or Java Spring Boot).


---

## 📚 Tasks XI–XV: Advanced DBMS Practice

These folders use the existing `amazon_db` schema described above. Review each README before running its SQL file; run against a test database or backup first, especially for transaction and security tasks.

| Task | Topic | Files |
| --- | --- | --- |
| Task XI | Database Automation using Views and Procedures | [README](Task11/README.md) · [SQL queries](Task11/database_automation.sql) |
| Task XII | Transaction Management System | [README](Task12/README.md) · [SQL queries](Task12/transaction_management.sql) |
| Task XIII | Database Security and Performance Optimization | [README](Task13/README.md) · [SQL queries](Task13/security_performance.sql) |
| Task XIV | Business Intelligence and AI Data Preparation | [README](Task14/README.md) · [SQL queries](Task14/business_intelligence_ai_prep.sql) |
| Task XV | Industry Capstone Project — E-Commerce Intelligence Platform | [README](Task15/README.md) · [Capstone SQL](Task15/capstone_queries.sql) · [ER Diagram](Task15/ER_Diagram.md) |

