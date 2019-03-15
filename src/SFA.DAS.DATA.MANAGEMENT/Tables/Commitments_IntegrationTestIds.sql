CREATE TABLE [Comt].[IntegrationTestIds]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(256) NOT NULL,
	[ObjectId] BIGINT NOT NULL,
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	[Load_Id] int
)
