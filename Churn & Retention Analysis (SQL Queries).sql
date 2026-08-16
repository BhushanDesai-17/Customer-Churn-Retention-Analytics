SELECT *
FROM customers_cleaned;

SELECT *
FROM subscriptions_cleaned;

SELECT *
FROM supporttickets_cleaned;

-- CUSTOMERS
-- Total Customers
SELECT COUNT(CustomerID) AS Total_Customers
FROM customers_cleaned;

-- Churned Customers
SELECT COUNT(Churn) 
FROM customers_cleaned
WHERE Churn = 'Yes';

-- Churned Rate %
SELECT 
		ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
        / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned;

-- Retention Rate %
SELECT 
		ROUND(COUNT(CASE WHEN Churn = 'No' THEN 1 END) * 100
        / COUNT(*), 2) AS Retention_Rate
FROM customers_cleaned;

-- Average Customer Satisfaction
SELECT ROUND(AVG(SatisfactionScore), 1) AS Avg_Satisfaction
FROM customers_cleaned;

-- Churn Rate by Plan
SELECT Plan,
		ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
        / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY Plan
ORDER BY Churn_Rate DESC;

-- Churn Rate by Country
SELECT Country,
		ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
        / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY Country
ORDER BY Churn_Rate DESC;

-- Churn Rate by Contract Type
SELECT s.ContractType,
		ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
        / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned AS c
INNER JOIN subscriptions_cleaned AS s
ON c.CustomerID = s.CustomerID
GROUP BY s.ContractType
ORDER BY Churn_Rate DESC;

-- Churn by Acquisition Channel
SELECT AcquisitionChannel,
		ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
        / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY AcquisitionChannel
ORDER BY Churn_Rate DESC;

-- Churn Rate by Monthly Usage
SELECT 
	CASE 
		WHEN AvgMonthlyUsageHours < 10 THEN 'Low Usage'
        WHEN AvgMonthlyUsageHours BETWEEN 10 AND 30 THEN 'Medium Usage'
        ELSE 'High Usage'
	END AS Avg_Monthly_Usage_Hours,
    ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
    / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY 
		CASE
			WHEN AvgMonthlyUsageHours < 10 THEN 'Low Usage'
            WHEN AvgMonthlyUsageHours BETWEEN 10 AND 30 THEN 'Medium Usage'
            ELSE 'High Usage'
		END
ORDER BY Churn_Rate DESC;

-- Churn Rate by Tenure Months
SELECT 
	CASE
		WHEN TenureMonths BETWEEN 0 AND 6 THEN '0-6 Months'
        WHEN TenureMonths BETWEEN 7 AND 12 THEN '7-12 Months'
        WHEN TenureMonths BETWEEN 13 AND 24 THEN '13-24 Months'
        ELSE '25+ Months'
	END AS Tenure_Months,
    ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
    / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY
	CASE
		WHEN TenureMonths BETWEEN 0 AND 6 THEN '0-6 Months'
        WHEN TenureMonths BETWEEN 7 AND 12 THEN '7-12 Months'
        WHEN TenureMonths BETWEEN 13 AND 24 THEN '13-24 Months'
        ELSE '25+ Months'
	END 
ORDER BY Churn_Rate DESC;

-- Churn Rate by Last Login Recency
SELECT 
	CASE
		WHEN LastLoginDaysAgo BETWEEN 0 AND 30 THEN '0-30 Days'
        WHEN LastLoginDaysAgo BETWEEN 31 AND 60 THEN '31-60 Days'
        WHEN LastLoginDaysAgo BETWEEN 61 AND 90 THEN '61-90 Days'
        ELSE '90+ Days'
	END AS Last_Login_Recency,
    ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
    / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY 
	CASE
		WHEN LastLoginDaysAgo BETWEEN 0 AND 30 THEN '0-30 Days'
        WHEN LastLoginDaysAgo BETWEEN 31 AND 60 THEN '31-60 Days'
        WHEN LastLoginDaysAgo BETWEEN 61 AND 90 THEN '61-90 Days'
        ELSE '90+ Days'
	END
ORDER BY Churn_Rate DESC;

-- Churn Rate by Satisfaction Score
SELECT 
	CASE
		WHEN SatisfactionScore BETWEEN 1 AND 4 THEN 'Low Satisfaction'
        WHEN SatisfactionScore BETWEEN 5 AND 8 THEN 'Medium Satisfaction'
        ELSE 'High Satisfaction'
	END AS Customer_Satisfaction_Score,
    ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
    / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY 
	CASE
		WHEN SatisfactionScore BETWEEN 1 AND 4 THEN 'Low Satisfaction'
        WHEN SatisfactionScore BETWEEN 5 AND 8 THEN 'Medium Satisfaction'
        ELSE 'High Satisfaction'
	END
ORDER BY Churn_Rate DESC;

-- Auto-Renewal vs Churn
SELECT AutoRenew,
	ROUND(COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100
    / COUNT(*), 2) AS Churn_Rate
FROM customers_cleaned
GROUP BY AutoRenew
ORDER BY Churn_Rate DESC;

-- Subscription Status Distribution
SELECT Status AS subscription_status, 
		COUNT(*) AS total_subscription
FROM subscriptions_cleaned
GROUP BY subscription_status
ORDER BY total_subscription DESC;

-- Contract Type Performance
SELECT s.ContractType AS contract_type,
	ROUND(COUNT(DISTINCT CASE WHEN Churn = 'Yes' THEN c.CustomerID END) * 100
    / COUNT(*), 2) AS churn_rate
FROM customers_cleaned AS c
INNER JOIN subscriptions_cleaned AS s
ON c.CustomerID = s.CustomerID 
GROUP BY contract_type
ORDER BY churn_rate DESC;

-- Discount % vs Retention
SELECT 
	CASE 
		WHEN s.DiscountPct <=5 THEN ' Very Low Discount'
        WHEN s.DiscountPct <=10 THEN 'Low Discount'
        WHEN s.DiscountPct <=15 THEN 'Medium Discount'
        ELSE 'High Discount'
	END AS discount_distribution,
    ROUND(COUNT(DISTINCT CASE WHEN c.Churn = 'No' THEN c.CustomerID END) * 100
    / COUNT(DISTINCT c.CustomerID), 2) AS retention_rate
FROM customers_cleaned AS c
INNER JOIN subscriptions_cleaned AS s
ON c.CustomerID = s.CustomerID
GROUP BY discount_distribution
ORDER BY retention_rate DESC;

-- Support Tickets by Issue Type
SELECT IssueType, COUNT(TicketID) AS issue_type
FROM supporttickets_cleaned
GROUP BY IssueType
ORDER BY issue_type DESC;

-- Average Resolution Days by Issue Type
SELECT IssueType, ROUND(AVG(ResolutionDays), 2) AS avg_resolution_days
FROM supporttickets_cleaned
GROUP BY IssueType
ORDER BY avg_resolution_days DESC;
