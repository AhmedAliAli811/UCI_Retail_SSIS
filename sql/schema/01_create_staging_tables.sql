use Retail_Staging;
go

Create SCHEMA Staging;
go
Create TABLE Staging.SalesRaw
(
	RunID INT NULL,
    InvoiceNo    NVARCHAR(50),
    StockCode    NVARCHAR(50),
    Description  NVARCHAR(255),
    Quantity     NVARCHAR(50),
    InvoiceDate  NVARCHAR(50),
    UnitPrice    NVARCHAR(50),
    CustomerID   NVARCHAR(50),
    Country      NVARCHAR(100)
);