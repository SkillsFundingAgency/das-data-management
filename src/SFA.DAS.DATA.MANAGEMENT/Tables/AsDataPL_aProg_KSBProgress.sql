CREATE TABLE [AsData_PL].[aProg_KSBProgress]
(
	[KSBProgressId] int NOT NULL,
	[ApprenticeshipId] bigint NOT NULL,
	[KSBProgressType] int NOT NULL,
	[KSBId] uniqueidentifier NOT NULL,
	[KSBKey] nvarchar(max) NOT NULL,
	[CurrentStatus] int NOT NULL,
	[Note] nvarchar(max) NULL,
	[Asdm_UpdatedDateTime] datetime2 default getdate(),
    CONSTRAINT PK_aProg_KSBProgressId PRIMARY KEY CLUSTERED (KSBProgressId)
)