CREATE TABLE [ASData_PL].[Comt_Accounts]
(
	[Id] [bigint] NOT NULL,
	[HashedId] [nchar](6) NOT NULL,		
	[Created] [datetime2](7) NOT NULL,
	[Updated] [datetime2](7) NULL,
	[LevyStatus] [tinyint] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
	CONSTRAINT PK_Acct_Comt_Accounts_Id PRIMARY KEY CLUSTERED (Id)
)ON [PRIMARY]