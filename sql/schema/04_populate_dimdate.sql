USE Retail_DW;
go

DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate DATE = '2026-12-31';

With DateSeries as (
	SELECT @StartDate as FullDate

	UNION ALL

	SELECT DATEADD(DAY , 1 , FullDate)
	FROM DateSeries
	WHERE FullDate < @EndDate
)
INSERT INTO DW.DimDate
(
    DateKey,
    FullDate,
    Year,
    Quarter,
    Month,
    MonthName,
    Day,
    DayOfWeekNumber
)
SELECT
    YEAR(FullDate) * 10000 + MONTH(FullDate) * 100 + DAY(FullDate) AS DateKey,
    FullDate,
    YEAR(FullDate) AS Year,
    DATEPART(QUARTER, FullDate) AS Quarter,
    MONTH(FullDate) AS Month,
    DATENAME(MONTH, FullDate) AS MonthName,
    DAY(FullDate) AS Day,
    DATEPART(WEEKDAY, FullDate) AS DayOfWeekNumber
FROM DateSeries
OPTION (MAXRECURSION 0)
Go

SELECT MIN(FullDate) AS MinDate, MAX(FullDate) AS MaxDate, COUNT(*) AS TotalDays
FROM DW.DimDate;