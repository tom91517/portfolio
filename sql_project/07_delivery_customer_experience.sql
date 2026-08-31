USE olist_ecommerce;

-- =====================================================
-- Analysis 3A: Overall Late Delivery Rate
-- =====================================================
SELECT COUNT(*) AS delivered_orders,
    SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
    ROUND(
        SUM(CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END)
        / COUNT(*) * 100, 2
    ) AS late_order_pct
FROM orders AS o
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL;


-- =====================================================
-- Analysis 3B: Late Delivery Rate by Seller Tier
-- =====================================================
WITH seller_sales AS (
    SELECT oi.seller_id AS seller_id, SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
    GROUP BY oi.seller_id
),

ranked_sellers AS (
    SELECT seller_id, product_sales,
        SUM(product_sales) OVER (ORDER BY product_sales DESC)
        / SUM(product_sales) OVER () AS cumulative_sales_share
    FROM seller_sales
),

seller_tiers AS (
    SELECT seller_id,
        CASE
            WHEN cumulative_sales_share <= 0.50 THEN 'A'
            WHEN cumulative_sales_share <= 0.80 THEN 'B'
            ELSE 'C'
        END AS seller_tier
    FROM ranked_sellers
),

seller_orders AS (
    SELECT DISTINCT oi.seller_id AS seller_id, o.order_id AS order_id,
        CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END AS is_late
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)

SELECT st.seller_tier,
    COUNT(DISTINCT st.seller_id) AS seller_count,
    COUNT(*) AS seller_orders,
    SUM(so.is_late) AS late_orders,
    ROUND(SUM(so.is_late) / COUNT(*) * 100, 2) AS late_order_pct
FROM seller_tiers AS st
JOIN seller_orders AS so
    ON st.seller_id = so.seller_id
GROUP BY st.seller_tier
ORDER BY st.seller_tier;


-- =====================================================
-- Analysis 3C: Late Delivery Rate by Customer State
-- =====================================================
SELECT c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(DISTINCT CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN o.order_id END) AS late_orders,
    ROUND(
        COUNT(DISTINCT CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN o.order_id END)
        / COUNT(DISTINCT o.order_id) * 100, 2
    ) AS late_order_pct
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_order_pct DESC;


-- =====================================================
-- Analysis 3D.1: Review Score by Delivery Timing
-- =====================================================
WITH ranked_reviews AS (
    SELECT r.order_id AS order_id, r.review_score AS review_score,
        ROW_NUMBER() OVER (
            PARTITION BY r.order_id
            ORDER BY r.review_answer_timestamp DESC
        ) AS review_rank
    FROM order_reviews AS r
),

latest_reviews AS (
    SELECT order_id, review_score
    FROM ranked_reviews
    WHERE review_rank = 1
),

delivery_reviews AS (
    SELECT o.order_id AS order_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days,
        lr.review_score AS review_score
    FROM orders AS o
    JOIN latest_reviews AS lr
        ON o.order_id = lr.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)

SELECT
    CASE
        WHEN delay_days <= -10 THEN '10+ days early'
        WHEN delay_days < -3 THEN '3-10 days early'
        WHEN delay_days < 0 THEN '0-3 days early'
        WHEN delay_days <= 3 THEN 'On time to 3 days late'
        WHEN delay_days <= 7 THEN '3-7 days late'
        WHEN delay_days <= 15 THEN '7-15 days late'
        ELSE '15+ days late'
    END AS delivery_timing,
    COUNT(*) AS orders,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM delivery_reviews
GROUP BY delivery_timing;


-- =====================================================
-- Analysis 3D.2: 1-Star Review Rate by Delivery Status
-- =====================================================
WITH ranked_reviews AS (
    SELECT r.order_id AS order_id, r.review_score AS review_score,
        ROW_NUMBER() OVER (
            PARTITION BY r.order_id
            ORDER BY r.review_answer_timestamp DESC
        ) AS review_rank
    FROM order_reviews AS r
),

latest_reviews AS (
    SELECT order_id, review_score
    FROM ranked_reviews
    WHERE review_rank = 1
),

delivery_reviews AS (
    SELECT o.order_id AS order_id,
        DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days,
        lr.review_score AS review_score
    FROM orders AS o
    JOIN latest_reviews AS lr
        ON o.order_id = lr.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
)

SELECT
    CASE WHEN delay_days <= 0 THEN 'On Time' ELSE 'Late' END AS delivery_status,
    COUNT(*) AS orders,
    SUM(CASE WHEN review_score = 1 THEN 1 ELSE 0 END) AS one_star_reviews,
    ROUND(SUM(CASE WHEN review_score = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS one_star_review_pct
FROM delivery_reviews
GROUP BY delivery_status
ORDER BY delivery_status;