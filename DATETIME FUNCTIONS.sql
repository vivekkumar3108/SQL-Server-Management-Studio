SELECT
GETDATE() TODAY;


--DATENAME present more readale way than DATEPART, as it returns String.

SELECT
	OrderID, OrderDate, CreationTime,
	YEAR(OrderDate) Year,
	MONTH(OrderDate) Month,
	DAY(OrderDate) Day,
	DATEPART(YEAR,CreationTime) DatePartYear,
	DATEPART(MONTH,CreationTime) DatePartMonth,
	DATEPART(DAY,CreationTime) DatePartDay,
	DATEPART(HOUR,CreationTime) Hour_DP,
	DATEPART(QUARTER,CreationTime) Quater_DP,
	DATEPART(WEEK,CreationTime) Week_DP,
	DATEPART(WEEKDAY,CreationTime) Weekday_DP,
	DATENAME(WEEKDAY,CreationTime) DayName,
	DATENAME(MONTH,CreationTime) MonthName
	,DATENAME(DAY,CreationTime) Day_DN --returns string instead of integer 
	,DATENAME(YEAR,CreationTime) Year_DN --returns string instead of integer 
FROM Sales.Orders;


-- DATETRUNC:- used to truncate or round down a DATE, DATETIME, or TIMESTAMP to a specific unit of time such as year, quarter, month, day, hour, minute, etc.
--             can be used in group by to aggregate on specific date part.

SELECT
	OrderID, CreationTime,
	DATETRUNC(YEAR,CreationTime) YearLevel_DT,
	DATETRUNC(MONTH,CreationTime) MonthLevel_DT,
	DATETRUNC(DAY,CreationTime) DayLevel_DT,
	DATETRUNC(HOUR,CreationTime) HourLevel_DT,
	DATETRUNC(MINUTE,CreationTime) MinuteLevel_DT,
	DATETRUNC(SECOND,CreationTime) SecondLevel_DT
FROM Sales.Orders;

