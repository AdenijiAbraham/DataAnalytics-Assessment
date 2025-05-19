USE adashi_staging;

WITH transactions_per_user AS (
    SELECT 
        sa.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(sa.created_on), MAX(sa.created_on)) + 1 AS active_months
    FROM savings_savingsaccount sa
    JOIN plans_plan p ON sa.plan_id = p.id
    WHERE sa.confirmed_amount > 0
      AND p.is_regular_savings = 1
    GROUP BY sa.owner_id
),
average_transactions AS (
    SELECT
        t.owner_id,
        CONCAT_WS(' ', u.first_name, u.last_name) AS name,
        t.total_transactions,
        t.active_months,
        t.total_transactions / NULLIF(t.active_months, 0) AS avg_transactions_per_month,
        CASE 
            WHEN t.total_transactions / NULLIF(t.active_months, 0) >= 10 THEN 'High Frequency'
            WHEN t.total_transactions / NULLIF(t.active_months, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM transactions_per_user t
    JOIN users_customuser u ON u.id = t.owner_id
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM average_transactions
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;
