CREATE TABLE AsData_Pl.Acc_Account
(
    [Id] BIGINT NOT NULL,
	[HashedId] nvarchar(100)   NULL,
	[Name] nvarchar(100) MASKED WITH (FUNCTION = 'default()') not null,
	[CreatedDate] datetime not null,
	[ModifiedDate] datetime null,
	[ApprenticeshipEmployerType] tinyint not null,
	[PublicHashedId] nvarchar(100) null,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)




