CREATE TABLE [Mtd].[SourceToStageAudit]
(   AuditID INT IDENTITY(1,1) PRIMARY KEY,
    SourceDatabaseName NVARCHAR(100) NOT NULL,
    SourceSchemaName NVARCHAR(100) NOT NULL,
    SourceTableName NVARCHAR(100) NOT NULL,
    WatermarkColumnName NVARCHAR(100) NOT NULL,
    WatermarkValue NVARCHAR(100) NOT NULL,
    StgTableName NVARCHAR(100),
    LastUpdatedTimestamp DATETIME NOT NULL,
    CONSTRAINT [PK_SourceToStage_Id] PRIMARY KEY CLUSTERED (AuditID ASC)
)