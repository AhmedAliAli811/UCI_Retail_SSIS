USE Retail_DW;
go

CREATE SCHEMA ETL;
go



CREATE TABLE ETL.AuditLog
(
    RunID INT IDENTITY(1,1) NOT NULL,
    PackageName VARCHAR(100) NOT NULL,
    StartTime DATETIME2 NOT NULL,
    EndTime DATETIME2 NULL,
    RowsRead INT NOT NULL DEFAULT 0,
    RowsInserted INT NOT NULL DEFAULT 0,
    RowsRejected INT NOT NULL DEFAULT 0,
    Status VARCHAR(20) NOT NULL,
    ErrorMessage NVARCHAR(1000) NULL,

    CONSTRAINT PK_AuditLog PRIMARY KEY (RunID)
);

CREATE TABLE ETL.ErrorLog
(
    ErrorLogKey INT IDENTITY(1,1) NOT NULL,
    RunID INT NOT NULL,
    PackageName VARCHAR(100) NOT NULL,
    ErrorDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    InvoiceNo    NVARCHAR(50),
    StockCode    NVARCHAR(50),
    Description  NVARCHAR(255),
    Quantity     NVARCHAR(50),
    InvoiceDate  NVARCHAR(50),
    UnitPrice    NVARCHAR(50),
    CustomerID   NVARCHAR(50),
    Country      NVARCHAR(100),
    ErrorReason VARCHAR(100) NOT NULL,

    CONSTRAINT PK_ErrorLog PRIMARY KEY (ErrorLogKey),
    CONSTRAINT FK_ErrorLog_AuditLog FOREIGN KEY (RunID) REFERENCES ETL.AuditLog(RunID)
);