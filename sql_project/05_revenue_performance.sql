USE olist_ecommerce;

-- =====================================================
-- Analysis 1A: Monthly Product Sales and MoM Growth
-- =====================================================
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
        SUM(oi.price) AS product_sales
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= '2017-01-01'
      AND o.order_purchase_timestamp < '2018-09-01'
    GROUP BY order_month
),

sales_with_lag AS (
    SELECT order_month, product_sales,
        LAG(product_sales) OVER (ORDER BY order_month) AS previous_month_sales
    FROM monthly_sales
)

SELECT order_month, product_sales, previous_month_sales,
    ROUND((product_sales - previous_month_sales) / NULLIF(previous_month_sales, 0) * 100, 2) AS mom_growth_pct
FROM sales_with_lag
ORDER BY order_month;

-- =====================================================
-- Analysis 1B.1: Product Sales by Category
-- =====================================================
SELECT
    COALESCE(ct.product_category_name_english, 'Unknown') AS category,
    SUM(oi.price) AS product_sales,
    ROUND(SUM(oi.price) / SUM(SUM(oi.price)) OVER () * 100, 2) AS sales_share_pct
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
ORDER BY product_sales DESC;

-- =====================================================
-- Analysis 1B.2: Top 5 Category Sales Share
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
        SUM(product_sales) OVER () AS total_product_sales
    FROM category_sales
)

SELECT SUM(product_sales) AS top_5_sales,
    ROUND(SUM(product_sales) / MAX(total_product_sales) * 100, 2) AS top_5_sales_share_pct
FROM ranked_categories
WHERE sales_rank <= 5;

-- =====================================================
-- Analysis 1C.1: Category Sales Growth
-- =====================================================
WITH category_period_sales AS (
	SELECT
		COALESCE(ct.product_category_name_english, 'Unknown') AS category,
		CASE
			WHEN o.order_purchase_timestamp < '2018-01-01' THEN '2017_H2'
			ELSE '2018_H1'
		END AS period,
		SUM(oi.price) AS product_sales
	FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_id
	JOIN products AS p
		ON oi.product_id = p.product_id
	LEFT JOIN category_translation AS ct
		ON p.product_category_name = ct.product_category_name
	WHERE o.order_status = 'delivered'
	  AND o.order_purchase_timestamp >= '2017-07-01'
	  AND o.order_purchase_timestamp < '2018-07-01'
	GROUP BY category, period
),

category_sales AS (
	SELECT category,
		SUM(CASE WHEN period = '2017_H2' THEN product_sales ELSE 0 END) AS sales_2017_h2,
		SUM(CASE WHEN period = '2018_H1' THEN product_sales ELSE 0 END) AS sales_2018_h1
	FROM category_period_sales
	GROUP BY category
)

SELECT category, sales_2017_h2, sales_2018_h1,
    sales_2018_h1 - sales_2017_h2 AS growth_amount,
    ROUND((sales_2018_h1 - sales_2017_h2) / NULLIF(sales_2017_h2, 0) * 100, 2) AS growth_pct
FROM category_sales
ORDER BY growth_amount DESC;

-- =====================================================
-- Analysis 1C.2: Growth Summary
-- =====================================================
WITH category_period_sales AS (
	SELECT
		COALESCE(ct.product_category_name_english, 'Unknown') AS category,
		CASE
			WHEN o.order_purchase_timestamp < '2018-01-01' THEN '2017_H2'
			ELSE '2018_H1'
		END AS period,
		SUM(oi.price) AS product_sales
	FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_id
	JOIN products AS p
		ON oi.product_id = p.product_id
	LEFT JOIN category_translation AS ct
		ON p.product_category_name = ct.product_category_name
	WHERE o.order_status = 'delivered'
	  AND o.order_purchase_timestamp >= '2017-07-01'
	  AND o.order_purchase_timestamp < '2018-07-01'
	GROUP BY category, period
),

category_sales AS (
	SELECT category,
		SUM(CASE WHEN period = '2017_H2' THEN product_sales ELSE 0 END) AS sales_2017_h2,
		SUM(CASE WHEN period = '2018_H1' THEN product_sales ELSE 0 END) AS sales_2018_h1
	FROM category_period_sales
	GROUP BY category
)

SELECT
    COUNT(*) AS total_categories,
    SUM(CASE WHEN sales_2018_h1 > sales_2017_h2 THEN 1 ELSE 0 END) AS growing_categories,
    ROUND(SUM(CASE WHEN sales_2018_h1 > sales_2017_h2 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS growing_category_pct
FROM category_sales;

-- =====================================================
-- Analysis 1C.3: Top 5 Growth Contribution
-- =====================================================
WITH category_period_sales AS (
	SELECT
		COALESCE(ct.product_category_name_english, 'Unknown') AS category,
		CASE
			WHEN o.order_purchase_timestamp < '2018-01-01' THEN '2017_H2'
			ELSE '2018_H1'
		END AS period,
		SUM(oi.price) AS product_sales
	FROM orders AS o
	JOIN order_items AS oi
		ON o.order_id = oi.order_id
	JOIN products AS p
		ON oi.product_id = p.product_id
	LEFT JOIN category_translation AS ct
		ON p.product_category_name = ct.product_category_name
	WHERE o.order_status = 'delivered'
	  AND o.order_purchase_timestamp >= '2017-07-01'
	  AND o.order_purchase_timestamp < '2018-07-01'
	GROUP BY category, period
),

category_sales AS (
	SELECT category,
		SUM(CASE WHEN period = '2017_H2' THEN product_sales ELSE 0 END) AS sales_2017_h2,
		SUM(CASE WHEN period = '2018_H1' THEN product_sales ELSE 0 END) AS sales_2018_h1
	FROM category_period_sales
	GROUP BY category
),

category_growth AS (
    SELECT category, sales_2018_h1 - sales_2017_h2 AS growth_amount
    FROM category_sales
),

positive_growth AS (
    SELECT category, growth_amount
    FROM category_growth
    WHERE growth_amount > 0
),

ranked_growth AS (
    SELECT category, growth_amount,
        ROW_NUMBER() OVER (ORDER BY growth_amount DESC) AS growth_rank,
        SUM(growth_amount) OVER () AS total_positive_growth
    FROM positive_growth
)

SELECT
    SUM(growth_amount) AS top_5_growth,
    ROUND(SUM(growth_amount) / MAX(total_positive_growth) * 100, 2) AS top_5_growth_share_pct
FROM ranked_growth
WHERE growth_rank <= 5;