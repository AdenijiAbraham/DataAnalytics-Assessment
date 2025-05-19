# DataAnalytics-Assessment


SQL Queries Documentation – Adashi Staging Analytics
This document explains the purpose, logic, and structure of the SQL queries used for analyzing user behavior and transactions in the adashi_staging database.

🔄 Table Relationships Overview
savings_savingsaccount.plan_id → plans_plan.id (savings transactions linked to plans)

savings_savingsaccount.owner_id → users_customuser.id (user that performed the transaction)

plans_plan.owner_id → users_customuser.id

withdrawals_withdrawal.owner_id → users_customuser.id

✅ Query 1: Frequency Categorization of Regular Savings Users
Objective: Identify how frequently users perform savings transactions on regular savings plans and group them into categories (High, Medium, Low).

Summary:
Filters savings accounts with confirmed inflows (confirmed_amount > 0)

Filters only regular savings (is_regular_savings = 1) via join with plans_plan

Groups by user and calculates:

Total transactions

Active months

Average transactions per month

Frequency category

Output:
Frequency Category	Number of Users	Average Monthly Transactions
High Frequency	10+ transactions/month	
Medium Frequency	3–9 transactions/month	
Low Frequency	< 3 transactions/month	

✅ Query 2: Inactive Plans – Savings and Investments
Objective: Identify users with no activity in over a year in either savings or investment plans.

Savings Logic:
Join savings_savingsaccount with plans_plan to filter for is_regular_savings = 1

Group by plan and user

Check if MAX(transaction_date) is over 365 days ago

Investment Logic:
Select from plans_plan where is_a_fund = 1

Use last_charge_date to detect inactivity over 365 days

Output:
plan_id	owner_id	type	last_transaction_date	inactivity_days
101	205	Savings	2022-04-01	780
108	309	Investment	2021-12-12	890

🔍 General Notes
Monetary Fields: All amount-related fields (e.g., confirmed_amount, amount_withdrawn) are stored in kobo, not naira. Divide by 100 if needed for currency presentation.

Time Calculations: DATEDIFF() and TIMESTAMPDIFF() are used to compute durations in days or months.

Null-Safe Math: NULLIF(..., 0) ensures division by zero is avoided when calculating averages.

📁 Tables Used
plans_plan
Stores metadata about savings and investment plans.

Key fields:

is_regular_savings: Identifies a savings plan.

is_a_fund: Identifies an investment plan.

last_charge_date: Last activity timestamp for investment plans.

savings_savingsaccount
Records inflow transactions tied to plans and users.

Key fields:

confirmed_amount: Value of deposit.

transaction_date: Timestamp of transaction.

owner_id: User making the transaction.

users_customuser
User profile and identity.

withdrawals_withdrawal
Tracks withdrawal history 
