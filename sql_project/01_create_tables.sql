CREATE DATABASE IF NOT EXISTS olist_ecommerce;
USE olist_ecommerce;

-- =====================================================
-- Reset Existing Tables for Reproducibility
-- =====================================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS order_payments;
DROP TABLE IF EXISTS order_reviews;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS geolocation;
DROP TABLE IF EXISTS category_translation;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 1. Orders
-- =====================================================
CREATE TABLE orders (
    order_id CHAR(32),
    customer_id CHAR(32),
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- =====================================================
-- 2. Customers
-- =====================================================
CREATE TABLE customers (
    customer_id CHAR(32),
    customer_unique_id CHAR(32),
    customer_zip_code_prefix CHAR(5),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- =====================================================
-- 3. Order Items
-- =====================================================
CREATE TABLE order_items (
    order_id CHAR(32),
    order_item_id INT,
    product_id CHAR(32),
    seller_id CHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

-- =====================================================
-- 4. Order Payments
-- =====================================================
CREATE TABLE order_payments (
    order_id CHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

-- =====================================================
-- 5. Order Reviews
-- =====================================================
CREATE TABLE order_reviews (
    review_id CHAR(32),
    order_id CHAR(32),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- =====================================================
-- 6. Products
-- =====================================================
CREATE TABLE products (
    product_id CHAR(32),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2)
);

-- =====================================================
-- 7. Sellers
-- =====================================================
CREATE TABLE sellers (
    seller_id CHAR(32),
    seller_zip_code_prefix CHAR(5),
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- =====================================================
-- 8. Geolocation
-- =====================================================
CREATE TABLE geolocation (
    geolocation_zip_code_prefix CHAR(5),
    geolocation_lat DOUBLE,
    geolocation_lng DOUBLE,
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

-- =====================================================
-- 9. Product Category Translation
-- =====================================================
CREATE TABLE category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);