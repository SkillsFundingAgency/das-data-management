﻿CREATE TABLE [ASData_PL].[PFBE_EmployerFeedback]
(
	EmployerFeedbackID						[Bigint]		IDENTITY(1,1)			NOT	NULL Primary key,
	EmployerFeedbackBinaryId				[uniqueidentifier]						NULL,
	Ukprn									[BigInt]								NULL,
	AccountId								[BigInt]								NULL,
	DatetimeCompleted						[Datetime2](7)							NULL,
	FeedbackName							[NVarchar](500)							NULL,
	FeedbackValue							[Smallint]								NULL,
	ProviderRating							[NVarchar](10)							NULL,
	RunID									[BigInt]								NULL,
	AsDm_CreatedDate						[datetime2](7)							DEFAULT (getdate()),
	AsDm_UpdatedDate					    [datetime2](7)							DEFAULT (getdate())
)
