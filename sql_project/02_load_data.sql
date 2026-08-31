-- =====================================================
-- Data File Path
-- Update the file paths below to match your local CSV directory
-- =====================================================
USE olist_ecommerce;

-- =====================================================
-- 1. Orders
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_orders_dataset.csv'
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp =
        NULLIF(@order_purchase_timestamp, ''),
    order_approved_at =
        NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date =
        NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date =
        NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date =
        NULLIF(@order_estimated_delivery_date, '');
        
-- =====================================================
-- 2. Customers
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_customers_dataset.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- =====================================================
-- 3. Order Items
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_order_items_dataset.csv'
INTO TABLE order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =====================================================
-- 4. Order Payments
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_order_payments_dataset.csv'
INTO TABLE order_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =====================================================
-- 5. Order Reviews
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    @review_comment_title,
    @review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_comment_title =
        NULLIF(@review_comment_title, ''),
    review_comment_message =
        NULLIF(@review_comment_message, ''),
    review_creation_date =
        NULLIF(@review_creation_date, ''),
    review_answer_timestamp =
        NULLIF(@review_answer_timestamp, '');

-- =====================================================
-- 6. Products
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_products_dataset.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    @product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_category_name =
        NULLIF(@product_category_name, ''),
    product_name_lenght =
        NULLIF(@product_name_lenght, ''),
    product_description_lenght =
        NULLIF(@product_description_lenght, ''),
    product_photos_qty =
        NULLIF(@product_photos_qty, ''),
    product_weight_g =
        NULLIF(@product_weight_g, ''),
    product_length_cm =
        NULLIF(@product_length_cm, ''),
    product_height_cm =
        NULLIF(@product_height_cm, ''),
    product_width_cm =
        NULLIF(@product_width_cm, '');

-- =====================================================
-- 7. Sellers
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_sellers_dataset.csv'
INTO TABLE sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =====================================================
-- 8. Geolocation
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/olist_geolocation_dataset.csv'
INTO TABLE geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- =====================================================
-- 9. Product Category Translation
-- =====================================================
LOAD DATA LOCAL INFILE
'C:/Users/jintang/OneDrive/Desktop/Side Projects/portfolio/sql_project/olist_data/product_category_name_translation.csv'
INTO TABLE category_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;