--1. How many pizzas were ordered?

SELECT COUNT(pizza_id) AS [No of pizzas]
FROM pizza_runner.customer_orders


--2 How many unique customer orders were made?
SELECT DISTINCT customer_id AS [No of unique customers]
FROM pizza_runner.customer_orders 

--3. How many successful orders were delivered by each runner?

SELECT runner_id,COUNT(*) AS [No of successful orders]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
WHERE cancellation IS NULL
GROUP BY runner_id


--4. How many of each type of pizza was delivered?
SELECT C.pizza_id,pizza_name, COUNT(*) AS[No of pizza delivered]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
LEFT JOIN pizza_runner.pizza_names AS P ON
P.pizza_id = C.pizza_id
WHERE cancellation IS NULL
GROUP BY C.pizza_id,pizza_name


--5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id, SUM(IIF(pizza_name  = 'Meatlovers',1,0)) AS [Meatlovers],  SUM(IIF(pizza_name  = 'Vegetarian',1,0)) AS [Vegetarian]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
LEFT JOIN pizza_runner.pizza_names AS P ON
P.pizza_id = C.pizza_id
GROUP BY customer_id

--6. What was the maximum number of pizzas delivered in a single order?
SELECT TOP 1 COUNT(C.pizza_id) AS [MAX Pizzas sold in single order]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
LEFT JOIN pizza_runner.pizza_names AS P ON
P.pizza_id = C.pizza_id
WHERE cancellation IS NULL
GROUP BY C.order_id
ORDER BY [MAX Pizzas sold in single order] DESC


--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT C.customer_id,
SUM(IIF(exclusions IS NOT NULL OR extras IS NOT NULL,1,0)) AS [changes],
SUM(IIF(exclusions IS NULL AND extras IS NULL,1,0)) AS [No changes]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
WHERE cancellation IS NULL
GROUP BY C.customer_id

--8. How many pizzas were delivered that had both exclusions and extras?
SELECT SUM(changes) AS [Orders with exclusions and extras] from(
SELECT 
CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END AS [changes]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
WHERE cancellation IS NULL) as t


--9. What was the total volume of pizzas ordered for each hour of the day?
SELECT DATEPART(HOUR,order_time) AS [Hourly Orders], COUNT(*) AS [volume of pizzas]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
WHERE cancellation IS NULL
GROUP BY DATEPART(HOUR,order_time)


--10. What was the volume of orders for each day of the week?
SELECT DATENAME(weekday,order_time) AS [Week], COUNT(*) AS [volume of pizzas]
FROM pizza_runner.customer_orders C
LEFT JOIN pizza_runner.runner_orders AS R
ON R.order_id = C.order_id
WHERE cancellation IS NULL
GROUP BY DATENAME(weekday,order_time)
