-- SYNTAX
-- ISNULL(value,replacement_value)
-- COALESCE(value1, value2, value3,...........)
-- NULLIF(value1,value2) --> retuns NULL if value1 and value2 are equal else value1
-- IS NULL/ IS NOT NULL

-- Find the avergae score of all the customers.

SELECT 
	CustomerID,
	AVG(Score) OVER() AvgScore1,
	AVG(COALESCE(Score,0)) OVER() AvgScore2
FROM Sales.Customers;

-- Display The Customer Full Name in Single field and assign 10 extra point in score.

SELECT
*,
FirstName+ ' '+ LastName FullName,
Score + 10 AS NewScore
FROM Sales.Customers; --> Not able to concat or add when NULL is present as NULL is undefined, so calculation/aggregations can not be performed.

SELECT
*,
COALESCE(FirstName,'')+ ' '+ COALESCE(LastName,'') FullName,
COALESCE(Score,0) + 10 AS NewScore
FROM Sales.Customers;

--Sorting Data with NULLs appering last

Select 
	CustomerID, Score
FROM Sales.Customers
Order by Score ;

Select 
	CustomerID, Score
FROM Sales.Customers
Order by ISNULL(Score,999999);

-- OR without using COALESCE or ISNULL

Select 
	CustomerID, Score
FROM Sales.Customers
Order by CASE WHEN Score IS NULL THEN 1 ELSE 0 END , Score;


--NULLIF - Prevent diivde by zero error.

-- Find the sales price for each order divind it by quantitiy.

SELECT
	OrderID, Sales, Quantity, Sales/Quantity
FROM Sales.Orders;

SELECT
	OrderID, Sales, Quantity, Sales/NULLIF(Quantity,0) Price
FROM Sales.Orders

-- Identify the customers who have no score

SELECT
CustomerID
FROM Sales.Customers
WHERE Score IS NULL;

SELECT
CustomerID
FROM Sales.Customers
WHERE Score IS NOT NULL;

-- IS NULL Case :- ANTI JOIN

-- List all the customers who haven't placed any orders yet.

SELECT c.*,o.CustomerID FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

--NULL POLICY

WITH ORDERS AS(
SELECT 1 Id,  'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  ' 
)
SELECT *,
	TRIM(Category) POLICY1,
	NULLIF(TRIM(Category),'') POLICY2,
	COALESCE(NULLIF(TRIM(Category),''), 'unknown') POLICY2
FROM ORDERS;