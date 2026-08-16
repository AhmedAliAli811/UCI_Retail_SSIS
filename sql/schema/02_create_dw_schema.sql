USE Retail_DW;
go

CREATE SCHEMA DW;
go

CREATE TABLE DW.DimCustomer
(
    CustomerKey INT IDENTITY(1,1) NOT NULL,
    CustomerID NVARCHAR(50),
    Country VARCHAR(30),
    EffectiveDate DATE,
    ExpiryDate DATE,
    IsCurrent BIT,

    CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerKey)
);

CREATE TABLE DW.DimProduct (
	ProductKey INT IDENTITY(1,1) NOT NULL,
    StockCode NVARCHAR(100),
    CleansedDescription  NVARCHAR(100),
    CONSTRAINT PK_DimProduct PRIMARY KEY (ProductKey)
);
CREATE TABLE DW.DimDate
(
    DateKey INT NOT NULL,
    FullDate DATE NOT NULL,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName VARCHAR(15),
    Day INT,
    DayOfWeekNumber INT,

    CONSTRAINT PK_DimDate PRIMARY KEY (DateKey)
);
Alter Table DW.FactSales
alter column InvoiceNo NVARCHAR(50)

CREATE TABLE DW.FactSales
(
    SalesKey INT IDENTITY(1,1) NOT NULL,
    DateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    ProductKey INT NOT NULL,
    InvoiceNo NVARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    ExtendedPrice DECIMAL(10,2),
    IsCancelled BIT,
		
    CONSTRAINT PK_FactSales PRIMARY KEY (SalesKey),
    CONSTRAINT FK_FactSales_Date FOREIGN KEY (DateKey) REFERENCES DW.DimDate(DateKey),
    CONSTRAINT FK_FactSales_Customer FOREIGN KEY (CustomerKey) REFERENCES DW.DimCustomer(CustomerKey),
    CONSTRAINT FK_FactSales_Product FOREIGN KEY (ProductKey) REFERENCES DW.DimProduct(ProductKey)
);