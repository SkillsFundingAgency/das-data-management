CREATE TABLE [AsData_PL].[aProg_Task]
(
	[TaskId] int NOT NULL,
	[ApprenticeshipId] bigint NOT NULL,
	[DueDate] datetime2(7) NULL,
	[Title] nvarchar(255) NULL,
	[ApprenticeshipCategoryId] int NULL,
	[Note] nvarchar(max) NULL,
	[CompletionDateTime] datetime2(7) NULL,
	[CreatedDateTime] datetime2(7) NULL,
	[Status] int NOT NULL,
	[Asdm_UpdatedDateTime] datetime2 default getdate(),
    CONSTRAINT PK_aProg_TaskId PRIMARY KEY CLUSTERED ([TaskId])
)