# 🛒 Customer Retention & Churn Analysis — Olist E-Commerce

> **70% of customers never returned after their first order.**  
> This project finds out why — and what it costs.

---

## 📌 Project Overview

Olist is a Brazilian e-commerce marketplace. This project analyzes customer churn across **94,990 customers** and **556,000+ records** using PostgreSQL and Power BI.

**Tools:** PostgreSQL · Power BI Desktop  
**Dataset:** [Olist Brazilian E-Commerce — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce/data)  

---

## 📂 Project Files

| File | Description |
|------|-------------|
| `01_schema_creation.sql` | Create all 9 tables + indexes |
| `02_data_import.sql` | Import CSV files into PostgreSQL |
| `03_data_cleaning.sql` | Null handling, deduplication, computed columns |
| `04_analytics_queries.sql` | 10 business questions solved as SQL views |
| `Customer_Churn_Dashboard.pbix` | Power BI interactive dashboard |

---

## 🗄️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| olist_customers | 99,441 | Customer details |
| olist_orders | 99,441 | Order lifecycle |
| olist_order_items | 112,650 | Products per order |
| olist_order_payments | 103,886 | Payment details |
| olist_order_reviews | 99,224 | Customer reviews |
| olist_products | 32,951 | Product details |
| olist_sellers | 3,095 | Seller details |
| olist_geolocation | 1,000,163 | Location data |
| product_category_translation | 71 | Portuguese to English |

---

## 🔑 Key Findings

### Churn Rate

| Status | Customers | % of Total |
|--------|-----------|------------|
| Active (last 90 days) | 9,464 | 10.0% |
| At Risk (90–180 days) | 18,238 | 19.2% |
| Churned — Recent (180–365 days) | 39,359 | 41.4% |
| Churned — Long Term (365+ days) | 27,966 | 29.4% |

### Revenue Impact

| Segment | Revenue | % of Total |
|---------|---------|------------|
| Active customers | R$4,701,898 | 29.9% |
| Churned customers | R$11,037,239 | 70.1% |
| **Recovery potential (10%)** | **R$1,103,724** | — |

### Repeat vs One-Time Customers

| Type | Customers | Avg Lifetime Value |
|------|-----------|-------------------|
| One-Time Customer | 92,101 (95.8%) | R$161 |
| Repeat Customer | 2,888 (3.0%) | R$308 |
| **LTV Multiplier** | — | **1.9x** |

### Delivery & Reviews

| Metric | Value |
|--------|-------|
| Late delivery rate | 8.3% |
| Late delivery churn rate | 78.5% |
| On-time delivery churn rate | 70.0% |
| Avg review score | 4.1 / 5 |
| 1-star churn rate | 78.3% |
| 5-star churn rate | 68.6% |

---

## 🧹 Data Cleaning

| Issue Found | Action Taken |
|-------------|-------------|
| Null delivery dates | Flagged — not deleted (expected for non-delivered orders) |
| 3 rows with `not_defined` payment | Deleted |
| 610 products with no category | Filled with `unknown` |
| 2 products with null dimensions | Filled with average value |
| Duplicate reviews | Kept latest, deleted older |
| Inconsistent city names | Standardized to lowercase + trimmed |
| Seller city = zip code (invalid) | Set to NULL |
| Portuguese category names | Added English column via translation join |
| Delivery delay missing | Calculated `delivery_delay_days` and `is_late_delivery` |

---

## 📊 10 Business Questions Answered

| # | Business Question | SQL View |
|---|-------------------|----------|
| Q1 | How many customers stopped buying? | `v_churn_rate` |
| Q2 | Who are the churned customers and when did they stop? | `v_customer_churn_status` |
| Q3 | How many customers placed a second order? | `v_repeat_purchase` |
| Q4 | How much more do repeat customers spend? | `v_customer_value_comparison` |
| Q5 | Which states have the highest churn rate? | `v_churn_by_state` |
| Q6 | How much revenue was lost to churn? | `v_revenue_churn` |
| Q7 | Do low-rating customers churn more? | `v_review_vs_churn` |
| Q8 | Do late delivery customers churn more? | `v_delivery_vs_churn` |
| Q9 | How many new customers joined each month? | `v_monthly_new_customers` |
| Q10 | What do loyal customers buy most? | `v_repeat_customer_categories` |

---

## 📈 Power BI Dashboard

**4 pages — all built from PostgreSQL views**

**Page 1 — Overview**
- KPIs: Total Customers · Churn Rate · Active Customers · Revenue Lost
- Customer Status Donut · Revenue Split Donut
- Monthly New Customers Trend (Jan 2017 – Aug 2018)

**Page 2 — Churn Analysis**
- KPIs: Active · At Risk · Churned Recent · Churned Long Term
- Churn Status Breakdown Donut
- Top 10 States by Churn Rate

**Page 3 — Retention Analysis**
- KPIs: Repeat Rate · One-Time LTV · Repeat LTV · LTV Multiplier
- One-Time vs Repeat Customers
- Average Lifetime Value Comparison
- Top Categories Bought by Repeat Customers

**Page 4 — Delivery & Reviews**
- KPIs: Late Delivery Rate · Avg Delivery Days · Avg Review Score · 1-Star Reviews
- Delivery Status vs Churn Rate
- Review Score vs Churn Rate
- Total Revenue Lost · Recovery Potential

---

## 💡 Business Recommendations

**1. Launch Post-Purchase Email Campaign**  
Send a follow-up email within 30 days of first order. Target top repeat categories: Bed Bath Table, Sports Leisure, Furniture.

**2. Win-Back Campaign for At-Risk Customers**  
18,238 customers are At Risk right now. A 10–15% discount coupon can bring them back before they churn permanently.

**3. Enforce Seller Delivery SLA**  
Late delivery customers churn 8.5% more than on-time customers. Penalize sellers with late delivery rates above 10%.

**4. Proactive Support for Low-Review Customers**  
1-star reviewers have 78.3% churn rate. Respond to unhappy customers within 24 hours with resolution or refund.

**5. Introduce a Loyalty Program**  
No loyalty program exists currently. Repeat customers spend 1.9x more. Even a basic points system can significantly improve the 3% repeat rate.

---


---

## 🛠️ SQL Concepts Used

| Category | Functions |
|----------|-----------|
| DDL | `CREATE TABLE` `CREATE VIEW` `CREATE INDEX` `ALTER TABLE` `DROP TABLE` |
| DML | `COPY` `UPDATE` `DELETE` `PRIMARY KEY` `FOREIGN KEY` |
| Aggregates | `COUNT` `SUM` `AVG` `MIN` `MAX` `ROUND` |
| Conditional | `CASE WHEN` `COALESCE` `NULLIF` |
| Joins | `INNER JOIN` `LEFT JOIN` `UNION ALL` |
| Subqueries | Subquery in FROM · Subquery in UPDATE · `HAVING` |
| Date | `EXTRACT` `DATE_TRUNC` Date subtraction |
| Advanced | `ROW_NUMBER() OVER (PARTITION BY)` |

---
