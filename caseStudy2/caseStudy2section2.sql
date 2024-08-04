--B. Runner and Customer Experience


--Not clear
--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT *
FROM pizza_runner.runners
SELECT *
FROM pizza_runner.runner_orders

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT RO.runner_id, AVG(DATEDIFF(MINUTE,CO.order_time,RO.pickup_time)) AS [Average Time Taken]
FROM pizza_runner.customer_orders AS CO
LEFT JOIN pizza_runner.runner_orders AS RO
ON CO.order_id = RO.order_id
GROUP BY RO.runner_id


--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
--NA Cant find as there is no column for time taken to prepare


--4. What was the average distance travelled for each runner?
SELECT RO.runner_id, AVG(distance) AS [Average Distance]
FROM pizza_runner.customer_orders AS CO
LEFT JOIN pizza_runner.runner_orders AS RO
ON CO.order_id = RO.order_id
GROUP BY RO.runner_id

--5. What was the difference between the longest and shortest delivery times for all orders?

SELECT  MAX(duration) AS [Longest time], min(duration) AS [Shortest time]
FROM pizza_runner.customer_orders AS CO
LEFT JOIN pizza_runner.runner_orders AS RO
ON CO.order_id = RO.order_id


--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
--NA

--7. What is the successful delivery percentage for each runner?
--NA Data was not sufficent has there is no reason to find the percentage as there is no direct cancellation from rider. Basically the percentage is
--100% for each rider as per given table.