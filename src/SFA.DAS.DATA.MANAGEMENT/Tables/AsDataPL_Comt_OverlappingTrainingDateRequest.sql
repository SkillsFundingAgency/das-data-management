CREATE TABLE [AsData_PL].[Comt_OverlappingTrainingDateRequest]
(
	[Id] BIGINT NOT NULL PRIMARY KEY ,
	[DraftApprenticeshipId] BIGINT NOT NULL,
	[PreviousApprenticeshipId] BIGINT NOT NULL,
	[ResolutionType] SMALLINT NULL,
	[Status] SMALLINT NOT NULL DEFAULT 0, 
	[CreatedOn] DATETIME2 NOT NULL ,
	[ActionedOn] DATETIME2 NULL,
	[NotifiedServiceDeskOn] DATETIME2 NULL,
	[RowVersion] timestamp NULL
)
GO
