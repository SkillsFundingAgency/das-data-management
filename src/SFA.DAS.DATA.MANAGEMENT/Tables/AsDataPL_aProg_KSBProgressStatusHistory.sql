CREATE TABLE [AsData_PL].[aProg_KSBProgressStatusHistory]
(
	[KSBProgressId] int NOT NULL,
	[Status] int NULL,	
	[StatusTime] datetime2 NULL,	
	[Asdm_UpdatedDateTime] datetime2 default getdate()
)