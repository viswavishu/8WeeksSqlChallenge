--1. What is the total amount each customer spent at the restaurant?
--2. How many days has each customer visited the restaurant?


SELECT SA.customer_id, FORMAT(SUM(ME.price), 'C', 'en-US') AS Total_spent,
COUNT(*) AS No_Of_Visists
FROM Sales SA
LEFT JOIN Menu ME ON
SA.product_id = ME.product_id
GROUP BY SA.customer_id;



--3. What was the first item from the menu purchased by each customer?
WITH CTE AS(
SELECT SA.customer_id,ME.product_name,
ROW_NUMBER() OVER(PARTITION BY SA.customer_id ORDER BY (SELECT NULL)) AS RN
FROM Sales SA
LEFT JOIN Menu ME ON
SA.product_id = ME.product_id
)
SELECT customer_id,product_name AS First_Item_Ordered
FROM CTE
WHERE RN = 1


--4. What is the most purchased item on the menu and how many times was it purchased by all customers?
--5. Which item was the most popular for each customer?
WITH CTE AS(
SELECT DISTINCT SA.customer_id,ME.product_name,
COUNT(product_name) OVER(PARTITION BY customer_id,product_name) AS Items
FROM Sales SA
LEFT JOIN Menu ME ON
SA.product_id = ME.product_id

)
, CTE2 AS(
SELECT customer_id,product_name,Items,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY Items DESC) AS RN
FROM CTE)

SELECT customer_id, Items AS No_Of_Times_Brought, product_name AS Most_Populat_Item
FROM CTE2
WHERE RN = 1

--6. Which item was purchased first by the customer after they became a member?

WITH CTE AS(
SELECT SA.customer_id, product_name, ROW_NUMBER() OVER(PARTITION BY SA.customer_id ORDER BY order_date) AS RN
FROM Sales SA
LEFT JOIN Menu ME ON
SA.product_id = ME.product_id
LEFT JOIN Members M
ON SA.customer_id = M.customer_id
WHERE order_date > join_date)

SELECT customer_id, product_name AS Foabm
FROM CTE
WHERE RN = 1

--7. Which item was purchased just before the customer became a member?

WITH CTE AS(
SELECT SA.customer_id, product_name, ROW_NUMBER() OVER(PARTITION BY SA.customer_id ORDER BY order_date) AS RN
FROM Sales SA
LEFT JOIN Menu ME ON
SA.product_id = ME.product_id
LEFT JOIN Members M
ON SA.customer_id = M.customer_id
WHERE order_date < join_date)

SELECT customer_id, product_name AS Fobbm
FROM CTE
WHERE RN = 1

--8. What is the total items and amount spent for each member before they became a member?

SELECT SA.Customer_id,  FORMAT(SUM(ME.price), 'C', 'en-US') AS Total_spent
FROM Sales SA
LEFT JOIN Menu ME ON
SA.product_id = ME.product_id
LEFT JOIN Members M
ON SA.customer_id = M.customer_id
WHERE order_date < join_date
GROUP BY SA.Customer_id

--9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


SELECT SA.customer_id,
SUM(IIF(product_name = 'sushi',(price * 20),(price * 10))) AS Total_points  
FROM Members Me
LEFT JOIN Sales Sa
ON Me.customer_id = Sa.customer_id
LEFT JOIN Menu M ON
M.product_id = Sa.product_id
GROUP BY Sa.customer_id

--10. In the first week after a customer joins the program (including their join date)
--they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
SELECT  SA.customer_id,
(price * 20) AS Total_points  
FROM Sales SA
LEFT JOIN Menu ME ON
SA.product_id = ME.product_id
LEFT JOIN Members M
ON SA.customer_id = M.customer_id
WHERE order_date > join_date AND DATEDIFF(DAY,join_date, order_date) <= 7
AND Sa.customer_id IN ('A','B') AND MONTH(order_date) = 1
