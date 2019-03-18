CREATE TABLE [Comt].[DataLockStatus]
(
	[Id] BIGINT NOT NULL PRIMARY KEY ,
	[DataLockEventId] BIGINT NOT NULL,
	[DataLockEventDatetime] DATETIME NOT NULL,
    [PriceEpisodeIdentifier] NVARCHAR(25) NOT NULL,
    [ApprenticeshipId] BIGINT NOT NULL,
    [IlrTrainingCourseCode] NVARCHAR(20) NULL,
    [IlrTrainingType] TINYINT NOT NULL,
	[IlrActualStartDate] DATETIME NULL,
	[IlrEffectiveFromDate] DATETIME NULL,
	[IlrPriceEffectiveToDate] DATETIME NULL,
	[IlrTotalCost] DECIMAL NULL,
    [ErrorCode] INT NOT NULL,
    [Status] TINYINT NOT NULL,
	[StatusDesc] varchar(255) null,
    [TriageStatus] TINYINT NOT NULL,
	[TriageStatusDesc] varchar(255)  null,
	[ApprenticeshipUpdateId] BIGINT NULL,
	[IsResolved] BIT NOT NULL,
	[EventStatus] TINYINT NOT NULL default 1,
	[IsExpired] BIT NOT NULL DEFAULT(0),
	[Expired] DATETIME NULL,
	[AsDm_Created_Date] datetime default(getdate()),
	[AsDm_Updated_Date] DateTime default(getdate()),
	[Load_Id] int,
	CONSTRAINT [FK_DataLockStatus_ApprenticeshipId] FOREIGN KEY ([ApprenticeshipId]) REFERENCES [Comt].[Apprenticeship]([Id]),
	CONSTRAINT [FK_DataLockStatus_ApprenticeshipUpdateId] FOREIGN KEY ([ApprenticeshipUpdateId]) REFERENCES [Comt].[ApprenticeshipUpdate]([Id])
)
GO

CREATE NONCLUSTERED INDEX [IX_DataLockStatus_DataLockEventId] ON [Comt].[DataLockStatus] ([DataLockEventId])
GO

CREATE UNIQUE INDEX [IX_DataLockStatus_ApprenticeshipId] ON [Comt].[DataLockStatus] ([ApprenticeshipId],[PriceEpisodeIdentifier])
GO

CREATE NONCLUSTERED INDEX [IX_DataLockStatus_IlrEffectiveFromDate_Id] ON [Comt].[DataLockStatus]
(
	[IlrEffectiveFromDate] ASC,
	[Id] ASC
)
INCLUDE ([ErrorCode],
	[TriageStatus],
	[Status],
	[IsResolved],
	[EventStatus],
	[IsExpired])
GO