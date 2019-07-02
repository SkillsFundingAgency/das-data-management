CREATE TABLE [dbo].[Transfers]
(
	 [Id] INT NOT NULL PRIMARY KEY
	,CommitmentId int 
	,Cost int
	,TrainingCourses nvarchar(255)
	,TransferStatus tinyint
	,TransferSenderAccountId int
	,TransferReceiverAccountId int
	,TransferApprovalActionedByEmployerName nvarchar(255)
	,TransferApprovalActionedByEmployerEmail nvarchar(255)
	,TransferApprovalActionedOn  datetime2
	,FundingCap Decimal(17,2)
	,TransferCreatedOn Datetime2
	,Data_Source varchar(255) 
	,Source_TransferId int
	,AsDm_CreatedDate datetime2 default(getdate()) not null
	,AsDm_UpdatedDate datetime2 default(getdate()) not null
)
