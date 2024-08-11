--B. Data Analysis Questions


--1. How many customers has Foodie-Fi ever had?
SELECT COUNT(DISTINCT customer_id) AS [No of customers]
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id

2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

SELECT YEAR(start_date) AS Year, MONTH(start_date) AS Month, COUNT(*) AS [No Of free trials in one month]
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
WHERE plan_name = 'trial'
GROUP BY YEAR(start_date), MONTH(start_date)


3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name

SELECT plan_name, COUNT(*) AS [Count of events]
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
WHERE YEAR(start_date) = 2021
GROUP BY plan_name

4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?


SELECT COUNT(DISTINCT customer_id) AS Customers,SUM(CASE WHEN plan_name = 'churn' THEN 1 END) AS Churn,
ROUND((COUNT(DISTINCT customer_id) / CAST(SUM(CASE WHEN plan_name = 'churn' THEN 1.0 END)AS FLOAT) *100.0),2)  AS [Churned Customers]
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id

5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
   -- It is guaranteed that every customer is started with free trial only as per given data.

WITH CTE AS(
SELECT  customer_id,S.plan_id, P.plan_name, start_date , ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) AS RN
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
)

SELECT ROUND(((SELECT CAST(COUNT(customer_id) AS FLOAT) FROM CTE WHERE (RN = 2 AND plan_name = 'churn')) / COUNT(DISTINCT customer_id * 1.0)) * 100,0) AS [Churn Percentage]
FROM CTE


6. What is the number and percentage of customer plans after their initial free trial?


WITH CTE AS(
SELECT  customer_id,S.plan_id, P.plan_name, start_date , ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) AS RN
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
)

SELECT plan_name,COUNT(*) AS [Number after initial trial], (CAST(COUNT(*) AS FLOAT) /1000) * 100.0 AS [Percentage after initial trial]
FROM CTE
WHERE RN = 2
GROUP BY plan_name
ORDER BY [Number after initial trial] DESC


7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

SELECT plan_name, COUNT(*) AS [No Of customers], (CAST(COUNT(*) AS FLOAT) / 1000) * 100 AS Percentage
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
WHERE start_date <= '2020-12-31'
GROUP BY plan_name

8. How many customers have upgraded to an annual plan in 2020?


SELECT COUNT(*) AS [Upgraded to annual plan]
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
WHERE plan_name = 'pro annual' AND YEAR(start_date) = 2020


9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

WITH CTE AS(
SELECT  customer_id,S.plan_id, P.plan_name, start_date 
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id
),

CTE2 AS(
SELECT * 
FROM CTE
WHERE plan_name = 'trial'
)
, CTE3 AS(
SELECT * FROM CTE 
WHERE plan_name = 'pro annual'
)
, CTE4 AS(
SELECT C1.customer_id, DATEDIFF(DAY, C1.start_date, C2.start_date) AS Days
FROM CTE2 C1
INNER JOIN CTE3 C2 ON
C1.customer_id = C2.customer_id)


SELECT AVG(Days) AS Days
FROM CTE4


10. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

WITH CTE AS(
SELECT  customer_id,S.plan_id, P.plan_name, start_date , ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date) AS RN
FROM Subscriptions S
LEFT JOIN Plans P ON
S.plan_id = P.plan_id)

, CTE2 AS(
SELECT *
FROM CTE
WHERE plan_name = 'pro monthly' OR plan_name = 'basic monthly')
, CTE3 AS(
SELECT customer_id
FROM CTE2
GROUP BY customer_id
HAVING COUNT(plan_id) = 2)

SELECT COUNT(*) AS [Count]
FROM CTE3