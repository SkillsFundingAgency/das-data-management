CREATE TABLE [AsData_PL].[Comt_FileUploadCohortLog]
(
	[Id] BIGINT NOT NULL PRIMARY KEY ,
	[FileUploadLogId] BIGINT NOT NULL,
	[CommitmentId] BIGINT NOT NULL,
	[RowCount] INT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)
GO
