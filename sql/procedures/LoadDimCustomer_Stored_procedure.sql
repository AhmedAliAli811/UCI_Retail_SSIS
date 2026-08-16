CREATE PROCEDURE ETL.usp_LoadDimCustomerSCD2
    @RunID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CustomerID VARCHAR(15), @Country VARCHAR(30), @ChangeDate DATE;
    DECLARE @CurrentKey INT, @CurrentCountry VARCHAR(30);

    ;WITH Ordered AS (
        SELECT
            CustomerID,
            Country,
            CAST(InvoiceDate AS DATE) AS EventDate,
            LAG(Country) OVER (PARTITION BY CustomerID ORDER BY CAST(InvoiceDate AS DATE)) AS PrevCountry
        FROM Retail_Staging.Staging.SalesRaw
        WHERE RunID = @RunID
          AND CustomerID IS NOT NULL
          AND LTRIM(RTRIM(CustomerID)) <> ''
    ),
    Grouped AS (
        SELECT *,
            SUM(CASE WHEN Country = PrevCountry THEN 0 ELSE 1 END)
                OVER (PARTITION BY CustomerID ORDER BY EventDate ROWS UNBOUNDED PRECEDING) AS grp
        FROM Ordered
    )
    SELECT CustomerID, Country, MIN(EventDate) AS ChangeDate
    INTO #Changes
    FROM Grouped
    GROUP BY CustomerID, Country, grp;

    DECLARE change_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT CustomerID, Country, ChangeDate
        FROM #Changes
        ORDER BY CustomerID, ChangeDate;

    OPEN change_cursor;
    FETCH NEXT FROM change_cursor INTO @CustomerID, @Country, @ChangeDate;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT TOP 1 @CurrentKey = CustomerKey, @CurrentCountry = Country
        FROM DW.DimCustomer
        WHERE CustomerID = @CustomerID AND IsCurrent = 1;

        IF @CurrentKey IS NULL
        BEGIN
            INSERT INTO DW.DimCustomer (CustomerID, Country, EffectiveDate, ExpiryDate, IsCurrent)
            VALUES (@CustomerID, @Country, @ChangeDate, NULL, 1);
        END
        ELSE IF @CurrentCountry <> @Country
        BEGIN
            UPDATE DW.DimCustomer SET IsCurrent = 0, ExpiryDate = @ChangeDate WHERE CustomerKey = @CurrentKey;
            INSERT INTO DW.DimCustomer (CustomerID, Country, EffectiveDate, ExpiryDate, IsCurrent)
            VALUES (@CustomerID, @Country, @ChangeDate, NULL, 1);
        END

        SET @CurrentKey = NULL;
        SET @CurrentCountry = NULL;

        FETCH NEXT FROM change_cursor INTO @CustomerID, @Country, @ChangeDate;
    END

    CLOSE change_cursor;
    DEALLOCATE change_cursor;

    DROP TABLE #Changes;
END
GO