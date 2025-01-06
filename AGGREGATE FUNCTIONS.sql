-----------------------------------COUNT----------------------------------------------

SELECT 
	COUNT(Sales) CountSales
FROM Sales.Orders;

SELECT OrderID, OrderDate, OrderStatus, CustomerID,
	COUNT(Sales) OVER() CountSales
FROM Sales.Orders;

SELECT OrderID, OrderDate, OrderStatus, CustomerID,
	COUNT(Sales) OVER(PARTITION BY CustomerID) CountSales
FROM Sales.Orders;

-- COUNT(*) or COUNT(1) includes the NULL also but Count(Column_Name) dont count NULL Values

SELECT 
	*
FROM Sales.Customers;

SELECT 
	COUNT(*) CutomerCount, COUNT(LastName) CutomerLastNameCount
FROM Sales.Customers;

--To check data quality we check NULL/BLANK Values present in any columns. also we see if records are duplicated based on PrimaryKey.

SELECT 
	*, COUNT(*) OVER() CutomerCount, COUNT(LastName)  OVER() CutomerLastNameCount
FROM Sales.Customers;

SELECT 
	*, COUNT(*) OVER(PARTITION BY OrderID ) PrimaryKeyCount
FROM Sales.Orders;

SELECT * FROM (
	SELECT 
		*, COUNT(*) OVER(PARTITION BY OrderID) PrimaryKeyCount
	FROM Sales.OrdersArchive) t
WHERE PrimaryKeyCount > 1 ;

-----------------------------------SUM----------------------------------------------

SELECT 
	*, SUM(Sales) OVER(PARTITION BY CustomerID) CustomerSalesSum
FROM Sales.Orders;

SELECT 
	*, SUM(Sales) OVER(PARTITION BY CustomerID) CustomerSalesSum,
	ROUND (CAST (Sales AS FLOAT) / SUM(Sales) OVER(PARTITION BY CustomerID) * 100, 2) SalesPercentage
FROM Sales.Orders;

---------------------------------AVG----------------------------------------------
SELECT 
	*, AVG(Sales) OVER() CustomerSalesAvg
FROM Sales.Orders;

SELECT 
	*, AVG(Sales) OVER(PARTITION BY OrderStatus) CustomerSalesAvg
FROM Sales.Orders;

SELECT 
	*, AVG(Sales) OVER(PARTITION BY OrderStatus ORDER BY ShipDate DESC) CustomerSalesAvg , 
	RANK() OVER(PARTITION BY OrderStatus ORDER BY ProductID) 
FROM Sales.Orders;

SELECT 
	*,
	AVG(Sales) OVER()SalesAvg,
	AVG(Sales) OVER(PARTITION BY ProductID) ProductSalesAvg
FROM Sales.Orders;


--If you see here is Score is having NULL value and AVG is taken for 4 not 5 so for that we have to define it as 0.

SELECT
CustomerID, FirstName, LastName, Score,
COALESCE(Score,0) CustomerScore,
AVG(COALESCE(Score,0)) OVER() AvgScore
FROM Sales.Customers;

--Sales higher than Average Sale using CTE
WITH AVG_TABLE AS
(SELECT
	CustomerID, FirstName, LastName, Score,
	COALESCE(Score,0) CustomerScore,
	AVG(COALESCE(Score,0)) OVER() AvgScore
FROM Sales.Customers)

SELECT * FROM AVG_TABLE WHERE CustomerScore > AvgScore;


--Sales higher than Average Sale using Sub Query

SELECT * FROM 
	(SELECT
	CustomerID, FirstName, LastName, Score,
	COALESCE(Score,0) CustomerScore,
	AVG(COALESCE(Score,0)) OVER() AvgScore
	FROM Sales.Customers) AVG_TABLE
WHERE CustomerScore > AvgScore;

-- WRONG QUERY USING GROUP BY as CustomerScore and AvgCustomerScore is Valculated ABove and Cant be used in WHERE CLAUSE. Also Agggregate Function also 
-- Can bot be used under WHERE CLAUSE

SELECT
	CustomerID, Score,
	COALESCE(Score,0) CustomerScore,
	AVG(COALESCE(Score,0)) AvgCustomerScore
FROM Sales.Customers
WHERE CustomerScore > AvgCustomerScore;


----- Achieving Same using SUB QUERY in WHERE CALUSE

SELECT 
    CustomerID, 
    Score,
    COALESCE(Score, 0) AS CustomerScore
FROM 
    Sales.Customers
WHERE 
    COALESCE(Score, 0) > (
        SELECT AVG(COALESCE(Score, 0)) 
        FROM Sales.Customers
    );

----------------------------------MIN() and MAX() ------------------------------------------

SELECT
	OrderDate, OrderID, OrderStatus, Sales,
	MAX(Sales) OVER() MaxSale,
	MIN(Sales) OVER() MinSale,
	MAX(Sales) OVER(PARTITION BY ProductID) MaxProductSale,
	MIN(Sales) OVER(PARTITION BY ProductID) MinProductSale
FROM Sales.Orders;

---- Find the employee having highest salary

SELECT * FROM
(SELECT
	*, 
	MAX(Salary) OVER() MaxSalary
FROM Sales.Employees) SubQuery
WHERE Salary = MaxSalary;

-- Find the deviation from MAX and MIN Sales

SELECT
	OrderDate, OrderID, OrderStatus, Sales,
	MAX(Sales) OVER() MaxSale,
	MIN(Sales) OVER() MinSale,
	MAX(Sales) OVER() - Sales MaxDeviation,
	Sales - MIN(Sales) OVER() MinDeviation
FROM Sales.Orders;

---RUNNING TOTAL means Unbounded Preceding to Current Row and ROLLING TOTAL means For a Fixed Interval for example For last 2 Months

--  Calculate Moving Average of total sales for each product over period of time

SELECT
	OrderDate, OrderID, OrderStatus, ProductID, Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesByProduct,
	AVG(Sales) OVER( PARTITION BY ProductID ORDER BY OrderDate) MovingAvgSalesByProduct
FROM Sales.Orders;

--  Calculate Moving Average of total sales for each product over period of time including only the next order

SELECT
	OrderDate, OrderID, OrderStatus, ProductID, Sales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesByProduct,
	AVG(Sales) OVER( PARTITION BY ProductID ORDER BY OrderDate) MovingAvgSalesByProduct,
	AVG(Sales) OVER( PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING ) MovingAvgSalesByProductbyNext
FROM Sales.Orders;


