CREATE TABLE [AsData_PL].[Comt_OverlappingTrainingDateRequest]
(
	[Id] BIGINT NOT NULL PRIMARY KEY ,
	[DraftApprenticeshipId] BIGINT NOT NULL,
	[PreviousApprenticeshipId] BIGINT NOT NULL,
	[ResolutionType] SMALLINT NULL,
	[Status] SMALLINT NOT NULL, 
	[CreatedOn] DATETIME2 NOT NULL ,
	[ActionedOn] DATETIME2 NULL,
	[NotifiedServiceDeskOn] DATETIME2 NULL,
	[NotifiedEmployerOn] DATETIME2 NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)
GO
