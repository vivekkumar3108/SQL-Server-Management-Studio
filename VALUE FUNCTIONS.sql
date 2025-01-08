-- ANALYZE THE MONTH OVER MONTH PERFORMANCE BY FINDING CHANGE IN SALES PERCENTAGE

SELECT *, ROUND(CAST(( Curr_Month_Sales-Prev_Month_Sales ) AS FLOAT )/ Prev_Month_Sales * 100,2) MoM_Perc FROM
(SELECT
	MONTH(OrderDate) Months,
	SUM(Sales) Curr_Month_Sales,
	LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate)) Prev_Month_Sales
FROM Sales.Orders
GROUP BY MONTH(OrderDate)
)t;

--IN ORDER TO ANALYZE CUSTOMER LOYALITY RANK CUSTOMER BASED ON AVERAGE DAYS BETWEEN THIER ORDERS

SELECT 
	CustomerID,
	AVG(DaysUntilNextOrder) AverageOrderDays,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder),99999)) Ranking
FROM
	(SELECT
		CustomerID, OrderDate CurrentOrderDate,
		LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrderDate,
		DATEDIFF(DAY,OrderDate,LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM Sales.Orders
)t
GROUP BY CustomerID;