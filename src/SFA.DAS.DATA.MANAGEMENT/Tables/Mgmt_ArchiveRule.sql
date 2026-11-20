CREATE TABLE [Mgmt].[ArchiveRule]
(
    [RuleId]             varchar(50)   NOT NULL PRIMARY KEY,
    [DatabaseName]       sysname       NOT NULL,
    [SchemaName]         sysname       NOT NULL,
    [TableName]          sysname       NOT NULL,
    [RuleType]           varchar(30)   NOT NULL,
    [ArchiveColumn]      sysname       NULL,
    [ArchiveBeforeDate]  datetime2     NULL,
    [SelectionProcedure] nvarchar(256) NOT NULL,
    [DeleteProcedure]    nvarchar(256) NOT NULL,
    [ArchiveTarget]      nvarchar(500) NOT NULL,
    [ArchiveFormat]      varchar(20)   NOT NULL,
    [Enabled]            bit           NOT NULL DEFAULT (0),
    [CreatedDate]        datetime2     NOT NULL DEFAULT (SYSUTCDATETIME()),
    [ModifiedDate]       datetime2     NULL
);
