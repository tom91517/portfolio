USE olist_ecommerce;

-- =====================================================
-- 1. Add Primary Keys
-- =====================================================
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE order_items
ADD PRIMARY KEY (order_id, order_item_id);

ALTER TABLE order_payments
ADD PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE order_reviews
ADD PRIMARY KEY (review_id, order_id);

ALTER TABLE products
ADD PRIMARY KEY (product_id);

ALTER TABLE sellers
ADD PRIMARY KEY (seller_id);

ALTER TABLE category_translation
ADD PRIMARY KEY (product_category_name);

-- =====================================================
-- 2. Add Foreign Keys
-- =====================================================
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

ALTER TABLE order_payments
ADD CONSTRAINT fk_order_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_reviews
ADD CONSTRAINT fk_order_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- =====================================================
-- Indexes
-- =====================================================

CREATE INDEX idx_geo_zip
ON geolocation (geolocation_zip_code_prefix);