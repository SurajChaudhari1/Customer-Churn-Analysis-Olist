-- ============================================================
--  OLIST E-COMMERCE  |  CUSTOMER CHURN ANALYSIS
-- ============================================================
					--Schema & Table Creation
CREATE SCHEMA IF NOT EXISTS olist;

SET search_path TO olist;

-- TABLE 1: CUSTOMERS
CREATE TABLE olist.customers (
    customer_id VARCHAR(50)  PRIMARY KEY,
    customer_unique_id VARCHAR(50)  NOT NULL,
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- TABLE 2: ORDERS
CREATE TABLE olist.orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) REFERENCES olist.customers(customer_id),
    order_status VARCHAR(20) NOT NULL,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);
 
-- TABLE 3: ORDER ITEMS
CREATE TABLE olist.order_items (
    order_id ARCHAR(50),
    order_item_id MALLINT,
    product_idVARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);
 
 -- TABLE 4: ORDER PAYMENTS
CREATE TABLE olist.order_payments (
    order_id VARCHAR(50),
    payment_sequential SMALLINT,
    payment_type VARCHAR(30),
    payment_installments SMALLINT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);
 
-- TABLE 5: ORDER REVIEWS
CREATE TABLE olist.order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score SMALLINT  CHECK (review_score BETWEEN 1 AND 5),
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    PRIMARY KEY (review_id, order_id)
 
-- TABLE 6: PRODUCTS
CREATE TABLE olist.products (
    product_id VARCHAR(50)  PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght SMALLINT,
    product_description_lenght INTEGER,
    product_photos_qty SMALLINT,
    product_weight_g NUMERIC(10,2),
    product_length_cm NUMERIC(10,2),
    product_height_cm NUMERIC(10,2),
    product_width_cm NUMERIC(10,2)
);

-- TABLE 7: SELLERS
CREATE TABLE olist.sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);
 
-- TABLE 8: GEOLOCATION
CREATE TABLE olist.geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat NUMERIC(15,8),
    geolocation_lng NUMERIC(15,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);
 
-- TABLE 9: PRODUCT CATEGORY TRANSLATION
CREATE TABLE olist.translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

							--Data Import
-- Data Import 1: CUSTOMERS
COPY 
olist.customers (
    customer_id, customer_unique_id,
    customer_zip_code_prefix, customer_city, customer_state)
FROM 'D:/Portfolio Projects/SQL + Power BI/Brazilian E-Commerce Public Dataset by Olist/Data/olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Data Import 2: Products
COPY 
olist.products (
	product_id, product_category_name, product_name_lenght, product_description_lenght, 
	product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
FROM 'D:/Portfolio Projects/SQL + Power BI/Brazilian E-Commerce Public Dataset by Olist/Data/olist_products_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Data Import 3: Sellers
COPY 
	olist.sellers (seller_id, seller_zip_code_prefix, seller_city,seller_state)
FROM 'D:/Portfolio Projects/SQL + Power BI/Brazilian E-Commerce Public Dataset by Olist/Data/olist_sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Data Import 4: Geolocation
COPY 
	olist.geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, 
	geolocation_state)
COPY  'D:\Portfolio Projects\SQL + Power BI\Brazilian E-Commerce Public Dataset by Olist\Data\olist_geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Data Import 5: Translation
COPY 
	olist.translation (product_category_name, product_category_name_english)
FROM 'D:\Portfolio Projects\SQL + Power BI\Brazilian E-Commerce Public Dataset by Olist\Data\product_category_name_translation.csv'
DELIMITER ','
CSV HEADER;

 -- Data Import 6: Orders
 COPY 
	olist.orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, 
	order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
FROM 'D:\Portfolio Projects\SQL + Power BI\Brazilian E-Commerce Public Dataset by Olist\Data\olist_orders_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Data Import 7: Order Items
COPY 
	olist.order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_date, 
	price, freight_value)
FROM 'D:\Portfolio Projects\SQL + Power BI\Brazilian E-Commerce Public Dataset by Olist\Data\olist_order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Data Import 8: Order Payments
COPY 
	olist.order_payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
FROM 'D:\Portfolio Projects\SQL + Power BI\Brazilian E-Commerce Public Dataset by Olist\Data\olist_order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Data Import 9: Order Reviews
COPY 
	olist.order_reviews (review_id, order_id, review_score, review_comment_title, 
	review_comment_message, review_creation_date, review_answer_timestamp)
