What is the unique count and total amount for each transaction type?

SELECT txn_type, SUM(txn_amount) AS [Total Amount]
FROM Customer_transactions
GROUP BY txn_type

What is the average total historical deposit counts and amounts for all customers?

SELECT SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS Count, SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount END) AS [deposit]
FROM Customer_transactions

For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?

WITH CTE AS(
SELECT MONTH(txn_date) AS [SingleMonth], COUNT(*) AS [Cnt]
FROM  Customer_transactions
WHERE txn_type IN('deposit', 'purchase', 'withdrawal')
GROUP BY customer_id , MONTH(txn_date)
)

SELECT SingleMonth AS [Month],
SUM(Cnt) AS [CustomerCnt]
FROM CTE
GROUP BY SingleMonth
ORDER BY [Month]

What is the closing balance for each customer at the end of the month?

WITH MonthlyTransactions AS (
    SELECT
        customer_id,
        DATEPART(year, txn_date) AS txn_year,
        DATEPART(month, txn_date) AS txn_month,
        SUM(CASE 
            WHEN txn_type = 'deposit' THEN txn_amount
            WHEN txn_type = 'withdrawal' THEN -txn_amount
            ELSE 0
        END) AS monthly_balance
    FROM 
        Customer_transactions
    GROUP BY 
        customer_id, 
        DATEPART(year, txn_date), 
        DATEPART(month, txn_date)
),
ClosingBalance AS (
    SELECT
        customer_id,
        txn_year,
        txn_month,
        SUM(monthly_balance) OVER (PARTITION BY customer_id ORDER BY txn_year, txn_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS closing_balance
    FROM 
        MonthlyTransactions
)
SELECT
    customer_id,
    txn_year,
    txn_month,
    closing_balance
FROM 
    ClosingBalance
ORDER BY 
    customer_id, txn_year, txn_month;


SELECT TOP 20 *
FROM Customer_transactions

WITH MonthlyBalances AS (
    SELECT
        customer_id,
        YEAR(txn_date) AS txn_year,
        MONTH(txn_date) AS txn_month,
        SUM(CASE 
            WHEN txn_type = 'deposit' THEN txn_amount
            WHEN txn_type = 'withdrawal' THEN -txn_amount
            ELSE 0
        END) AS monthly_balance
    FROM 
        Customer_transactions
    GROUP BY 
        customer_id, 
        YEAR(txn_date), 
        MONTH(txn_date)
),
ClosingBalances AS (
    SELECT
        customer_id,
        txn_year,
        txn_month,
        SUM(monthly_balance) OVER (PARTITION BY customer_id ORDER BY txn_year, txn_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS closing_balance
    FROM 
        MonthlyBalances
),
BalanceGrowth AS (
    SELECT
        customer_id,
        txn_year,
        txn_month,
        closing_balance,
        LAG(closing_balance) OVER (PARTITION BY customer_id ORDER BY txn_year, txn_month) AS prev_closing_balance
    FROM 
        ClosingBalances
),
IncreasedByMoreThan5Percent AS (
    SELECT
        customer_id
    FROM 
        BalanceGrowth
    WHERE 
        prev_closing_balance > 0 AND 
        (CASE 
            WHEN prev_closing_balance > 0 THEN 
                (closing_balance - prev_closing_balance) / prev_closing_balance 
            ELSE 0 
        END) > 0.05
    GROUP BY 
        customer_id
)
SELECT 
    (COUNT(DISTINCT IncreasedByMoreThan5Percent.customer_id) * 100.0) / COUNT(DISTINCT ClosingBalances.customer_id) AS percentage_of_customers
FROM 
    ClosingBalances
LEFT JOIN 
    IncreasedByMoreThan5Percent
ON 
    ClosingBalances.customer_id = IncreasedByMoreThan5Percent.customer_id;
