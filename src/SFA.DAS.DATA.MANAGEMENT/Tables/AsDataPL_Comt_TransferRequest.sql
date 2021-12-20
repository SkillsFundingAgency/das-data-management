CREATE TABLE [AsData_PL].[Comt_TransferRequest]
(
	[Id]										[bigint]			NOT NULL,
	[CommitmentId]								[bigint]			NOT NULL,
	[TrainingCourses]							[nvarchar](max)		NOT NULL,
	[Cost]										[money]				NOT NULL,
	[Status]									[tinyint]			NOT NULL,
	[TransferApprovalActionedOn]				[datetime2](7)		NULL,
	[CreatedOn]									[datetime2](7)		NOT NULL,
	[FundingCap]								[money]				NULL,
	[AutoApproval]								[bit]				NOT NULL,
	[AsDm_UpdatedDateTime]						[datetime2]			default getdate()
)
GO
