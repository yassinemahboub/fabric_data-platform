
-- STEP 1: Create the Configuration Table

CREATE TABLE SQLCatalogTable (
    CatalogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(128) NOT NULL, -- e.g. SalesOrderDetails
    TableSchema NVARCHAR(128) NOT NULL, -- e.g. SalesLT
    DatabaseName NVARCHAR(128) NOT NULL, -- e.g. AdventureWorks
    WatermarkColumn NVARCHAR(128) NOT NULL, -- e.g. CreatedDate or CustomerID
    WatermarkType NVARCHAR(20) NOT NULL, -- 'Datetime' | 'ID'
    KeyColumn NVARCHAR(128) NOT NULL, -- Upsert keys. e.g. OrderID
    LastWatermark NVARCHAR(100) NULL, -- Can hold either "2024-12-31T23:59:59" or "543" / Casting will be made at run time using Dynamic SQL
    PartitionColumn NVARCHAR(128) NULL, -- OPTIONAL / e.g. Country or OrderDate
    PartitionType NVARCHAR(128) NULL, -- OPTIONAL / 'Date' | 'Categorical' / IMPORTANT: For Date Type, additional columns will be added during the SILVER transformation for partitioning (YEAR, MONTH, DAY)
    Modeling NVARCHAR(128) NOT NULL, -- e.g. 'Facts' or 'Dimensions'
    ActiveFlag BIT NOT NULL DEFAULT 1, -- 1 = Used at run time and 0 = Skipped at run time
    IsInitialLoad BIT NOT NULL DEFAULT 1, -- Used to evaluate load type / 1 = Full and 0 = Incremental
    DataDomain NVARCHAR(200) NOT NULL, -- e.g. Sales
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);


-- STEP 2: Add Constraint for Critical Variables


ALTER TABLE SQLCatalogTable
ADD CONSTRAINT partition_check CHECK(PartitionType in ('Date', 'Categorical'))

ALTER TABLE SQLCatalogTable
ADD CONSTRAINT watermark_check CHECK(WatermarkType in ('Datetime', 'ID'))

ALTER TABLE SQLCatalogTable
ADD CONSTRAINT modeling_check CHECK(Modeling in ('Facts', 'Dimensions', 'Bridges'))


-- STEP 3: Insert Tables for Ingestion

INSERT INTO SQLCatalogTable 
    (TableName, TableSchema, DatabaseName, WatermarkColumn, WatermarkType, KeyColumn, PartitionColumn, PartitionType, Modeling, DataDomain)
VALUES 
    -- Dimensions
    ('Categories', 'dbo', 'northwind', 'CategoryID', 'ID', 'CategoryID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Customers', 'dbo', 'northwind', 'CustomerID', 'ID', 'CustomerID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Employees', 'dbo', 'northwind', 'EmployeeID', 'ID', 'EmployeeID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Products', 'dbo', 'northwind', 'ProductID', 'ID', 'ProductID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Suppliers', 'dbo', 'northwind', 'SupplierID', 'ID', 'SupplierID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Shippers', 'dbo', 'northwind', 'ShipperID', 'ID', 'ShipperID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Region', 'dbo', 'northwind', 'RegionID', 'ID', 'RegionID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Territories', 'dbo', 'northwind', 'TerritoryID', 'ID', 'TerritoryID', NULL, NULL, 'Dimensions', 'Retail'),
    ('Customer Demographics', 'dbo', 'northwind', 'CustomerTypeID', 'ID', 'CustomerTypeID', NULL, NULL, 'Dimensions', 'Retail'),

    -- Bridges
    ('Employee Territories', 'dbo', 'northwind', 'EmployeeID', 'ID', 'EmployeeID', NULL, NULL, 'Bridge', 'Retail'),
    ('CustomerCustomerDemo', 'dbo', 'northwind', 'CustomerID', 'ID', 'CustomerID', NULL, NULL, 'Bridge', 'Retail'),

    -- Facts
    ('Orders', 'dbo', 'northwind', 'OrderDate', 'Datetime', 'OrderID', 'OrderDate', 'Date', 'Facts', 'Retail'),
    ('Order Details', 'dbo', 'northwind', 'OrderID', 'ID', 'OrderID', NULL, NULL, 'Facts', 'Retail');



-- STEP 4: Create a Stored Procedure to Update Watermark

CREATE OR ALTER PROCEDURE automation.sp_UpdateSQLWatermark
    @DatabaseName NVARCHAR(128),
    @TableSchema NVARCHAR(128),
    @TableName NVARCHAR(128),
    @NewWatermark NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @now DATETIME = SYSUTCDATETIME(); 
    
    UPDATE automation.SQLCatalogTable 
    SET 
        /* Turn off the initial-load flag after the first successful run */
        IsInitialLoad = CASE 
            WHEN IsInitialLoad = 1 THEN 0 
            ELSE IsInitialLoad 
        END,
        /* Persist the new (string) watermark */
        LastWatermark = @NewWatermark,
        /* Audit column */
        ModifiedDate = @now
    WHERE 
        DatabaseName = @DatabaseName 
        AND TableSchema = @TableSchema 
        AND TableName = @TableName 
        AND ActiveFlag = 1;
END;
GO
