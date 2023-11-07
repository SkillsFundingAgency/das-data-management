CREATE TABLE [ASData_PL].[EI_Payment]
(
	[Id]								[uniqueidentifier]			NOT NULL,
	[ApprenticeshipIncentiveId]			[uniqueidentifier]			NOT NULL,
	[PendingPaymentId]					[uniqueidentifier]			NOT NULL,
	[AccountId]							[bigint]					NOT NULL,
	[AccountLegalEntityId]				[bigint]					NOT NULL,
	[CalculatedDate]					[datetime2](7)				NULL,
	[PaidDate]							[datetime2](7)				NULL,
	[SubNominalCode]					[int]						NULL,
	[PaymentPeriod]						[tinyint]					NULL,
	[PaymentYear]						[smallint]					NULL,
	[Amount]							[decimal](9, 2)				NULL,
	[VrfVendorId]						nvarchar(100)				NULL,
	[AsDm_UpdatedDateTime]				[datetime2](7)				DEFAULT (getdate()),
	CONSTRAINT PK_EI_Payment_Id PRIMARY KEY CLUSTERED (Id)
)
