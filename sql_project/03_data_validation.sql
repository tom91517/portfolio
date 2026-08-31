USE olist_ecommerce;

-- =====================================================
-- 1. Key Uniqueness Validation
-- =====================================================
SELECT 'orders' AS table_name, COUNT(*) AS total_rows, COUNT(DISTINCT order_id) AS unique_keys
FROM orders

UNION ALL

SELECT 'customers', COUNT(*), COUNT(DISTINCT customer_id)
FROM customers

UNION ALL

SELECT 'products', COUNT(*), COUNT(DISTINCT product_id)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*), COUNT(DISTINCT seller_id)
FROM sellers

UNION ALL

SELECT 'category_translation', COUNT(*), COUNT(DISTINCT product_category_name)
FROM category_translation;

-- =====================================================
-- 2. Composite Key Validation
-- =====================================================
SELECT 'order_items' AS table_name, COUNT(*) AS total_rows, COUNT(DISTINCT order_id, order_item_id) AS unique_keys
FROM order_items

UNION ALL

SELECT 'order_payments' AS table_name, COUNT(*) AS total_rows, COUNT(DISTINCT order_id, payment_sequential) AS unique_keys
FROM order_payments;

SELECT 
	COUNT(*) AS total_rows, 
	COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(DISTINCT order_id) AS unique_order_ids, 
    COUNT(DISTINCT review_id, order_id) AS unique_review_order_pairs
FROM order_reviews;

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_prefixes
FROM geolocation;

-- =====================================================
-- 3. Composite Key Validation
-- =====================================================
SELECT 'orders.order_id' AS field_name, COUNT(*) AS null_count
FROM orders
WHERE order_id IS NULL OR order_id = ''

UNION ALL

SELECT 'orders.customer_id', COUNT(*)
FROM orders
WHERE customer_id IS NULL OR customer_id = ''

UNION ALL

SELECT 'customers.customer_id', COUNT(*)
FROM customers
WHERE customer_id IS NULL OR customer_id = ''

UNION ALL

SELECT 'order_items.order_id', COUNT(*)
FROM order_items
WHERE order_id IS NULL OR order_id = ''

UNION ALL

SELECT 'order_items.product_id', COUNT(*)
FROM order_items
WHERE product_id IS NULL OR product_id = ''

UNION ALL

SELECT 'order_items.seller_id', COUNT(*)
FROM order_items
WHERE seller_id IS NULL OR seller_id = ''

UNION ALL

SELECT 'order_payments.order_id', COUNT(*)
FROM order_payments
WHERE order_id IS NULL OR order_id = ''

UNION ALL

SELECT 'order_reviews.order_id', COUNT(*)
FROM order_reviews
WHERE order_id IS NULL OR order_id = ''

UNION ALL

SELECT 'products.product_id', COUNT(*)
FROM products
WHERE product_id IS NULL

UNION ALL

SELECT 'sellers.seller_id', COUNT(*)
FROM sellers
WHERE seller_id IS NULL;

-- =====================================================
-- 4. Referential Integrity Validation
-- =====================================================
SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS missing_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS missing_sellers
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) AS orphan_payments
FROM order_payments op
LEFT JOIN orders o 
	ON op.order_id = o.order_id
WHERE o.order_id IS NULL;
    
SELECT COUNT(*) AS orphan_reviews
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(DISTINCT p.product_category_name) AS categories_without_translation
FROM products p
LEFT JOIN category_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;
    
-- =====================================================
-- 5. Missing Value Profiling
-- =====================================================
SELECT
    COUNT(*) AS total_orders,
    SUM(order_approved_at IS NULL) AS missing_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_customer_delivery,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_delivery
FROM orders;

SELECT
    COUNT(*) AS total_products,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM products;

SELECT
    COUNT(*) AS total_reviews,
    SUM(review_comment_title IS NULL) AS missing_titles,
    SUM(review_comment_message IS NULL) AS missing_messages
FROM order_reviews;
