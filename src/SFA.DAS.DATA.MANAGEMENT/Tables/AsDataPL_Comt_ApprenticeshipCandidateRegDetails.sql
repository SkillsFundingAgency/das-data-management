CREATE TABLE [ASData_PL].[Comt_ApprenticeshipCandidateRegDetails]
(
	[ApprenticeshipId] [bigint] NOT NULL,
	[CommitmentId] [bigint] NOT NULL,	
    [CandidateFirstName] nvarchar(500) null,
	[CandidateLastName] nvarchar(500) null,
	[CandidateFullName] nvarchar(500) null,
	[CandidateDateOfBirth] nvarchar(500) null,
	[CandidateEmail] nvarchar(500) null,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
	CONSTRAINT PK_Comt_ApprenticeshipCandidateRegDetails_Id PRIMARY KEY CLUSTERED (ApprenticeshipId)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCI_Comt_RegDetails_CommitmentId] ON [AsData_PL].[Comt_ApprenticeshipCandidateRegDetails]([CommitmentId] ASC)
GO

