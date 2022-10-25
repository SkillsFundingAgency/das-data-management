CREATE TABLE [AsData_PL].[EI_EmploymentCheck]
(
	[Id]							[uniqueidentifier]	NOT NULL,
	[ApprenticeshipIncentiveId]		[uniqueidentifier]	NOT NULL,
	[CheckType]						[nvarchar](50)		NOT NULL,
	[MinimumDate]					[datetime2](7)		NOT NULL,
	[MaximumDate]					[datetime2](7)		NOT NULL,
	[CorrelationId]					[uniqueidentifier]	NOT NULL,
	[Result]						[bit]				NULL,
	[CreatedDateTime]				[datetime2](7)		NOT NULL,
	[UpdatedDateTime]				[datetime2](7)		NULL,
	[ResultDateTime]				[datetime2](7)		NULL,
	[ErrorType]						[nvarchar](50)		NULL,
	[AsDm_UpdatedDateTime]			[datetime2]			default getdate()
) ON [PRIMARY]
GO;