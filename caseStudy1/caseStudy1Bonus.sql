customer_id	order_date	product_name	price	member

--Join All The Things
--The following questions are related creating basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL.
SELECT M.customer_id, order_date, product_name, price,
CASE WHEN order_date >= join_date THEN 'Y' ELSE 'N' END AS member
FROM Members M
JOIN Sales S
ON M.customer_id = S.customer_id
LEFT JOIN Menu Me ON
Me.product_id = S.product_id


--Rank All The Things
--Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for
--non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
WITH CTE AS(
SELECT M.customer_id, order_date, product_name, price, join_date,
CASE WHEN order_date >= join_date THEN 'Y' ELSE 'N' END AS member
FROM Members M
JOIN Sales S
ON M.customer_id = S.customer_id
LEFT JOIN Menu Me ON
Me.product_id = S.product_id)

SELECT customer_id,order_date, product_name,price,member,
CASE WHEN order_date >= join_date THEN  DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY price DESC) ELSE NULL END AS ranking
FROM CTE
ORDER BY customer_id,order_date