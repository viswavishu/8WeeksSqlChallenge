SELECT TOP 5 *
FROM customer_transactions;

SELECT TOP 5 *
FROM customer_nodes C
LEFT JOIN regions R ON
C.region_id = R.region_id;


--How many unique nodes are there on the Data Bank system?

SELECT COUNT(DISTINCT(node_id)) AS [Unique Nodes]
FROM customer_nodes;


--What is the number of nodes per region?
SELECT region_id, COUNT(DISTINCT node_id) AS nodes
FROM customer_nodes
GROUP BY region_id
ORDER BY region_id


--How many customers are allocated to each region?
SELECT region_id, COUNT(customer_id) AS [Customers count]
FROM customer_nodes
GROUP BY region_id
ORDER BY region_id

--How many days on average are customers reallocated to a different node?
--Looks like the end is very long (('190', '5', '1', '2020-04-24', '9999-12-31'))
SELECT AVG(DATEDIFF(DAY,start_date,end_date)) AS [Average Days]
FROM customer_nodes

--What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
WITH ReallocationDays AS (
    SELECT 
        region_id,
        DATEDIFF(day, start_date, end_date) AS reallocation_days
    FROM 
        customer_nodes
),
Percentiles AS (
    SELECT 
        region_id,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY reallocation_days) OVER (PARTITION BY region_id) AS median,
        PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY reallocation_days) OVER (PARTITION BY region_id) AS percentile_80th,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY reallocation_days) OVER (PARTITION BY region_id) AS percentile_95th
    FROM 
        ReallocationDays
)
SELECT DISTINCT
    region_id,
    median,
    percentile_80th,
    percentile_95th
FROM 
    Percentiles
ORDER BY 
    region_id;



SELECT TOP 20 *
FROM customer_nodes
