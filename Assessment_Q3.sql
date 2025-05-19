USE adashi_staging;

-- Inactive Savings Users (no transactions in over 365 days)
SELECT
    sa.plan_id,
    sa.owner_id,
    'Savings' AS type,
    MAX(sa.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
FROM savings_savingsaccount sa
JOIN plans_plan p ON sa.plan_id = p.id
WHERE p.is_regular_savings = 1
GROUP BY sa.plan_id, sa.owner_id
HAVING last_transaction_date IS NOT NULL
   AND inactivity_days > 365

UNION

-- Inactive Investment Users (no charge in over 365 days)
SELECT
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    p.last_charge_date AS last_transaction_date,
    DATEDIFF(CURDATE(), p.last_charge_date) AS inactivity_days
FROM plans_plan p
WHERE p.is_a_fund = 1
  AND p.last_charge_date IS NOT NULL
  AND DATEDIFF(CURDATE(), p.last_charge_date) > 365;
