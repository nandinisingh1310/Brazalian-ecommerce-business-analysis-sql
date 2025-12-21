CREATE DATABASE IF NOT EXISTS ecommerce_sql_project;
USE ecommerce_sql_project;
-- SELECT COUNT(*) FROM olist_orders;
-- SELECT COUNT(*) FROM olist_order_items;
-- SELECT COUNT(*) FROM olist_customers;
-- SELECT COUNT(*) FROM olist_products;
-- SELECT COUNT(*) FROM olist_sellers;
-- SELECT COUNT(*) FROM olist_order_payments;


SELECT COUNT(*) AS total_customers FROM olist_customers;
SELECT * FROM olist_order_payments;
SELECT SUM(payment_value) as Total_revenue from olist_order_payments;
SELECT * FROM olist_customers;
SELECT * FROM olist_orders;
SELECT * FROM olist_order_items;
SELECT * FROM olist_order_payments;
SELECT * FROM olist_customers;
SELECT * FROM olist_orders;
SELECT * FROM olist_sellers;
SELECT * FROM olist_order_items;
SELECT SUM(olist_order_payments.payment_value)/ COUNT(DISTINCT olist_orders.order_id) AS AOV 
FROM olist_orders 
JOIN olist_order_payments on olist_orders.order_id = olist_order_payments.order_id 
WHERE olist_orders.order_status = 'delivered';

SELECT order_status, COUNT(*) as number_orders FROM olist_orders group by order_status;

SELECT olist_customers.customer_state,
COUNT(*) AS num_of_orders
FROM olist_customers
JOIN olist_orders on olist_customers.customer_id = olist_orders.customer_id
where olist_orders.order_status = 'delivered' GROUP BY olist_customers.customer_state ORDER BY num_of_orders DESC
LIMIT 5;

SELECT olist_orders.customer_id,
SUM(olist_order_payments.payment_value) as TOP_10_CUSTOMERS
FROM olist_orders
JOIN olist_order_payments on olist_orders.order_id = olist_order_payments.order_id 
WHERE olist_orders.order_status = 'delivered' GROUP BY olist_orders.customer_id ORDER BY TOP_10_CUSTOMERS DESC LIMIT 10;

SELECT DISTINCT order_status
FROM olist_orders;

SELECT customer_id,
COUNT(order_id) AS ORDER_PER_CUSTOMER
FROM olist_orders
WHERE order_status ='delivered' GROUP BY customer_id ORDER BY ORDER_PER_CUSTOMER DESC;

SELECT customer_id,
COUNT(order_id) AS ORDER_PER_CUSTOMER,
CASE
	WHEN COUNT(order_id) = 1 THEN 'ONE TIME CUSTOMER'
    ELSE 'REPEAT CUSTOMER'
    END AS customer_type
FROM olist_orders
WHERE order_status ='delivered' GROUP BY customer_id ORDER BY ORDER_PER_CUSTOMER DESC;


SELECT customer_type,
COUNT(*) AS number_of_customers
FROM (
SELECT
customer_id,
CASE
WHEN COUNT(order_id) = 1 THEN 'One-time customer'
ELSE 'Repeat customer'
END AS customer_type
FROM olist_orders
WHERE order_status = 'delivered'
GROUP BY customer_id
) t
GROUP BY customer_type;

SELECT product_id,
SUM(price) as TOP_10_PRODUCTS
FROM olist_order_items GROUP BY product_id ORDER BY TOP_10_PRODUCTS DESC LIMIT 10;

SELECT olist_Sellers.seller_id, 
SUM(olist_order_items.price) AS TOP_5_SELLERS_PROD
FROM olist_sellers
JOIN olist_order_items on olist_sellers.seller_id = olist_order_items.seller_id GROUP BY olist_Sellers.seller_id ORDER BY
TOP_5_SELLERS_PROD DESC LIMIT 5;

SELECT YEAR(order_purchase_timestamp) AS ORDER_YEAR, 
MONTH(order_purchase_timestamp) AS ORDER_MONTH, 
COUNT(*) AS MONTHLY_ORDER_COUNT
FROM olist_orders GROUP BY MONTH(order_purchase_timestamp), YEAR(order_purchase_timestamp) ORDER BY order_year,
    order_month;
    
    
    
