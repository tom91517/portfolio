USE olist_ecommerce;

-- =====================================================
-- Analysis 2A.1: Customer Sales Concentration
-- =====================================================
WITH customer_sales AS (
    SELECT c.customer_unique_id AS customer_id, SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY c.customer_unique_id
),

ranked_customers AS (
    SELECT customer_id, product_sales,
        ROW_NUMBER() OVER (ORDER BY product_sales DESC) AS sales_rank,
        COUNT(*) OVER () AS total_customers
    FROM customer_sales
)

SELECT
    MAX(total_customers) AS total_customers,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_customers * 0.01) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_1_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_customers * 0.05) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_5_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_customers * 0.10) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_10_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_customers * 0.20) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_20_pct_share
FROM ranked_customers;

-- =====================================================
-- Analysis 2A.2: Customer Order Frequency Distribution
-- =====================================================
WITH customer_orders AS (
    SELECT c.customer_unique_id AS customer_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY c.customer_unique_id
)

SELECT order_count, COUNT(*) AS customer_count
FROM customer_orders
GROUP BY order_count
ORDER BY order_count;

-- =====================================================
-- Analysis 2A.3: Repeat Customer Sales Contribution
-- =====================================================
WITH customer_metrics AS (
    SELECT c.customer_unique_id AS customer_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY c.customer_unique_id
)

SELECT
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS repeat_customer_pct,
    SUM(CASE WHEN order_count > 1 THEN product_sales ELSE 0 END) AS repeat_customer_sales,
    ROUND(SUM(CASE WHEN order_count > 1 THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS repeat_customer_sales_share_pct
FROM customer_metrics;

-- =====================================================
-- Analysis 2B: Category Sales Concentration
-- =====================================================
WITH category_sales AS (
    SELECT
        COALESCE(ct.product_category_name_english, 'Unknown') AS category,
        SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    JOIN products AS p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation AS ct
        ON p.product_category_name = ct.product_category_name
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY category
),

ranked_categories AS (
    SELECT category, product_sales,
        ROW_NUMBER() OVER (ORDER BY product_sales DESC) AS sales_rank,
        COUNT(*) OVER () AS total_categories
    FROM category_sales
)

SELECT
    MAX(total_categories) AS total_categories,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_categories * 0.01) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_1_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_categories * 0.05) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_5_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_categories * 0.10) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_10_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_categories * 0.20) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_20_pct_share
FROM ranked_categories;

-- =====================================================
-- Analysis 2C: Seller Sales Concentration
-- =====================================================
WITH seller_sales AS (
    SELECT oi.seller_id AS seller_id, SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY oi.seller_id
),

ranked_sellers AS (
    SELECT seller_id, product_sales,
        ROW_NUMBER() OVER (ORDER BY product_sales DESC) AS sales_rank,
        COUNT(*) OVER () AS total_sellers
    FROM seller_sales
)

SELECT
    MAX(total_sellers) AS total_sellers,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_sellers * 0.01) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_1_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_sellers * 0.05) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_5_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_sellers * 0.10) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_10_pct_share,
    ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_sellers * 0.20) THEN product_sales ELSE 0 END)
        / SUM(product_sales) * 100, 2) AS top_20_pct_share
FROM ranked_sellers;

-- =====================================================
-- Analysis 2D: Concentration Comparison
-- =====================================================
WITH customer_sales AS (
    SELECT c.customer_unique_id AS entity_id, SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY c.customer_unique_id
),

ranked_customers AS (
    SELECT entity_id, product_sales,
        ROW_NUMBER() OVER (ORDER BY product_sales DESC) AS sales_rank,
        COUNT(*) OVER () AS total_entities
    FROM customer_sales
),

category_sales AS (
    SELECT COALESCE(ct.product_category_name_english, 'Unknown') AS entity_id,
        SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    JOIN products AS p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation AS ct
        ON p.product_category_name = ct.product_category_name
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY entity_id
),

ranked_categories AS (
    SELECT entity_id, product_sales,
        ROW_NUMBER() OVER (ORDER BY product_sales DESC) AS sales_rank,
        COUNT(*) OVER () AS total_entities
    FROM category_sales
),

seller_sales AS (
    SELECT oi.seller_id AS entity_id, SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY oi.seller_id
),

ranked_sellers AS (
    SELECT entity_id, product_sales,
        ROW_NUMBER() OVER (ORDER BY product_sales DESC) AS sales_rank,
        COUNT(*) OVER () AS total_entities
    FROM seller_sales
),

customer_summary AS (
    SELECT 'Customers' AS entity_type, MAX(total_entities) AS total_entities,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.01) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_1_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.05) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_5_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.10) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_10_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.20) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_20_pct_share
    FROM ranked_customers
),

category_summary AS (
    SELECT 'Categories' AS entity_type, MAX(total_entities) AS total_entities,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.01) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_1_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.05) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_5_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.10) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_10_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.20) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_20_pct_share
    FROM ranked_categories
),

seller_summary AS (
    SELECT 'Sellers' AS entity_type, MAX(total_entities) AS total_entities,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.01) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_1_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.05) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_5_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.10) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_10_pct_share,
        ROUND(SUM(CASE WHEN sales_rank <= CEIL(total_entities * 0.20) THEN product_sales ELSE 0 END)
            / SUM(product_sales) * 100, 2) AS top_20_pct_share
    FROM ranked_sellers
)

SELECT * FROM customer_summary
UNION ALL
SELECT * FROM category_summary
UNION ALL
SELECT * FROM seller_summary;