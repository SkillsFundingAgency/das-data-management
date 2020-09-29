CREATE TABLE AsData_Pl.Acc_Account
(
    [Id] BIGINT NOT NULL,
	[HashedId] nvarchar(100)   NULL,
	[Name] nvarchar(100) null,
	[CreatedDate] datetime null,
	[ModifiedDate] datetime null,
	[ApprenticeshipEmployerType] tinyint null,
	[PublicHashedId] nvarchar(100) null,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),	
	[ComtLevyStatus] [tinyint]  NULL
)