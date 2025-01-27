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


--FORMAT() -> Helps to change the data type of a value and at same time changes the format.

SELECT 
	CONVERT(INT,'1234') [String to Int],
	CONVERT(DATE,'2025-08-31') [String to Date],
	CONVERT(DATETIME, '2034-09-08') [String to DateTime];

SELECT
	CreationTime,
	CONVERT(DATE, CreationTime) [DateTime to Date],
	CONVERT(VARCHAR, CreationTime, 32) [DateTime to Varchar:32],
	CONVERT(VARCHAR, CreationTime, 34) [DateTime to Varchar:34],
	CONVERT(VARCHAR, CreationTime, 101) [DateTime to Varchar:101],
	CONVERT(VARCHAR, CreationTime, 102) [DateTime to Varchar:102]
FROM Sales.Orders;

--CAST :- Convert one Datatype to Other.
--SYNTAX: CAST( Value As DataType)

SELECT
	CAST('123' AS INT) [Cast STRING to INT],
	CAST(123 AS VARCHAR) [Cast INT to STRING],
	CreationTime,
	CAST(CreationTime AS DATE) [Cast CreationTime to DATE],
	CAST('2024-09-15' AS DATETIME) [Cast DATE to DATETIME]
FROM Sales.Orders;

--DATEADD :- used to add/subtract day/month/year/hour/minute/second from DATETIME
--SYNTAX :- DATEADD(Part,Interval,Date)

SELECT
	CreationTime,
	DATEADD(Year,2,CreationTime) [2 Year Later],
	DATEADD(Month,2,CreationTime) [2 Month Later],
	DATEADD(day,2,CreationTime) [2 Days Later],
	DATEADD(Year,-2,CreationTime) [2 Year Before],
	DATEADD(Month,-2,CreationTime) [2 Month Before],
	DATEADD(day,-2,CreationTime) [2 Days Before],
	DATEADD(HOUR,-2,CreationTime) [2 Hours Before],
	DATEADD(MINUTE,-2,CreationTime) [2 Minute Before],
	DATEADD(SECOND,-2,CreationTime) [2 Second Before],	
	DATEADD(HOUR,2,CreationTime) [2 Hours Before],
	DATEADD(MINUTE,2,CreationTime) [2 Minute Before],
	DATEADD(SECOND,2,CreationTime) [2 Second Before]
FROM Sales.Orders;


--DATEDIFF :- use to find the difference between two dates, in terms of year, month, day
--Usage:- DATEDIFF(part,start_date, end_date)

--Calculate Age of Employees

SELECT
	EmployeeID,FirstName,BirthDate, CONVERT(DATE,GETDATE()) AgeAsOf,
	DATEDIFF(YEAR,BirthDate,GETDATE()) Age 
FROM Sales.Employees;

--Find average shipping duration in Days for each month

SELECT
	DATEPART(MONTH,OrderDate) Month,AVG(DATEDIFF(DAY,OrderDate,ShipDate)) AvgDays
FROM Sales.Orders
GROUP BY DATEPART(MONTH,OrderDate);

SELECT
	MONTH(OrderDate) Month,AVG(DATEDIFF(DAY,OrderDate,ShipDate)) AvgDays
FROM Sales.Orders
GROUP BY DATEPART(MONTH,OrderDate);

--TIMEGAP Analysis
--Find the No. of Days Between Previous Order and Each Order

SELECT 
	OrderID, DATEDIFF(DAY,PrevOrderDate,OrderDate) GapInDays
FROM (
		SELECT
			OrderID, OrderDate, LAG(OrderDate) OVER(Order by OrderDate) PrevOrderDate
		FROM Sales.Orders
	) t;


--ISDATE -> check if given input is date or not

SELECT ISDATE('123'),
ISDATE('2024-12-31')


SELECT 
	--CAST(OrderDate as DATE) OrderDate
	ORDER_DATE, ISDATE(ORDER_DATE),
	CASE WHEN ISDATE(ORDER_DATE) = 1 THEN CAST(ORDER_DATE AS DATE)  
	ELSE '9999-12-31' END NEW_ORDER_DATE
	FROM
	(
		SELECT '2025-08-31' AS ORDER_DATE
		UNION
		SELECT '2025-08-32' UNION
		SELECT '2025-08-23' UNION
		SELECT '2025' UNION
		SELECT '08' UNION
		SELECT '2025-08'
	)t;