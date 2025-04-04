CREATE TABLE [Mtd].[SourceToStageAudit]
(   AuditID INT IDENTITY(1,1),
    SourceDatabaseName NVARCHAR(100) NOT NULL,
    SourceSchemaName NVARCHAR(100) NOT NULL,
    SourceTableName NVARCHAR(100) NOT NULL,
    SourceQuery NVarchar(max) ,
    WatermarkColumnName NVARCHAR(100) NOT NULL,
    WatermarkValue DATETIME2(7) ,
    StagingTableName NVARCHAR(100),
    LastUpdatedTimestamp DATETIME,
    SpName NVARCHAR(100),
    CONSTRAINT [PK_SourceToStage_AudiId] PRIMARY KEY CLUSTERED (SourceDatabaseName,SourceTableName ASC)
)