FROM 'D:\Portfolio Projects\SQL + Power BI\Brazilian E-Commerce Public Dataset by Olist\Data\olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

						-- INDEXES for faster JOINs 

CREATE INDEX IF NOT EXISTS idx_orders_customer_id    
ON olist.orders(customer_id);

CREATE INDEX IF NOT EXISTS idx_orders_status        
ON olist.orders(order_status);

CREATE INDEX IF NOT EXISTS idx_orders_purchase_date 
ON olist.orders(order_purchase_timestamp);

CREATE INDEX IF NOT EXISTS idx_items_order_id        
ON olist.order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_items_product_id      
ON olist.order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_items_seller_id      
ON olist.order_items(seller_id);

CREATE INDEX IF NOT EXISTS idx_payments_order_id    
ON olist.order_payments(order_id);

CREATE INDEX IF NOT EXISTS idx_reviews_order_id     
ON olist.order_reviews(order_id);

CREATE INDEX IF NOT EXISTS idx_customers_unique_id  
ON olist.customers(customer_unique_id);

-- VERIFY
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'olist'
ORDER BY table_name;

-- Verify Row Counts

SELECT 'customers' AS table_name, COUNT(*) AS row_count 
FROM olist.customers
UNION ALL
SELECT 'orders', COUNT(*) 
FROM olist.orders
UNION ALL
SELECT 'order_items', COUNT(*)
FROM olist.order_items
UNION ALL
SELECT 'order_payments', COUNT(*) 
FROM olist.order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) 
FROM olist.order_reviews
UNION ALL
SELECT 'products', COUNT(*) 
FROM olist.products
UNION ALL
SELECT 'sellers', COUNT(*) 
FROM olist.sellers
UNION ALL
SELECT 'geolocation', COUNT(*) 
FROM olist.geolocation
UNION ALL
SELECT 'translation', COUNT(*) 
FROM olist.translation
ORDER BY table_name;

						--Data Cleaning
SET search_path TO olist;

						--  Check null values 
--Customers
SELECT
    'customers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_id) AS null_customer_id,
    COUNT(*) - COUNT(customer_unique_id) AS null_unique_id,
    COUNT(*) - COUNT(customer_zip_code_prefix) AS null_zip,
    COUNT(*) - COUNT(customer_city) AS null_city,
    COUNT(*) - COUNT(customer_state) AS null_state
FROM olist.customers;

--Orders
SELECT
    'orders' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS null_order_id,
    COUNT(*) - COUNT(customer_id) AS null_customer_id,
    COUNT(*) - COUNT(order_status) AS null_status,
    COUNT(*) - COUNT(order_purchase_timestamp) AS null_purchase_date,
    COUNT(*) - COUNT(order_approved_at) AS null_approved,
    COUNT(*) - COUNT(order_delivered_carrier_date) AS null_carrier_date,
    COUNT(*) - COUNT(order_delivered_customer_date) AS null_delivery_date,
    COUNT(*) - COUNT(order_estimated_delivery_date) AS null_estimated_date
FROM olist.orders;

--Order Items
SELECT
    'order_items' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS null_order_id,
    COUNT(*) - COUNT(product_id) AS null_product_id,
    COUNT(*) - COUNT(seller_id) AS null_seller_id,
    COUNT(*) - COUNT(price) AS null_price,
    COUNT(*) - COUNT(freight_value) AS null_freight
FROM olist.order_items;

--Order Payments
SELECT
    'order_payments' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS null_order_id,
    COUNT(*) - COUNT(payment_type) AS null_payment_type,
    COUNT(*) - COUNT(payment_installments) AS null_installments,
    COUNT(*) - COUNT(payment_value) AS null_payment_value
FROM olist.order_payments;

--Order Reviews
SELECT
    'order_reviews' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(review_id) AS null_review_id,
    COUNT(*) - COUNT(order_id) AS null_order_id,
    COUNT(*) - COUNT(review_score) AS null_score,
    COUNT(*) - COUNT(review_comment_title) AS null_title,
    COUNT(*) - COUNT(review_comment_message) AS null_message
FROM olist.order_reviews;

