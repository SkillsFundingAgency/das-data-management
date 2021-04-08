CREATE TABLE [ASData_PL].[EI_ChangeOfCircumstance]
(
	[Id]						[uniqueidentifier]		PRIMARY KEY			NOT NULL,
	[ApprenticeshipIncentiveId] [uniqueidentifier]							NOT NULL,
	[ChangeType]				[varchar](20)								NULL,
	[PreviousValue]				[varchar](100)								NULL,
	[NewValue]					[varchar](100)								NULL,
	[ChangedDate]				[datetime2](7)								NULL,
	[AsDm_UpdatedDateTime]		[DateTime2]									default(getdate())
)
GO