CREATE TABLE [AsData_PL].[RP_FinancialData]
(
	[Id]							[bigint]				PRIMARY KEY NOT NULL,
	[ApplicationId]					[uniqueidentifier]		NULL,
	[TurnOver]						[bigint]				NULL,
	[Depreciation]					[bigint]				NULL,
	[ProfitLoss]					[bigint]				NULL,
	[Dividends]						[bigint]				NULL,
	[IntangibleAssets]				[bigint]				NULL,
	[Assets]						[bigint]				NULL,
	[Liabilities]					[bigint]				NULL,
	[ShareholderFunds]				[bigint]				NULL,
	[Borrowings]					[bigint]				NULL,
	[AccountingReferenceDate]		[date]					NULL,
	[AccountingPeriod]				[tinyint]				NULL,
	[AverageNumberofFTEEmployees]	[bigint]				NULL,
	[AsDm_UpdatedDateTime]			[datetime2](7)			default getdate()	NULL
) 
