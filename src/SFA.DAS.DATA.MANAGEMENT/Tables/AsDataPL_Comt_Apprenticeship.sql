CREATE TABLE [ASData_PL].[Comt_Apprenticeship]
(
	[Id] [bigint] NOT NULL,
	[CommitmentId] [bigint] NOT NULL,	
	[ULN] [nvarchar](50) NULL,
	[TrainingType] [int] NULL,
	[TrainingCode] [nvarchar](20) NULL,
	[TrainingName] [nvarchar](126) NULL,
	[TrainingCourseVersion]  [NVarchar](10) NULL,
	[TrainingCourseVersionConfirmed] [Bit] NULL,
	[TrainingCourseOption]  [NVarchar](126) NULL,
	[StandardUId] [NVarchar](20)  NULL,
	[Cost] [decimal](18, 0) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[AgreementStatus] [smallint] NOT NULL,
	[PaymentStatus] [smallint] NOT NULL,
	[DateOfBirth] [datetime] Null,
	[CreatedOn] [datetime] NULL,
	[AgreedOn] [datetime] NULL,
	[PaymentOrder] [int] NULL,
	[StopDate] [date] NULL,
	[PauseDate] [date] NULL,
	[HasHadDataLockSuccess] [bit] NOT NULL,
	[PendingUpdateOriginator] [tinyint] NULL,
	[EPAOrgId] [char](7) NULL,
	[CloneOf] [bigint] NULL,
	[ReservationId] [uniqueidentifier] NULL,
	[IsApproved] [bit] NULL,
	[CompletionDate] [datetime] NULL,
	[ContinuationOfId] [bigint] NULL,
	[MadeRedundant] [bit] NULL,
	[OriginalStartDate] [datetime] NULL,
	[Age] [int] NULL,	
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	CONSTRAINT PK_Comt_Apprenticeship_Id PRIMARY KEY CLUSTERED (Id)
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NCI_Comt_ReservationId] ON [AsData_PL].[Comt_Apprenticeship]([ReservationId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_Comt_CommitmentIdId] ON [AsData_PL].[Comt_Apprenticeship]([CommitmentId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_Comt_ULN] ON [ASData_PL].[Comt_Apprenticeship] ([ULN] ASC)
INCLUDE ([CommitmentId],[TrainingType],[TrainingCode],[Cost],[StartDate],[EndDate],[DateOfBirth],[CreatedOn],[StopDate],[PauseDate],[IsApproved],[CompletionDate],[AsDm_UpdatedDateTime])
GO
