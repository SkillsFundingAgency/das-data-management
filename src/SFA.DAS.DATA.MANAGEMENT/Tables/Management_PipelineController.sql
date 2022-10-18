
CREATE TABLE [Mgmt].[Config_PipelineController](
	[PipelineControllerId] int IDENTITY(1,1)  NOT NULL,
	[MasterPipelineId]  int NOT NULL,
	[ChildPipelineId] int not null,
	[IsEnabled] BIT not null, 
	[ExecutionOrder] int not null,
	CONSTRAINT [PK_PipelineController_PipelineControllerId] PRIMARY KEY CLUSTERED (PipelineControllerId ASC)
	)