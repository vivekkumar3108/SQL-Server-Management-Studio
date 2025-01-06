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


