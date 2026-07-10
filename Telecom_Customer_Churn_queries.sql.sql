========================================================================================
--Telecom Customer Churn Analysis 
--PostgreSQL
--Author : Srushti Telang
========================================================================================

--1) Find total number of customers in the dataset--
SELECT COUNT(*) AS total_customers
FROM customer_churn

--2) Find how many customers have churned--
SELECT COUNT(*) AS churned_customer
FROM customer_churn
WHERE "Churn" = 'Yes';

--3) Calculate overall churn rate (percentage of customers who left)--

SELECT 
     COUNT(*) AS total_customers,
	 SUM(CASE WHEN "Churn" = 'Yes' THEN 1
	 ELSE 0 END) AS churned_customers,
	 ROUND(100.0 * SUM(CASE WHEN "Churn" = 'Yes' THEN 1
	 ELSE 0 END) / COUNT(*),2) AS churn_rate 
FROM customer_churn

--4) Analyze churn based on contract type--

SELECT "Contract",
Count(*) AS total_customers,
SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY "Contract";

--5) Analyze churn across different customer tenure groups--

SELECT tenure,
COUNT(*) AS total_customers,
SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY tenure;

--6) Analyze churn based on monthly spending levels--

SELECT "MonthlyChargeLevel",
COUNT(*) AS total_customers,
SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY "MonthlyChargeLevel";

--7) Analyze churn based on payment method--

SELECT "PaymentMethod",
COUNT(*) AS total_customers,
SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY "PaymentMethod";

--8) Analyze churn behaviour of senior citizen vs non senior customers--

SELECT "SeniorCitizen",
COUNT(*) AS total_customers,
SUM(CASE WHEN "Churn" = 'Yes' THEN 1 ELSE 0 END) AS churned_customers
FROM customer_churn
GROUP BY "SeniorCitizen";

--9) Compare average monthly and total charges for churned vs retained customers--

ALTER TABLE customer_churn
ALTER COLUMN "TotalCharges" TYPE numeric
USING NULLIF(TRIM("TotalCharges"), '')::numeric;

SELECT 
       "Churn",
       ROUND(AVG("MonthlyCharges")::numeric, 2) AS avg_monthly_charges,
       ROUND(AVG("TotalCharges"), 2) AS avg_total_charges
FROM customer_churn
GROUP BY "Churn";

--10) Revenue lost due to churn --

SELECT 
       ROUND(SUM("MonthlyCharges")::numeric, 2) 
       AS estimated_monthly_revenue_lost
FROM customer_churn
WHERE "Churn"='Yes';