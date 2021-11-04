CREATE TABLE [AsData_PL].[Fcast_Balance]
(
	[EmployerAccountId]				[bigint] NOT NULL,
	[Amount]						[decimal](18, 5) NOT NULL,
	[TransferAllowance]				[decimal](18, 5) NOT NULL,
	[RemainingTransferBalance]		[decimal](18, 5) NOT NULL,
	[BalancePeriod]					[datetime] NOT NULL,
	[ReceivedDate]					[datetime] NOT NULL,
	[UnallocatedCompletionPayments] [decimal](18, 5) NOT NULL,
	[Asdm_UpdatedDateTime]			[datetime2] default getdate()
)
