--------------------------------------------UNION and UNION ALL----------------------------------
--COMBINE CUTOMER AND EMPLOYEE INFORMATION AT ONE TABLE and REMOVE ALL DUPLICATES IF ANY

SELECT  
	FirstName, LastName
FROM Sales.Customers
UNION
SELECT 
	FirstName, LastName
FROM Sales.Employees;

-- IF YOU ARE CONFIDENT THAT NO DUPLICATES AE THERE USE UNION ALL
-- USE UNION ALL TO FIND DATA QUALITY AND DUPLICATE ISSUES

SELECT  
	FirstName, LastName
FROM Sales.Customers
UNION ALL
SELECT 
	FirstName, LastName
FROM Sales.Employees;

----------------------------------EXCEPT--------------------------------------

--Return all the distinct row from first query that are not in second query.
--Order of Query Affects the Results
--USED TO CHECK DATA COMPLETNESS - EX:- AFTER DATA MIGRAION TO CHECK IF ALL DATA IS CORRECTLY MIGRATED OR NOT.

SELECT  
	FirstName, LastName
FROM Sales.Customers
EXCEPT
SELECT 
	FirstName, LastName
FROM Sales.Employees;


SELECT 
	FirstName, LastName
FROM Sales.Employees
EXCEPT
SELECT  
	FirstName, LastName
FROM Sales.Customers;


----------------------------INTERSECT-------------------------

--Return only those rows that are command in both table.

SELECT 
	FirstName, LastName
FROM Sales.Employees
INTERSECT
SELECT  
	FirstName, LastName
FROM Sales.Customers;


--ORDERS are kept in tow table Order and OrderArchive, Combine all table into one without having duplicates.

SELECT * FROM Sales.Orders
UNION
SELECT * FROM Sales.OrdersArchive;

--AVOID USING * ON UNION AS COLUMN POSITION MAY BE CHANGED.

SELECT 
	'ORDER' SOURCE,
	[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM Sales.Orders
UNION
SELECT
	'ORDERARCHIVE' SOURCE,
	[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM Sales.OrdersArchive;
