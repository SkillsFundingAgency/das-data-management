﻿CREATE TABLE [ASData_PL].[EI_PendingPaymentValidationResult]
(
	[Id]								[uniqueidentifier]	NOT NULL PRIMARY KEY,
	[PendingPaymentId]					[uniqueidentifier]  NULL,
	[Step]								[nvarchar](20)		NULL,
	[Result]							[bit]				NULL,
	[PeriodNumber]						[tinyint]			NULL,
	[PaymentYear]						[smallint]			NULL,
	[CreatedDateUTC]					[datetime2](7)		NULL,
	[AsDm_UpdatedDateTime]				[datetime2](7)		DEFAULT (getdate())
) 