--Products
SELECT
    'products' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(product_id) AS null_product_id,
    COUNT(*) - COUNT(product_category_name) AS null_category,
    COUNT(*) - COUNT(product_weight_g) AS null_weight,
    COUNT(*) - COUNT(product_length_cm) AS null_length,
    COUNT(*) - COUNT(product_height_cm) AS null_height,
    COUNT(*) - COUNT(product_width_cm) AS null_width
FROM olist.products;

--Sellers
SELECT
    'sellers' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(seller_id) AS null_seller_id,
    COUNT(*) - COUNT(seller_zip_code_prefix) AS null_zip,
    COUNT(*) - COUNT(seller_city) AS null_city,
    COUNT(*) - COUNT(seller_state) AS null_state
FROM olist.sellers;

--Geolocation
SELECT
    'geolocation' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(geolocation_zip_code_prefix) AS null_zip,
    COUNT(*) - COUNT(geolocation_lat) AS null_lat,
    COUNT(*) - COUNT(geolocation_lng) AS null_lng,
    COUNT(*) - COUNT(geolocation_city) AS null_city,
    COUNT(*) - COUNT(geolocation_state) AS null_state
FROM olist.geolocation;

--Product Category Translation
SELECT
    'translation' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(product_category_name) AS null_portuguese,
    COUNT(*) - COUNT(product_category_name_english) AS null_english
FROM olist.translation;

--Geolocation
SELECT
    'geolocation' AS table_name,
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(geolocation_zip_code_prefix) AS null_zip,
    COUNT(*) - COUNT(geolocation_lat) AS null_lat,
    COUNT(*) - COUNT(geolocation_lng) AS null_lng,
    COUNT(*) - COUNT(geolocation_city) AS null_city,
    COUNT(*) - COUNT(geolocation_state) AS null_state
FROM olist.geolocation;

									-- DUPLICATE CHECK

--Orders
SELECT COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_orders
FROM olist.orders;

--Customers
SELECT COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_customers
FROM olist.customers;

--Order Reviews
SELECT review_id, COUNT(*) AS total
FROM olist.order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
LIMIT 10;

--Products
SELECT COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_products
FROM olist.products;

--Sellers
SELECT COUNT(*) - COUNT(DISTINCT seller_id) AS duplicate_sellers
FROM olist.sellers;

							--DATA CLEANING - ORDERS TABLE
--Why are there nulls in orders?
-- Check which order statuses have null delivery dates
 SELECT
order_status,
COUNT(*) AS total_orders
FROM olist.orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY total_orders DESC;

--Add column to mark valid delivered orders
ALTER TABLE olist.orders
ADD COLUMN IF NOT EXISTS is_valid_delivered BOOLEAN DEFAULT FALSE;

UPDATE olist.orders
SET is_valid_delivered = TRUE
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL
AND order_purchase_timestamp IS NOT NULL;

-- Verify
SELECT is_valid_delivered, COUNT(*) AS total
FROM olist.orders
GROUP BY is_valid_delivered;

							--DATA CLEANING - PAYMENTS TABLE
--Check payment type values
SELECT payment_type, COUNT(*) AS total
FROM olist.order_payments
GROUP BY payment_type
ORDER BY total DESC;

--Delete rows 'not_defined' payment type
DELETE FROM olist.order_payments
WHERE payment_type = 'not_defined';

-- Verify
SELECT payment_type, COUNT(*) AS total
FROM olist.order_payments
GROUP BY payment_type
ORDER BY total DESC;

							--DATA CLEANING - PRODUCTS TABLE
--Fill null category with 'unknown'
UPDATE olist.products
SET product_category_name = 'unknown'
WHERE product_category_name IS NULL;

--Fill null dimensions with average value
UPDATE olist.products
SET
product_weight_g  = (SELECT ROUND(AVG(product_weight_g))
FROM olist.products
WHERE product_weight_g IS NOT NULL),
product_length_cm = (SELECT ROUND(AVG(product_length_cm))
FROM olist.products
WHERE product_length_cm IS NOT NULL),
product_height_cm = (SELECT ROUND(AVG(product_height_cm))
FROM olist.products
WHERE product_height_cm IS NOT NULL),
product_width_cm  = (SELECT ROUND(AVG(product_width_cm))
FROM olist.products
WHERE product_width_cm IS NOT NULL)
WHERE product_weight_g IS NULL
OR product_length_cm IS NULL;

