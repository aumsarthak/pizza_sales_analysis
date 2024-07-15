-- Q1. Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_no_of_orders 
FROM orders;

-- Q2. Calculate the total revenue generated from pizza sales.
SELECT ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_revenue
FROM order_details JOIN pizzas
ON pizzas.pizza_id = order_details.pizza_id;

-- Q3. Identify the highest-priced pizza.
SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Q4. List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

-- Q5. Find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Q6. Find the category-wise distribution of pizzas.
SELECT pt.category, COUNT(p.pizza_id) AS total_pizzas
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category;

-- Q7. Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) AS hour_of_day, 
COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time);

-- Q8. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT order_date, 
  COUNT(od.order_id)
 AS total_pizzas_ordered,
ROUND(COUNT(od.order_id) /
 COUNT(DISTINCT order_date)) 
AS average_pizzas_per_day
FROM orders o
JOIN order_details od 
ON o.order_id = od.order_id
GROUP BY order_date;

-- Q9. Determine the top 3 most ordered pizza types based on total revenue.
SELECT pt.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

-- Q10. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT pt.category, pt.name,
 SUM((od.quantity) * p.price)
 AS revenue
FROM pizza_types pt JOIN pizzas p
ON pt.pizza_type_id 
 = p.pizza_type_id
JOIN order_details od
ON od.pizza_id = p.pizza_id
GROUP BY pt.category, pt.name;

-- Q11. Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.name, SUM(od.quantity * p.price)
 AS pizza_type_revenue,
ROUND(100.0 * SUM(od.quantity * p.price) / 
(SELECT SUM(od2.quantity * p2.price)
FROM order_details od2
JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id
), 2) AS percentage_contribution
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id 
= pt.pizza_type_id
GROUP BY pt.name
ORDER BY pizza_type_revenue DESC;
