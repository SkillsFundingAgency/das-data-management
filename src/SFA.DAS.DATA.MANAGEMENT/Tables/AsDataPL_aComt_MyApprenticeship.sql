CREATE TABLE [AsData_PL].[aComt_MyApprenticeship]
(
    [Id] uniqueidentifier NOT NULL,
	[ApprenticeId] uniqueidentifier NOT NULL,
	[Uln] bigint NULL,
	[ApprenticeshipId] bigint NULL,
	[EmployerName] nvarchar(200) NULL,
	[StartDate] datetime2(7) NULL,
	[EndDate] datetime2(7) NULL,
	[TrainingProviderId] bigint NULL,
	[TrainingProviderName] nvarchar(200) NULL,
	[TrainingCode] nvarchar(15) NULL,
	[StandardUId] nvarchar(20) NULL,
	[CreatedOn] datetime2(7) NOT NULL,
    [Asdm_UpdatedDateTime] datetime2 default getdate(),
    CONSTRAINT PK_aComt_MyApprentice_Id PRIMARY KEY CLUSTERED (Id)
)