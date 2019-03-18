CREATE TABLE [Comt].[ApprenticeshipUpdate]
(
	[Id] BIGINT NOT NULL PRIMARY KEY , 
	[ApprenticeshipId] BIGINT NOT NULL,
	[Originator] TINYINT NOT NULL,
	[OriginatorDesc] varchar(255) null,
	[Status] TINYINT NOT NULL DEFAULT(0),
	[StatusDesc] varchar(255) null,
    [FirstName] NVARCHAR(100)  MASKED WITH (FUNCTION='default()') NULL,
    [LastName] NVARCHAR(100)  MASKED WITH (FUNCTION='default()') NULL,
    [TrainingType] INT NULL, 
    [TrainingCode] NVARCHAR(20) NULL, 
    [TrainingName] NVARCHAR(126) NULL, 
    [Cost] DECIMAL NULL, 
    [StartDate] DATETIME NULL, 
    [EndDate] DATETIME NULL, 
    [DateOfBirth] DATETIME NULL,
	[CreatedOn] DATETIME NULL,
	[UpdateOrigin] TINYINT NULL,
	[EffectiveFromDate] DATETIME NULL,
	[EffectiveToDate] DATETIME NULL,
	[AsDm_Created_Date] DateTime default(getdate()),
	[AsDm_Updated_Date] DateTime default(getdate()),
	Load_Id int null
)
GO

-- this isn't required for ApprenticeshipSummary use anymore, but other db work might benefit by it
CREATE NONCLUSTERED INDEX [IX_ApprenticeshipUpdate_ApprenticeshipId_Status] ON [Comt].[ApprenticeshipUpdate] ([ApprenticeshipId], [Status]) INCLUDE ([Originator]) WITH (ONLINE = ON)
GO

-- this was recommended by azure (with the old apprenticeshipsummary view)
--CREATE NONCLUSTERED INDEX [nci_wi_ApprenticeshipUpdate_97B6F3CEAF1484B61E5FC09AB1376AFF] ON [dbo].[ApprenticeshipUpdate] ([Status]) INCLUDE ([ApprenticeshipId], [Originator]) WITH (ONLINE = ON)
--GO