--ROW_NUMBER does not handle ties in ranking, it have UNIQUE RANKS.
--RANK and DENSE_RANK handles ties in ranking, it have SHARED RANKS.
--RANK leaves gaps in ranking position if ties but DESNE_RANK doesn't.

SELECT
	OrderID, ProductID, CustomerID , Sales,
	ROW_NUMBER() OVER( ORDER BY Sales DESC) ROW_NMBR,
	RANK() OVER( ORDER BY Sales DESC) RNK,
	DENSE_RANK() OVER( ORDER BY Sales DESC) DNS_RNK
FROM Sales.Orders;

--USE CASE -> TOP N Analaysis

-- Find the top higest sales for each product

SELECT * FROM(
SELECT
	ProductID, Sales,
	ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) ranks
FROM Sales.Orders) t
WHERE ranks=1;

-- Find the lowest 2 customers based on thier sales.

SELECT * FROM
( SELECT 
	CustomerID,
	SUM(Sales) totalsales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales)) salesrank
FROM Sales.Orders
GROUP BY CustomerID ) t
WHERE salesrank<=2;

-- USE CASE -> ASSIGN UNIQUE IDs
-- Assigning unique identifier for each row to help paginating

--Paginating -> Process of breaking down large data into small and managable chunks

SELECT
	ROW_NUMBER() OVER(ORDER BY ORDERID, ORDERDATE) UNIQ_ID, *
FROM Sales.OrdersArchive;


-- Identify Duplicate data in Table Archive and return a clean results without any duplicates.

--NON DUPLICATE RECORDS

SELECT * FROM(
SELECT
	ROW_NUMBER() OVER(PARTITION BY ORDERID ORDER BY CREATIONTIME DESC) RowNum, *
FROM Sales.OrdersArchive) t 
WHERE RowNum = 1;

--DUPLICATE RECORDS

SELECT * FROM(
SELECT
	ROW_NUMBER() OVER(PARTITION BY ORDERID ORDER BY CREATIONTIME DESC) RowNum, *
FROM Sales.OrdersArchive) t 
WHERE RowNum > 1;


----------------------------------------NTILE------------------------------------------------

--Divides the data into Specified Number of Approximately equal group ka BUCKETS.
-- SQL RULE:-  Larger Group Comes First

SELECT 
 OrderDate,OrderID,
 NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
 NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket,
 NTILE(4) OVER(ORDER BY Sales DESC) FourBucket
FROM Sales.Orders;


-- NTILE Use Cases:-
-- Data Analyst --> Data Segmentation : Divide a dataset into distince subset based on criteria.
-- Data Engineer -> Equalising Load Process


--Segment all orders into 3 category, High Medium and Low.

SELECT *,
CASE
	WHEN Bucket = 1 THEN 'HIGH'
	WHEN Bucket = 2 THEN 'MEDIUM'
	WHEN Bucket = 3 THEN 'LOW'
END SalesSegmentation
FROM
(SELECT
	OrderID, Sales,
	NTILE(3) OVER(ORDER BY SALES) Bucket
From Sales.Orders) t;





