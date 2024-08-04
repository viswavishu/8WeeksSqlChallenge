--D. Pricing and Ratings
--If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
--What if there was an additional $1 charge for any pizza extras?
--Add cheese is $1 extra
--The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
--Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
--customer_id
--order_id
--runner_id
--rating
--order_time
--pickup_time
--Time between order and pickup
--Delivery duration
--Average speed
--Total number of pizzas
--If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?


--1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes
-- how much money has Pizza Runner made so far if there are no delivery fees?
--2 What if there was an additional $1 charge for any pizza extras?

SELECT Pizza_name, concat('$','',SUM(CASE WHEN pizza_name = 'Meatlovers' THEN 12 ELSE 10 END) )AS Price,
concat('$','',SUM(CASE WHEN (pizza_name = 'Meatlovers' OR extras IS NOT NULL) THEN 13 ELSE 11 END) )AS [Additional Charge]
FROM pizza_runner.customer_orders AS CO
LEFT JOIN
pizza_runner.runner_orders AS RO ON
CO.order_id = RO.order_id
LEFT JOIN pizza_runner.pizza_names AS PN ON
PN.pizza_id = CO.pizza_id
WHERE cancellation IS NULL
GROUP BY Pizza_name;


--3. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled 
-- how much money does Pizza Runner have left over after these deliveries?

SELECT runner_id,  SUM(distance * 0.30) AS [Runner Price]
FROM pizza_runner.customer_orders AS CO
LEFT JOIN
pizza_runner.runner_orders AS RO ON
CO.order_id = RO.order_id
LEFT JOIN pizza_runner.pizza_names AS PN ON
PN.pizza_id = CO.pizza_id
WHERE cancellation IS NULL
GROUP BY runner_id