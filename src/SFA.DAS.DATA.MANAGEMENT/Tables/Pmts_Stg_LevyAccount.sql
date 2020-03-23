/****** Object:  Table [Pmts].[Stg_LevyAccount]    Script Date: 18/03/2020 16:01:59 ******/

CREATE TABLE [Pmts].[Stg_LevyAccount](
	[AccountId] [bigint] NOT NULL,
	[AccountName] [varchar](255) NOT NULL,
	[Balance] [decimal](18, 4) NOT NULL,
	[IsLevyPayer] [bit] NOT NULL,
	[TransferAllowance] [decimal](18, 4) NOT NULL
) 