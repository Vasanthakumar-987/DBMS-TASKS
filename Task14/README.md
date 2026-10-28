# Task XIV — Business Intelligence and AI Data Preparation

## Objective
Use SQL analytics and window functions to prepare structured customer/product features for downstream analysis or AI model training.

## Files
- [business_intelligence_ai_prep.sql](business_intelligence_ai_prep.sql) — ranking, segmentation, and feature extraction queries.

## Requirements covered
- Sales and customer analytical reports.
- RANK() and ROW_NUMBER() window functions.
- Customer segmentation based on order count and total order value.
- Feature table/query with customer-level numeric features.
- Product sales features for a possible recommendation or demand model.

## Run
Run in MySQL 8.0+ against the existing `amazon_db`. Queries read existing data and do not train or deploy an AI model. Export a result grid to CSV if you need a model-ready dataset.