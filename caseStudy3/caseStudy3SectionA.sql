
--A. Customer Journey
--Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

--Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

--# Based on 8 customer's behaviour
--1. All the customers were started with free trai.
     WITH CTE AS(
SELECT  customer_id,S.plan_id, P.plan_name, start_date , ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) AS RN
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
WHERE customer_id < 9
)

SELECT *
FROM CTE
WHERE RN = 1


2. Finding each customer behaviour

WITH CTE AS(
SELECT  customer_id,S.plan_id, P.plan_name, start_date , ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) AS RN
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
WHERE customer_id < 9
)

SELECT customer_id, STRING_AGG(plan_name,', ') AS [Onboarding Journey]
FROM CTE
GROUP BY customer_id

Customer 1 has started his free trial and started using basic monthly subscription.
Customer 2 has started his free trial and started using pro annual monthly subscription.
Customer 3 has started his free trial and started using basic monthly subscription.
Customer 4 has started his free trial and started using basic monthly subscription and Cancelled the plan after 3 months.
Customer 5 has started his free trial and started using basic monthly subscription.
Customer 6 has started his free trial and started using basic monthly subscription and Cancelled the plan after 2 months.
Customer 7 has started his free trial and started using basic monthly subscription and upgraded to pro monthly plan
Customer 8 has started his free trial and started using basic monthly subscription and upgraded to pro monthly plan






