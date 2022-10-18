
CREATE TABLE [Mgmt].[Pipeline](
	[PipelineId] int NOT NULL,
	[PipelineName] varchar(100) NOT NULL,
	[LastUpdatedTimestamp] [datetime2](7) DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT [PK_Pipeline_PipelineId] PRIMARY KEY CLUSTERED (PipelineId ASC)
	)