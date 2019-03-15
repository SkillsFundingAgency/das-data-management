CREATE TABLE [Comt].[AssessmentOrganisation]
(
	[Id] INT NOT NULL PRIMARY KEY ,
	[EPAOrgId] CHAR(7) NOT NULL,
	[Name] NVARCHAR(128) NOT NULL,
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] datetime default(getdate()),
	Load_Id int,
	CONSTRAINT AO_EPAOrgId UNIQUE([EPAOrgId])
)
Go