SELECT customer_id, TOTAL_REVENUE, 
RANK() OVER (ORDER BY TOTAL_REVENUE DESC) AS customer_rank FROM
(SELECT olist_orders.customer_id, SUM(olist_order_payments.payment_value) AS TOTAL_REVENUE
FROM olist_order_payments
JOIN olist_orders ON olist_order_payments.order_id = olist_orders.order_id
WHERE olist_orders.order_status = 'delivered' GROUP BY olist_orders.customer_id) t;

SELECT customer_id, TOTAL_REVENUE, 
dense_rank() OVER (ORDER BY TOTAL_REVENUE DESC) AS customer_rank FROM
(SELECT olist_orders.customer_id, SUM(olist_order_payments.payment_value) AS TOTAL_REVENUE
FROM olist_order_payments
JOIN olist_orders ON olist_order_payments.order_id = olist_orders.order_id
WHERE olist_orders.order_status = 'delivered' GROUP BY olist_orders.customer_id) t;


SELECT * FROM olist_order_items;
SELECT * FROM olist_orders;
SELECT * FROM olist_products_dataset;


SELECT *
FROM
(SELECT olist_products_dataset.product_category_name, olist_products_dataset.product_id, olist_order_items.price,
DENSE_RANK() OVER(PARTITION BY product_category_name ORDER BY price) AS PRODUCT_RANK
FROM olist_order_items JOIN 
olist_products_dataset ON olist_products_dataset.product_id = olist_order_items.product_id) t
WHERE PRODUCT_RANK <=3;

SELECT * FROM olist_customers;
SELECT * FROM olist_orders;
SELECT * FROM olist_order_items;
SELECT * FROM olist_order_payments;

SELECT * FROM olist_orders;
SELECT * FROM olist_sellers;
SELECT * FROM olist_order_items;


(SELECT olist_orders.customer_id, 
SUM(olist_order_payments.payment_value) OVER (PARTITION BY customer_id) as CUSTOMER_TOTAL_SPENDING
FROM olist_orders
JOIN olist_order_payments ON olist_order_payments.order_id = olist_orders.order_id);


SELECT
  YEAR,
  MONTH,
  MONTHLY_REVENUE,
  LAG(MONTHLY_REVENUE) OVER (
    ORDER BY YEAR, MONTH
  ) AS PREVIOUS_MONTH_REVENUE
FROM (
  SELECT
    YEAR(o.order_purchase_timestamp) AS YEAR,
    MONTH(o.order_purchase_timestamp) AS MONTH,
    SUM(p.payment_value) AS MONTHLY_REVENUE
  FROM olist_orders o
  JOIN olist_order_payments p
    ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY YEAR, MONTH
) t
ORDER BY YEAR, MONTH;


SELECT
  customer_id,
  COUNT(order_id) AS total_orders
FROM olist_orders
GROUP BY customer_id
HAVING COUNT(order_id) = 1;



SELECT
  seller_id,
  seller_revenue,
  seller_revenue * 100.0
    / SUM(seller_revenue) OVER () AS revenue_percentage
FROM (
  SELECT
    oi.seller_id,
    SUM(oi.price) AS seller_revenue
  FROM olist_order_items oi
  JOIN olist_orders o
    ON oi.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY oi.seller_id
) t
ORDER BY revenue_percentage DESC;


SELECT
  order_id,
  COUNT(product_id) AS product_count
FROM olist_order_items
GROUP BY order_id
HAVING COUNT(product_id) > 1;


WITH customer_revenue AS (
  SELECT
    o.customer_id,
    SUM(p.payment_value) AS total_revenue
  FROM olist_orders o
  JOIN olist_order_payments p
    ON o.order_id = p.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY o.customer_id
),
ranked_customers AS (
  SELECT
    customer_id,
    total_revenue,
    NTILE(5) OVER (ORDER BY total_revenue DESC) AS revenue_bucket
  FROM customer_revenue
)
SELECT
  SUM(total_revenue) AS top_20_percent_revenue,
  SUM(total_revenue) * 100.0
    / (SELECT SUM(total_revenue) FROM customer_revenue) AS revenue_percentage
FROM ranked_customers
WHERE revenue_bucket = 1;
