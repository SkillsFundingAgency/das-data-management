CREATE TABLE [AsData_PL].[aProg_TaskKSBs]
(
	[TaskId] int NOT NULL,
	[KSBProgressId] int NOT NULL,	
	[Asdm_UpdatedDateTime] datetime2 default getdate()
)