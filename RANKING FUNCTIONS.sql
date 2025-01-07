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


