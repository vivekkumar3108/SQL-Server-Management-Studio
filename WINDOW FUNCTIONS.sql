SELECT * FROM Sales.Orders;

SELECT 
	OrderID, OrderDate, OrderStatus 
FROM Sales.Orders;

SELECT 
	OrderStatus, SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY OrderStatus;

SELECT 
	OrderStatus, SalesPersonID, SUM(Sales) 
FROM Sales.Orders 
GROUP BY OrderStatus, SalesPersonID -- ORDER BY SalesPersonID;

SELECT 
	OrderStatus, SalesPersonID, SUM(Sales) 
FROM Sales.Orders 
GROUP BY SalesPersonID, OrderStatus -- ORDER BY SalesPersonID;

-- WINDOW FUNCTIONS

SELECT OrderID, OrderDate, OrderStatus,
	RANK() OVER (ORDER BY ProductID) Ranking,
	DENSE_RANK() OVER (ORDER BY ProductID) DenseRank,
	ROW_NUMBER() OVER (ORDER BY ProductID) RowNbr,
	SUM(Sales) OVER(PARTITION BY OrderStatus) TotalSales,
	AVG(Sales) OVER(PARTITION BY OrderStatus) AverageSales,
	MIN(Sales) OVER(PARTITION BY OrderStatus) MinSales, 
	MAX(Sales) OVER(PARTITION BY OrderStatus) MaxSales,
	COUNT(Sales) OVER(PARTITION BY OrderStatus) CountSales
FROM Sales.Orders;


WITH SALES_TABLE AS(
SELECT OrderID, OrderDate, OrderStatus,
	SUM(Sales) OVER(PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders)

SELECT 
	*, DENSE_RANK() OVER (ORDER BY TotalSales) denserank
FROM SALES_TABLE;

SELECT OrderID, OrderDate, OrderStatus, Sales, SUM(Sales) OVER( ORDER BY OrderDate ROWS BETWEEN CURRENT ROW and 1 FOLLOWING ) CumSales FROM Sales.Orders;
															    
SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( ORDER BY OrderDate ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING ) CumSales 
FROM Sales.Orders;
															    
SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and 1 FOLLOWING ) CumSales 
FROM Sales.Orders;
															    
SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW ) CumSales 
FROM Sales.Orders;
															    
SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING ) CumSales 
FROM Sales.Orders;

--Beow query have same results as Order by uses given default frame always.

SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW ) CumSales 
FROM Sales.Orders;

SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate ) CumSales 
FROM Sales.Orders;

SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ) CumSales 
FROM Sales.Orders;

-- WINDOW Function can be only used with SELECT and ORDER BY. Above are the examples for SELECT. Now will See the examples for ORDER BY.

SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW ) CumSales 
FROM Sales.Orders
ORDER BY SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW );

SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW ) CumSales 
FROM Sales.Orders
ORDER BY CumSales;

--WINDOW function can not be used to filter data.

SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW ) CumSales 
FROM Sales.Orders
WHERE SUM(Sales) OVER( ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW) > 50;

--NESTED WINDOW Function is not allowed.

SELECT 
	OrderID, OrderDate, OrderStatus, Sales,
	SUM(SUM(Sales) OVER( PARTITION BY OrderStatus)) OVER( PARTITION BY OrderStatus) CumSales 
FROM Sales.Orders
ORDER BY CumSales;

--WINDOW FUNCTION is executed after WHERE CLAUSE

SELECT 
	OrderID, OrderDate, ProductID, OrderStatus, Sales,
	SUM(Sales) OVER( PARTITION BY OrderStatus) CumSales 
FROM Sales.Orders
WHERE ProductID IN (101,102)
ORDER BY CumSales;

--WINDOW Function can be used with the GROUP BY only if same columns are used.

		--RANK customers on thei Sales

	   SELECT 
	   CustomerID, SUM(Sales) as CutomerSales,
	   RANK() OVER(ORDER BY SUM(Sales) DESC) CutomerRank
	   FROM Sales.Orders
	   GROUP BY CustomerID;

	   SELECT 
	   CustomerID, SUM(Sales) as CutomerSales,
	   RANK() OVER(ORDER BY Sales DESC) CutomerRank
	   FROM Sales.Orders
	   GROUP BY CustomerID;
