USE adashi_staging;

SELECT 
    u.id AS owner_id,
    CONCAT_WS(' ', u.first_name, u.last_name) AS name,
    s.savings_count,
    p.investment_count,
    ROUND((s.total_savings + p.total_investments) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN (
    SELECT 
        sa.owner_id, 
        COUNT(*) AS savings_count, 
        SUM(sa.confirmed_amount) AS total_savings
    FROM savings_savingsaccount sa
    JOIN plans_plan pp ON sa.plan_id = pp.id
    WHERE sa.confirmed_amount > 0 AND pp.is_regular_savings = 1
    GROUP BY sa.owner_id
) s ON s.owner_id = u.id
JOIN (
    SELECT 
        owner_id, 
        COUNT(*) AS investment_count, 
        SUM(amount) AS total_investments
    FROM plans_plan
    WHERE amount > 0 AND is_a_fund = 1
    GROUP BY owner_id
) p ON p.owner_id = u.id
ORDER BY total_deposits DESC;
