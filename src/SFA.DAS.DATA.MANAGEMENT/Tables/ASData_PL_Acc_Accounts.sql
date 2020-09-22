CREATE TABLE AsData_Pl.Acc_Account
(
    [Id] BIGINT NOT NULL,
	[HashedId] nvarchar(100)   NULL,
	[Name] nvarchar(100)  not null,
	[CreatedDate] datetime not null,
	[ModifiedDate] datetime null,
	[ApprenticeshipEmployerType] tinyint not null,
	[PublicHashedId] nvarchar(100) null,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	[ComtAccountID]  [bigint]  NULL,
	[ComtLevyStatus] [tinyint]  NULL,
	[EIAccountID] [bigint]  NULL,
	[HasSignedIncentiveTerms] [bit] NULL	
)