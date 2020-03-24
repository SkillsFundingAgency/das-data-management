

CREATE TABLE [StgPmts].[LevyAccount](
	[AccountId] [bigint] NOT NULL,
	[AccountName] [varchar](255) NOT NULL,
	[Balance] [decimal](18, 4) NOT NULL,
	[IsLevyPayer] [bit] NOT NULL,
	[TransferAllowance] [decimal](18, 4) NOT NULL
) 