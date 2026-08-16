CREATE PROCEDURE ETL.usp_LoadDimProduct
    @RunID INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DW.DimProduct (StockCode, CleansedDescription)
    SELECT DISTINCT s.StockCode, LEFT(s.Description, 30)
    FROM Retail_Staging.Staging.SalesRaw s
    WHERE s.RunID = @RunID
      AND s.StockCode IS NOT NULL
      AND LTRIM(RTRIM(s.StockCode)) <> ''
      AND NOT EXISTS (
          SELECT 1 FROM DW.DimProduct p WHERE p.StockCode = s.StockCode
      );
END