CREATE TABLE [Mgmt].[DQ_TablesToExclude](
	[DQTablesToExcludeId] BIGINT        IDENTITY (1, 1) NOT NULL,	
	[SchemaName] varchar(100) NOT NULL,
	[TableName] BIT NOT NULL,	
	[LastUpdatedTimestamp] [datetime2](7) DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT [PK_DQTablesToExclude] PRIMARY KEY CLUSTERED (DQCheckId ASC)
	)