CREATE TABLE [ASData_PL].[Comt_ApprenticeshipRegDetails]
(
	[ApprenticeshipId] [bigint] NOT NULL,
	[CommitmentId] [bigint] NOT NULL,	
    [FirstName] nvarchar(500) null,
	[LastName] nvarchar(500) null,
	[FullName] nvarchar(500) null,
	[EmailAddress] nvarchar(500) null,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
	CONSTRAINT PK_Comt_ApprenticeshipRegDetails_Id PRIMARY KEY CLUSTERED (ApprenticeshipId)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCI_Comt_RegDetails_CommitmentId] ON [AsData_PL].[Comt_ApprenticeshipRegDetails]([CommitmentId] ASC)
GO

