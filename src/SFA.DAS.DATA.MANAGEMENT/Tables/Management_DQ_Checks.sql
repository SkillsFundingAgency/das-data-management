CREATE TABLE [Mgmt].[DQ_Checks](
	[DQCheckId] BIGINT        IDENTITY (1, 1) NOT NULL,
	[RunId]     BIGINT        NOT NULL DEFAULT(-1),
	[DQCheckName] varchar(100) NOT NULL,
	[DQCheckStatus] BIT NOT NULL,
	[DQErrorDetails] varchar(max)NULL,
	[LastUpdatedTimestamp] [datetime2](7) DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT [PK_DQChecks] PRIMARY KEY CLUSTERED (DQCheckId ASC)
	)