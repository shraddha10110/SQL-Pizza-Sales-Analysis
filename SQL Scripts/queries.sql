-- 1. Total number of orders
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- 2. Total revenue
SELECT SUM(order_details.quantity * pizzas.unit_price) AS total_revenue
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- 3. Highest priced pizza
SELECT pizza_name, unit_price
FROM pizzas
ORDER BY unit_price DESC
LIMIT 1;

-- 4. Most common pizza size
SELECT size, COUNT(*) AS count
FROM pizzas
GROUP BY size
ORDER BY count DESC
LIMIT 1;

-- 5. Top 5 most ordered pizza types
SELECT pizza_name, SUM(quantity) AS total_quantity
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_name
ORDER BY total_quantity DESC
LIMIT 5;

------------------------------------------------------
-- INTERMEDIATE SQL QUERIES
------------------------------------------------------

-- Category-wise total quantity
SELECT category, SUM(quantity) AS total_quantity
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category;

-- Order count by hour of the day
SELECT HOUR(order_time) AS hour, COUNT(order_id) AS total_orders
FROM orders
GROUP BY hour
ORDER BY hour;

-- Category-wise distribution of pizzas
SELECT category, COUNT(pizza_id) AS total_pizzas
FROM pizzas
GROUP BY category;

-- Average pizzas ordered per day
SELECT order_date, AVG(quantity) AS avg_pizzas
FROM order_details
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY order_date;

------------------------------------------------------
-- ADVANCED SQL QUERIES
------------------------------------------------------

-- % revenue contribution of each pizza
SELECT pizza_name,
       SUM(quantity * unit_price) AS revenue,
       (SUM(quantity * unit_price) * 100 /
       (SELECT SUM(quantity * unit_price)
        FROM order_details
        JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id)) AS revenue_pct
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_name
ORDER BY revenue DESC;

-- Cumulative revenue over time
SELECT order_date,
       SUM(quantity * unit_price) AS daily_revenue,
       SUM(SUM(quantity * unit_price)) OVER (ORDER BY order_date) AS cumulative_revenue
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY order_date;

-- Top 3 pizzas by revenue in each category
SELECT category, pizza_name,
       SUM(quantity * unit_price) AS revenue
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY category, pizza_name
ORDER BY category, revenue DESC;
