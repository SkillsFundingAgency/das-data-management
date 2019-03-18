CREATE TABLE [Comt].[TransferRequest]
(
	[Id] BIGINT NOT NULL PRIMARY KEY , 
    [CommitmentId] BIGINT NOT NULL,
	[TrainingCourses] NVARCHAR(MAX) NOT NULL,
	[Cost] MONEY NOT NULL,
	[Status] TINYINT NOT NULL,
	[TransferApprovalActionedByEmployerName] NVARCHAR(255),
	[TransferApprovalActionedByEmployerEmail] NVARCHAR(255),
	[TransferApprovalActionedOn] DATETIME2,

    [CreatedOn] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [FundingCap] MONEY NULL, 
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	[Load_Id] int,
    CONSTRAINT [FK_TransferRequest_Commitment] FOREIGN KEY ([CommitmentId]) REFERENCES [Comt].[Commitment]([Id])

)
GO

CREATE NONCLUSTERED INDEX [IX_TransferRequest_CommitmentId] ON [Comt].[TransferRequest] ([CommitmentId])
