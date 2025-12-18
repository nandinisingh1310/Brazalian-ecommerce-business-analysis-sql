CREATE DATABASE ecommerce_sql_project;
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