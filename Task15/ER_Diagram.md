# E-Commerce Intelligence Platform — ER Diagram

The diagram below represents the core entities used in the existing `amazon_db` schema.

```mermaid
erDiagram
    USER ||--o{ ORDERS : places
    ORDERS ||--o{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : appears_in
    ORDERS ||--o{ PAYMENT : has

    USER {
        int user_id PK
        varchar name
        varchar email
    }
    PRODUCT {
        int product_id PK
        varchar title
        decimal price
        int stock
    }
    ORDERS {
        int order_id PK
        int user_id FK
        date order_date
        decimal total_amount
    }
    ORDER_ITEM {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal price
    }
    PAYMENT {
        int payment_id PK
        int order_id FK
        varchar payment_method
        varchar status
    }
```

## Relationships
- One user can place many orders.
- One order can contain multiple order items.
- One product can appear in multiple order items.
- An order can have payment records associated with it.

## Notes
- This is a logical ER diagram for the core tables. Confirm the actual columns and constraints in your local MySQL schema before final submission.
- The main repository schema also documents CART, CART_ITEM, and REVIEW. Add those entities if they exist in the database version used for the capstone.
