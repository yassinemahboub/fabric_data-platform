-- STEP 1: Create Table Logs

CREATE TABLE SQLTableLogs (
    TableLogID INT IDENTITY(1,1) PRIMARY KEY,
    DatabaseName NVARCHAR(128) NOT NULL,
    TableSchema NVARCHAR(128) NOT NULL,
    TableName NVARCHAR(128) NOT NULL,
    IsInitialLoad BIT NOT NULL,
    BronzeStatus NVARCHAR(500) NOT NULL,
    SilverStatus NVARCHAR(500) NOT NULL,
    GoldStatus NVARCHAR(500) NOT NULL,
    SemanticRefresh NVARCHAR(500) NOT NULL,
    RowsInserted INT,
    Runtime DATETIME NOT NULL DEFAULT GETDATE(),
    PipelineName NVARCHAR(128) NOT NULL,
    PipelineRunID NVARCHAR(128) NOT NULL
);

-- STEP 2: Stored Procedure to Insert Table Logs

CREATE PROCEDURE sp_SQLInsertTableLog
    @DatabaseName NVARCHAR(128),
    @TableSchema NVARCHAR(128),
    @TableName NVARCHAR(128),
    @IsInitialLoad BIT,
    @BronzeStatus NVARCHAR(500),
    @SilverStatus NVARCHAR(500),
    @GoldStatus NVARCHAR(500),
    @SemanticRefresh NVARCHAR(500),
    @RowsInserted INT,
    @Runtime DATETIME,
    @PipelineName NVARCHAR(128),
    @PipelineRunID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO automation.SQLTableLogs (
        DatabaseName,
        TableSchema,
        TableName,
        IsInitialLoad,
        BronzeStatus,
        SilverStatus,
        GoldStatus,
        SemanticRefresh,
        RowsInserted,
        Runtime,
        PipelineName,
        PipelineRunID
    )
    VALUES (
        @DatabaseName,
        @TableSchema,
        @TableName,
        @IsInitialLoad,
        @BronzeStatus,
        @SilverStatus,
        @GoldStatus,
        @SemanticRefresh,
        @RowsInserted,
        @Runtime,
        @PipelineName,
        @PipelineRunID
    );
END;