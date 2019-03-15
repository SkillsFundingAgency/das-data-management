CREATE TABLE [comt].[BulkUpload]
(
	[Id] BIGINT NOT NULL PRIMARY KEY IDENTITY,
	[CommitmentId] BIGINT NOT NULL,
	[FileName] VARCHAR(50) NOT NULL,
	[FileContent] VARCHAR(MAX) NOT NULL,
	[CreatedOn] DATETIME NULL,
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	[Load_Id] int
)
GO