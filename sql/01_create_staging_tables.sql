use Retail_Staging;
go

Create SCHEMA Staging;
go

CREATE TABLE Staging.SalesRaw
(
    InvoiceNo VARCHAR(15),
    StockCode VARCHAR(15),
    Description NVARCHAR(30),
    Quantity INT,
    InvoiceDate DATETIME2,
    UnitPrice DECIMAL(10,2),
    CustomerID VARCHAR(15),
    Country NVARCHAR(30)
);