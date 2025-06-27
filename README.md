# Online Marketplace Data Warehouse Management & Business Analytics

## Overview
This project designs and implements an analytic data warehouse for an online shopping marketplace. The system focuses on tracking vendor performance, product engagement, and financial metrics to support data-driven decision-making. The database is normalized to 3NF, with SQL queries and stored procedures enabling efficient data analysis.

## Introduction
The analytic data warehouse is designed to maintain efficient business metric tracking and analysis capabilities for an online shopping marketplace. Key objectives include:
- Evaluating vendor performance.
- Tracking product customer engagement through reviews.
- Analyzing expenses related to delivery issues and returns.
- Supporting accurate decision-making through a normalized database structure.

The system links entities such as Vendors, Products, Shoppers, Orders, and Revenue, utilizing SQL queries and stored procedures for data insertion and report generation.

---

## Analytic Data Warehouse Design

### Key Objectives
1. **Vendor Performance Analysis**: Track total sales and monthly revenue trends to identify high-performing vendors and areas for improvement.
2. **Product Engagement**: Analyze customer reviews and time spent on product pages to improve product offerings.
3. **Financial Tracking**: Assess costs from failed deliveries and returns to optimize logistics and minimize losses.

### Entity-Relationship (ER) Diagram
The conceptual ER diagram defines relationships between core entities:
- **Vendors** supply **Products** (many-to-one relationship).
- **Shoppers** place **Orders**, which contain **OrderDetails** (one-to-many relationship).
- **Products** have **ShopperExperience** reviews (one-to-many relationship).
- **Costs** and **Revenue** tables track financial metrics linked to orders and vendors.

### Database Implementation
The physical ER diagram maps entities to tables with constraints (primary keys, foreign keys, NOT NULL, CHECK). Key tables include:
- `Vendors`: Stores vendor details.
- `Products`: Links to vendors and includes product information.
- `Shoppers`: Tracks shopper data and membership status.
- `Orders` and `OrderDetails`: Record order transactions.
- `ShopperExperience`: Captures product reviews and time spent.
- `Costs` and `Revenue`: Track financial metrics.

### Design Choices
- Normalized to 3NF to minimize redundancy.
- Foreign keys ensure referential integrity.
- Constraints enforce data validity (e.g., `Quantity > 0`).
- Triggers maintain data integrity (e.g., valid reviews).

---

## Data Analysis with SQL

### Data Insertion
Randomized data was inserted into tables for testing:
- **Vendors**: 50 entries with random names and commission rates.
- **Products**: 1,000 entries linked to random vendors.
- **Shoppers**: 1,000 entries with random membership status.
- **Orders**: 10,000 entries with random statuses and dates.
- **OrderDetails**: 20,000 entries with random quantities.
- **ShopperExperience**: 1,000 entries with random reviews and time spent.
- **Costs**: 500 entries with random delivery and return costs.

### Key Queries
1. **Total Sales by Vendor**: Aggregates sales data by vendor and month.
2. **Top Products by Shopper Feedback**: Ranks products by review count and average time spent.
3. **Costs from Failed Deliveries and Returns**: Calculates total costs for incomplete orders.

### Stored Procedures
- `monthly_report`: Generates revenue and cost reports for a specified month.

---

## Theoretical Discussion

### ACID Properties in RDBMS
1. **Atomicity**: Ensures all operations in a transaction complete successfully or none at all (e.g., order placement).
2. **Consistency**: Guarantees valid database state transitions (e.g., stock constraints).
3. **Isolation**: Prevents interference between concurrent transactions (e.g., simultaneous orders).
4. **Durability**: Ensures committed transactions persist despite system failures.

### CAP Theorem
- **Consistency**: All nodes reflect the latest data (e.g., stock updates).
- **Availability**: System responds to requests even during failures.
- **Partition Tolerance**: System operates despite network partitions.

### Case Study: Amazon
Amazon's data warehouse integrates multiple data sources for personalized recommendations and secure access management.

---

## Concluding Remarks
The analytic data warehouse successfully tracks business metrics, vendor performance, and product engagement.
