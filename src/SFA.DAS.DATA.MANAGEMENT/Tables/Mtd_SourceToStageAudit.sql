CREATE TABLE [Mtd].[SourceToStageAudit]
(   AuditID INT IDENTITY(1,1) PRIMARY KEY,
    SourceDatabaseName NVARCHAR(100) NOT NULL,
    SourceSchemaName NVARCHAR(100) NOT NULL,
    SourceTableName NVARCHAR(100) NOT NULL,
    SourceQuery NVarchar(max) ,
    WatermarkColumnName NVARCHAR(100) NOT NULL,
    WatermarkValue DATETIME ,
    StagingTableName NVARCHAR(100),
    LastUpdatedTimestamp DATETIME
)