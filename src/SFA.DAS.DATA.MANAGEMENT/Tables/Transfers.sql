CREATE TABLE [dbo].[Transfers]
(
	 [Id] INT IDENTITY(1,1) NOT NULL 
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
	,Source_CommitmentTransferId int
	,RunId bigint default(-1)
	,AsDm_CreatedDate datetime2 default(getdate()) not null
	,AsDm_UpdatedDate datetime2 default(getdate()) not null
	,CONSTRAINT PK_Transfers_Id PRIMARY KEY (ID)
)