-- Verify no nulls remain
SELECT
COUNT(*) - COUNT(product_category_name) AS null_category,
COUNT(*) - COUNT(product_weight_g) AS null_weight,
COUNT(*) - COUNT(product_length_cm) AS null_length
FROM olist.products;

								--DATA CLEANING - REVIEWS TABLE
--Fill null comments
UPDATE olist.order_reviews
SET
review_comment_title = COALESCE(review_comment_title, ''),
review_comment_message = COALESCE(review_comment_message, '');

--Remove duplicate reviews
DELETE FROM olist.order_reviews
WHERE (review_id, order_id) IN (
SELECT review_id, order_id
FROM (
SELECT
review_id,
order_id,
ROW_NUMBER() OVER (
PARTITION BY review_id
ORDER BY review_answer_timestamp DESC
) AS rn
) AS ranked
WHERE rn > 1
);

-- Verify no duplicates remain
SELECT COUNT(*) - COUNT(DISTINCT review_id) AS duplicate_reviews
FROM olist.order_reviews;

					--DATA CLEANING - CUSTOMERS TABLE
--Standardize city names, Remove extra spaces and convert to lowercase
UPDATE olist.customers
SET customer_city = TRIM(LOWER(customer_city));

-- Verify
SELECT DISTINCT customer_city
FROM olist.customers
ORDER BY customer_city
LIMIT 10;

							--DATA CLEANING - SELLERS TABLE 
--Standardize seller city names same as customers
UPDATE olist.sellers
SET seller_city = TRIM(LOWER(seller_city));

--Check Invalid City Names
SELECT seller_city, COUNT(*) AS total
FROM olist.sellers
WHERE seller_city ~ '^[0-9]+$'
GROUP BY seller_city
ORDER BY total DESC;

--Fix Invalid City Names
UPDATE olist.sellers
SET seller_city = NULL
WHERE seller_city ~ '^[0-9]+$';

--Standardize City Names
UPDATE olist.sellers
SET seller_city = TRIM(LOWER(seller_city));
--Verify
SELECT DISTINCT seller_city
FROM olist.sellers
ORDER BY seller_city
LIMIT 10;

--Fix Invalid City Names
UPDATE olist.sellers
SET seller_city = NULL
WHERE seller_city ~ '^[0-9]+$';

select product_category_english  from olist.products
group by product_category_english;

					--ADD ENGLISH CATEGORY TO PRODUCTS
--Add new column for English category name
ALTER TABLE olist.products
ADD COLUMN IF NOT EXISTS product_category_english VARCHAR(100);

--Fill English category from translation table
UPDATE olist.products p
SET product_category_english = t.product_category_name_english
FROM olist.translation t
WHERE p.product_category_name = t.product_category_name;

--Products with 'unknown' category - keep as 'unknown'
UPDATE olist.products
SET product_category_english = 'unknown'
WHERE product_category_english IS NULL;

-- Verify
SELECT
product_category_english,
COUNT(*) AS total_products
FROM olist.products
GROUP BY product_category_english
ORDER BY total_products DESC
LIMIT 10;

							--ADD DELIVERY COLUMNS TO ORDERS
--Add new columns for delivery analysis
ALTER TABLE olist.orders
ADD COLUMN IF NOT EXISTS delivery_delay_days NUMERIC(6,1),
ADD COLUMN IF NOT EXISTS delivery_time_days NUMERIC(6,1),
ADD COLUMN IF NOT EXISTS is_late_delivery BOOLEAN DEFAULT FALSE;

