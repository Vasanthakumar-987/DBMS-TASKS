# Task XIII — Database Security and Performance Optimization

## Objective
Control access to the existing e-commerce database and improve common query performance.

## Files
- [security_performance.sql](security_performance.sql) — user/role examples, GRANT/REVOKE, indexes, and EXPLAIN.

## Requirements covered
1. Create a read-only reporting user and a role.
2. Apply GRANT and REVOKE permissions.
3. Add indexes to common filter/join columns where appropriate.
4. Use EXPLAIN to inspect query plans.

## Run safely
Use MySQL 8.0+ with an account authorized to manage users and indexes. Replace the example password before running. Execute security statements only in a local/academic database where you have permission. Check existing indexes before adding duplicates.