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
	[ComtLevyStatus] [tinyint]  NULL,
	[NameConfirmed] BIT NULL,
	[AddTrainingProviderAcknowledged] BIT NULL,
	[IsRetentionApplied] bit DEFAULT (0),
    [RetentionAppliedDate]  DateTime2(7)
	,CONSTRAINT PK_Acc_Account_Id PRIMARY KEY CLUSTERED (Id)
)
GO

CREATE NONCLUSTERED INDEX [NCI_ACC_HashedId] ON [AsData_PL].[Acc_Account]([HashedId])
GO