-- J2. Calculate delivery delay
-- Positive = late delivery, Negative = early delivery
UPDATE olist.orders
SET
delivery_delay_days = EXTRACT(DAY FROM (
order_delivered_customer_date - order_estimated_delivery_date),
delivery_time_days = EXTRACT(DAY FROM (
order_delivered_customer_date - order_purchase_timestamp)),
is_late_delivery = CASE
WHEN order_delivered_customer_date > order_estimated_delivery_date
THEN TRUE
ELSE FALSE
END
WHERE is_valid_delivered = TRUE;

 -- Verify delivery stats
SELECT
ROUND(AVG(delivery_delay_days), 1) AS avg_delay_days,
ROUND(AVG(delivery_time_days), 1) AS avg_delivery_days,
COUNT(CASE WHEN is_late_delivery = TRUE THEN 1 END) AS late_orders,
COUNT(*) AS total_delivered
FROM olist.orders
WHERE is_valid_delivered = TRUE;

-- Verify delivery stats
SELECT
ROUND(AVG(delivery_delay_days), 1) AS avg_delay_days,
ROUND(AVG(delivery_time_days), 1) AS avg_delivery_days,
COUNT(CASE WHEN is_late_delivery = TRUE THEN 1 END) AS late_orders,
COUNT(*) AS total_delivered
FROM olist.orders
WHERE is_valid_delivered = TRUE;

-- Final row count of all tables after cleaning
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM olist.customers
UNION ALL
SELECT 'orders', COUNT(*) FROM olist.orders
UNION ALL
SELECT 'orders (valid delivered)', COUNT(*) FROM olist.orders    
WHERE is_valid_delivered = TRUE
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist.order_items
UNION ALL
SELECT 'order_payments (cleaned)', COUNT(*) FROM olist.order_payments
UNION ALL
SELECT 'order_reviews (cleaned)', COUNT(*) FROM olist.order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM olist.products
UNION ALL
SELECT 'products (with english category)', COUNT(*) FROM olist.products 
WHERE product_category_english IS NOT NULL
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist.sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM olist.geolocation
UNION ALL
SELECT 'translation', COUNT(*) FROM olist.translation
ORDER BY table_name;

							--  Step 4: Analytics Queries (Focus: Customer Churn & Retention)

SET search_path TO olist;

-- ============================================================
-- QUERY 1: OVERALL CHURN RATE
-- Business Question: How many customers stopped buying from Olist?
-- Churn Definition: Customer who has not ordered in last 180 days
 
CREATE OR REPLACE VIEW olist.v_churn_rate AS
SELECT
churn_status,
COUNT(*) AS total_customers,
ROUND(COUNT(*)::NUMERIC / 96096 * 100, 1) AS percentage
FROM (
SELECT
c.customer_unique_id,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE > 180
THEN 'Churned'
ELSE 'Active'
END AS churn_status
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id) AS churn_summary
GROUP BY churn_status;
--Verify
SELECT * FROM olist.v_churn_rate;

-- Business Impact:
-- 7 out of 10 customers never came back after their first order.
-- With a 70% churn rate across 94,990 customers, Olist has no retention strategy in place.
-- Fixing this can directly increase revenue without spending more on acquiring new customers.

-- ============================================================
-- QUERY 2: CHURNED VS ACTIVE CUSTOMERS DETAIL
-- Business Question: Who are the churned customers
-- and how long ago did they stop buying?
 
CREATE OR REPLACE VIEW olist.v_customer_churn_status AS
SELECT
c.customer_unique_id,
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(p.payment_value)::NUMERIC, 2) AS total_spend,
MAX(o.order_purchase_timestamp)::DATE AS last_order_date,
DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE AS recency_days,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE <= 90
THEN 'Active'
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE <= 180
THEN 'At Risk'
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE <= 365
THEN 'Churned - Recent'
ELSE 'Churned - Long Term'
END AS churn_status
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
JOIN olist.order_payments p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id, c.customer_state;

--Verify
SELECT
churn_status,
COUNT(*) AS total_customers,
ROUND(AVG(total_spend)::NUMERIC, 2) AS avg_spend,
ROUND(AVG(recency_days)::NUMERIC, 0) AS avg_days_since_last_order
FROM olist.v_customer_churn_status
GROUP BY churn_status
ORDER BY total_customers DESC;

-- Business Impact:
-- 39,359 customers churned in the last 6-12 months (Churned - Recent).
-- 27,966 customers have been gone for over a year (Churned - Long Term).
-- 'At Risk' segment of 18,238 customers is the most valuable group to target —
-- they are still reachable with a discount or reminder.
-- Average spend is similar across all groups (~R$162-172),
-- meaning no segment is low value — all are worth recovering.
-- 'Churned - Long Term' customers need a strong win-back
-- campaign like a special offer or re-engagement email.

-- ============================================================
-- QUERY 3: REPEAT PURCHASE RATE
-- Business Question: How many customers came back to place a second order?
 
