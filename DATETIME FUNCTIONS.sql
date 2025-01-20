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

-- FORMAT:- Used to format date in various format


SELECT
	OrderID,CreationTime,
	FORMAT(CreationTime, 'MM-dd-yyyy') USA_Format,
	FORMAT(CreationTime, 'dd-MM-yyyy') EURO_Format,
	FORMAT(CreationTime, 'dd') dd,
	FORMAT(CreationTime, 'ddd') ddd,
	FORMAT(CreationTime, 'dddd') dddd,
	FORMAT(CreationTime, 'MM') MM,
	FORMAT(CreationTime, 'MMM') MMM,
	FORMAT(CreationTime, 'MMMM') MMMM,
	FORMAT(CreationTime, 'tt') tt
FROM Sales.Orders;

--Show CreationTime in Given Format. Day Wed Jan Q1 2025 12:34:56 PM

SELECT
	OrderID,CreationTime,
	'Day ' + FORMAT(CreationTime, 'ddd MMM') + ' Q'
	+ DateName(QUARTER,CreationTime) + ' ' + FORMAT(CreationTime,'yyyy HH:mm:ss tt') CustomFormat
FROM Sales.Orders;

SELECT
	FORMAT(OrderDate, 'yyyy-MMM') [YYYY-MMM], Count(*) Total
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'yyyy-MMM');