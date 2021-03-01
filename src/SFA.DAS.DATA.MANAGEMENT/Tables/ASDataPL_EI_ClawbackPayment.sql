CREATE TABLE [ASData_PL].[EI_ClawbackPayment](
	[Id]							[uniqueidentifier]		Primary Key NOT NULL,
	[ApprenticeshipIncentiveId]		[uniqueidentifier]		NOT NULL,
	[PendingPaymentId]				[uniqueidentifier]		NULL,
	[AccountId]						[bigint]				NULL,
	[AccountLegalEntityId]			[bigint]				NULL,
	[Amount]						[decimal](9, 2)			NULL,
	[DateClawbackCreated]			[datetime2](7)			NULL,
	[DateClawbackSent]				[datetime2](7)			NULL,
	[CollectionPeriod]				[tinyint]				NULL,
	[CollectionPeriodYear]			[smallint]				NULL,
	[SubNominalCode]				[int]					NULL,
	[PaymentId]						[uniqueidentifier]		NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)			default (getdate())
)
GO
CREATE NONCLUSTERED INDEX [IX_EI_ClawbackPayment_ApprenticeshipIncentiveId] ON [ASData_PL].[EI_ClawbackPayment](ApprenticeshipIncentiveId ASC)
GO