CREATE OR REPLACE VIEW olist.v_repeat_purchase AS
SELECT
customer_type,
COUNT(*)  AS total_customers,
ROUND(COUNT(*)::NUMERIC / 96096 * 100, 1) AS percentage,
ROUND(AVG(total_spend)::NUMERIC, 2) AS avg_spend
FROM (
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS total_spend,
CASE
WHEN COUNT(DISTINCT o.order_id) > 1
THEN 'Repeat Customer'
ELSE 'One-Time Customer'
END AS customer_type
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
JOIN olist.order_payments p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id) AS summary
GROUP BY customer_type;
 
--Verify
SELECT * FROM olist.v_repeat_purchase;

-- Business Impact:
-- Only 3 out of 100 customers placed a second order (3.0%).
-- 92,101 customers bought once and never returned.
-- Only 2,888 customers came back for a repeat purchase.
-- A loyalty program or post-purchase follow-up email
-- can significantly improve this number.

-- ============================================================
-- QUERY 4: ONE TIME VS REPEAT CUSTOMER VALUE COMPARISON
-- Business Question: How much more do repeat customers
-- spend compared to one-time customers?

CREATE OR REPLACE VIEW olist.v_customer_value_comparison AS
SELECT
customer_type,
COUNT(*) AS total_customers,
ROUND(AVG(total_orders)::NUMERIC, 1) AS avg_orders,
ROUND(AVG(total_spend)::NUMERIC, 2) AS avg_lifetime_value
FROM (
SELECT
c.customer_unique_id,
COUNT(DISTINCT o.order_id) AS total_orders,
SUM(p.payment_value) AS total_spend,
CASE
WHEN COUNT(DISTINCT o.order_id) > 1
THEN 'Repeat Customer'
ELSE 'One-Time Customer'
END AS customer_type
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
JOIN olist.order_payments p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id) AS summary
GROUP BY customer_type;
 
--Verify
SELECT * FROM olist.v_customer_value_comparison;

-- Business Impact:
-- A repeat customer spends 1.9x more than a one-time customer.
-- Repeat Avg LTV = R$308.36 vs One-Time Avg LTV = R$161.22.
-- Repeat customers place 2.1 orders on average vs 1.0 for one-time buyers.
-- Investing in retention is more profitable than spending on acquiring new customers.

-- ============================================================
-- QUERY 5: CHURN RATE BY STATE
-- Business Question: Which states have the highest customer churn rate?
 
CREATE OR REPLACE VIEW olist.v_churn_by_state AS
SELECT
customer_state,
COUNT(*) AS total_customers,
SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
ROUND(
SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END)::NUMERIC
/ COUNT(*) * 100, 1) AS churn_rate_pct
FROM (
SELECT
c.customer_unique_id,
c.customer_state,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE > 180
THEN 1
ELSE 0
END AS is_churned
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id, c.customer_state
) AS customer_churn
GROUP BY customer_state
ORDER BY churn_rate_pct DESC;
 
--Verify
SELECT * FROM olist.v_churn_by_state;

-- Business Impact:
-- AC state has the highest churn at 81.8%, followed by AL (77.7%) and PA (77.2%).
-- Northern and remote states dominate the top churn list.
-- The main reason is longer delivery times and higher
-- freight costs in these regions.
-- SP has the most customers but a lower churn rate, showing that better logistics = better retention.
-- Adding more regional sellers or improving logistics in high-churn states can reduce churn significantly.

-- ============================================================
-- QUERY 6: REVENUE LOST DUE TO CHURN
-- Business Question: How much revenue was lost because customers did not come back?
 
CREATE OR REPLACE VIEW olist.v_revenue_churn AS
SELECT
customer_status,
COUNT(DISTINCT customer_unique_id) AS total_customers,
ROUND(SUM(total_spend)::NUMERIC, 2) AS total_revenue,
ROUND(AVG(total_spend)::NUMERIC, 2) AS avg_order_value
FROM (
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS total_spend,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE > 180
THEN 'Churned'
ELSE 'Active'
END AS customer_status
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
JOIN olist.order_payments p ON o.order_id = p.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id
) AS customer_summary
GROUP BY customer_status;

--Verify
SELECT * FROM olist.v_revenue_churn;

-- Business Impact:
-- Churned customers generated R$11,037,238 but never returned.
-- This is 70% of total revenue that walked away permanently.
-- Active customers generated only R$4,701,898 (30% of total revenue).
-- If even 10% of churned customers were retained, that would mean R$1,103,724 in additional revenue
-- with zero new customer acquisition cost.

