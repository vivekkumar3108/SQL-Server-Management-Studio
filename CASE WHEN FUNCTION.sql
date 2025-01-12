--Main purpose of case when is to derive a new column data based on existing one.

-- 1. Data categorization :- Group the data on dfferent category based on the condition.

SELECT Category, SUM(sales) TotalSales
FROM(
	SELECT
		orderid, sales,
		CASE
			WHEN sales>50 then 'HIGH'
			WHEN sales>30 then 'MEDIUM'
			ELSE 'LOW'
		END Category
	FROM Sales.Orders) t
GROUP BY Category
ORDER BY TotalSales;

-- Datatype muse be same for each case

SELECT
	orderid, sales,
	CASE
		WHEN sales>50 then 'HIGH'
		WHEN sales>30 then 3 -- will show error
		ELSE 'LOW'
	END Category
FROM Sales.Orders

-- 2. Mapping: Transform the value to another

SELECT 
	FirstName,LastName, Department, Gender,
	CASE
		WHEN Gender='M' then 'Male'
		WHEN Gender='F' then 'Female'
	END
FROM Sales.Employees;

-- Show the abbreivation of the country instead of full Name.

SELECT
	*,
	CASE
		WHEN Country = 'Germany' THEN 'GE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'N/A'
	END CountryAbbr
FROM Sales.Customers

-- If we case using case on same column everytime then we can use like below to reduce efforts.

SELECT
	*,
	CASE Country
		WHEN  'Germany' THEN 'GE'
		WHEN 'USA' THEN 'US'
		ELSE 'N/A'
	END CountryAbbr
FROM Sales.Customers

-- 3. Handling NULL

-- Find the avaerage score of customers, treeat NULL as 0.

SELECT
	*, 
	AVG(Score) OVER() AvgScoreWithNULL,
	AVG(
	CASE
		WHEN Score IS NULL THEN 0
		ELSE Score
	END
	)  OVER() AvgScoreWithHandledNULL
FROM Sales.Customers;

-- Count how many times each customer has made an order with sales greater than 30;

SELECT 
CustomerID, COUNT(*) TotalOrder,
	SUM(
	CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END
	) TotalOrderHighSales
FROM Sales.Orders
GROUP BY CustomerID;