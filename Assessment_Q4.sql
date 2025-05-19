use adashi_staging;

SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (0.012 * SUM(s.confirmed_amount) / 100) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0), 
        2
    ) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
JOIN plans_plan p ON s.plan_id = p.id
WHERE p.is_regular_savings = 1
  AND s.confirmed_amount IS NOT NULL
GROUP BY u.id, name
ORDER BY estimated_clv DESC;