-- ============================================================
-- QUERY 7: REVIEW SCORE VS CHURN
-- Business Question: Do customers who gave a low rating
-- churn more than customers who gave a high rating?
 
CREATE OR REPLACE VIEW olist.v_review_vs_churn AS
SELECT
review_score,
COUNT(DISTINCT customer_unique_id) AS total_customers,
SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(
SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END)::NUMERIC
/ COUNT(DISTINCT customer_unique_id) * 100, 1) AS churn_rate_pct
FROM (SELECT
c.customer_unique_id,
r.review_score,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE > 180
THEN 1
ELSE 0
END AS is_churned
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
JOIN olist.order_reviews r ON o.order_id = r.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
AND r.review_score > 0
GROUP BY c.customer_unique_id, r.review_score) AS review_churn
GROUP BY review_score
ORDER BY review_score;

--Verify
SELECT * FROM olist.v_review_vs_churn;
-- Business Impact:
-- 1-star reviewers have a 78.3% churn rate — the highest of any group.
-- Even 5-star reviewers churn at 68.6%, showing a platform-wide problem.
-- Every 1-point drop in review score increases churn by ~3%.
-- A 1-star review is an early warning sign of churn.
-- If Olist resolves issues for low-rating customers quickly,
-- many of them can be saved before they churn permanently.

-- ============================================================
-- QUERY 8: LATE DELIVERY IMPACT ON CHURN
-- Business Question: Do customers who received a late delivery
-- churn more than customers who got on-time delivery?
 
CREATE OR REPLACE VIEW olist.v_delivery_vs_churn AS
SELECT
delivery_status,
COUNT(DISTINCT customer_unique_id) AS total_customers,
SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
ROUND(
SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END)::NUMERIC
/ COUNT(DISTINCT customer_unique_id) * 100, 1) AS churn_rate_pct,
ROUND(AVG(avg_review_score)::NUMERIC, 2)        AS avg_review_score
FROM (
SELECT
c.customer_unique_id,
CASE
WHEN o.is_late_delivery = TRUE
THEN 'Late Delivery'
ELSE 'On Time Delivery'
END AS delivery_status,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE > 180
THEN 1
ELSE 0
END AS is_churned,
AVG(r.review_score) AS avg_review_score
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
LEFT JOIN olist.order_reviews r ON o.order_id = r.order_id
WHERE o.is_valid_delivered = TRUE
GROUP BY c.customer_unique_id, o.is_late_delivery
) AS delivery_churn
GROUP BY delivery_status;
 
--Verify
SELECT * FROM olist.v_delivery_vs_churn;
-- Expected:
--   Late Delivery  = higher churn rate + lower review score
--   On Time        = lower churn rate  + higher review score
--
-- Business Impact:
-- Late delivery customers churn at 78.5% vs 70.0% for on-time delivery.
-- That is an 8.5 percentage point higher churn rate from late delivery alone.
-- Late delivery also drives lower review scores: 2.57 vs 4.29 for on-time.
-- Only 7,771 orders were late (8.3% of total) but they cause
-- disproportionate damage to retention and brand reputation.
-- Improving delivery speed is one of the fastest ways to reduce churn.

 -- ============================================================
-- QUERY 9: MONTHLY NEW CUSTOMERS TREND
-- Business Question: How many new customers joined Olist every month? Is the business growing?
 
CREATE OR REPLACE VIEW olist.v_monthly_new_customers AS
SELECT
DATE_TRUNC('month', first_order_date)::DATE AS order_month,
COUNT(*) AS new_customers
FROM (SELECT
c.customer_unique_id,
MIN(o.order_purchase_timestamp)::DATE AS first_order_date
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id
) AS first_orders
WHERE first_order_date >= '2017-01-01'
GROUP BY order_month
ORDER BY order_month;
 
--Verify
SELECT * FROM olist.v_monthly_new_customers;
-- Business Impact:
-- New customer acquisition grew ~9.6x from Jan 2017 (752) to Nov 2017 (7,190).
-- November 2017 Black Friday peak brought 7,190 new customers in one month.
-- Growth stabilized at ~6,000-7,000 new customers per month through 2018.
-- But high acquisition with low retention (3% repeat rate) means
-- the business keeps spending on new customers while losing existing ones.
-- Retention must grow alongside acquisition for sustainable business growth.

-- ============================================================
-- QUERY 10: TOP CATEGORIES BOUGHT BY REPEAT CUSTOMERS
-- Business Question: What do loyal customers buy most? Which product categories drive repeat purchases?
 
CREATE OR REPLACE VIEW olist.v_repeat_customer_categories AS
SELECT
COALESCE(p.product_category_english, 'unknown') AS category,
COUNT(DISTINCT o.order_id) AS total_orders,
COUNT(DISTINCT c.customer_unique_id) AS total_customers,
ROUND(SUM(oi.price)::NUMERIC, 2) AS total_revenue,
ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_price
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
JOIN olist.order_items oi ON o.order_id = oi.order_id
JOIN olist.products p ON oi.product_id = p.product_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
AND c.customer_unique_id IN (
SELECT c2.customer_unique_id
FROM olist.customers c2
JOIN olist.orders o2 ON c2.customer_id = o2.customer_id
WHERE o2.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c2.customer_unique_id
HAVING COUNT(DISTINCT o2.order_id) > 1)
GROUP BY category
ORDER BY total_orders DESC
LIMIT 10;
 
--Verify
SELECT * FROM olist.v_repeat_customer_categories;
-- Business Impact:
-- bed_bath_table is the top repeat category with 867 orders from 595 customers.
-- Top 4 categories (bed_bath_table, sports_leisure, furniture_decor, health_beauty)
-- are all home and lifestyle products — showing where loyalty is built.
-- Olist can send personalized recommendations to one-time
-- buyers in these categories within 45 days of first purchase
-- to convert them into repeat customers.
-- A 5% improvement in repeat rate = estimated R$800K in extra revenue.


								-- MASTER VIEW FOR POWER BI
CREATE OR REPLACE VIEW olist.v_powerbi_master AS
SELECT
c.customer_unique_id,
c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(SUM(p.payment_value)::NUMERIC, 2) AS total_spend,
MAX(o.order_purchase_timestamp)::DATE AS last_order_date,
DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE AS recency_days,
ROUND(AVG(r.review_score)::NUMERIC, 2)  AS avg_review_score,
CASE
WHEN COUNT(DISTINCT o.order_id) > 1
THEN 'Repeat Customer'
ELSE 'One-Time Customer'
END AS customer_type,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE <= 90
THEN 'Active'
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE <= 180
THEN 'At Risk'
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE <= 365
THEN 'Churned - Recent'
ELSE 'Churned - Long Term'
END AS churn_status,
CASE
WHEN DATE '2018-10-17' - MAX(o.order_purchase_timestamp)::DATE > 180
THEN 1
ELSE 0
END AS is_churned
FROM olist.customers c
JOIN olist.orders o ON c.customer_id = o.customer_id
JOIN olist.order_payments p ON o.order_id = p.order_id
LEFT JOIN olist.order_reviews r ON o.order_id = r.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY c.customer_unique_id, c.customer_state;
 
-- Verify
SELECT
churn_status,
COUNT(*) AS customers,
ROUND(AVG(total_spend)::NUMERIC, 2) AS avg_spend,
ROUND(AVG(avg_review_score)::NUMERIC, 2) AS avg_score
FROM olist.v_powerbi_master
GROUP BY churn_status
ORDER BY customers DESC;

--TOP 10 STATES BY CHURN RATE For Power BI bar chart
CREATE OR REPLACE VIEW olist.v_churn_top10_states AS
SELECT
customer_state,
total_customers,
churned_customers,
active_customers,
churn_rate_pct
FROM olist.v_churn_by_state
ORDER BY churn_rate_pct DESC
LIMIT 10;

-- Delivery Statistics for Power BI Dashboard(Average Delivery day)
CREATE OR REPLACE VIEW olist.v_delivery_stats AS
SELECT
ROUND(AVG(delivery_time_days)::NUMERIC, 1) AS avg_delivery_days,
ROUND(AVG(delivery_delay_days)::NUMERIC, 1) AS avg_delay_days,
COUNT(*) FILTER (WHERE is_late_delivery = TRUE) AS late_orders,
COUNT(*) AS total_delivered
FROM olist.orders
WHERE is_valid_delivered = TRUE;

--Verify
SELECT * FROM olist.v_delivery_stats;

