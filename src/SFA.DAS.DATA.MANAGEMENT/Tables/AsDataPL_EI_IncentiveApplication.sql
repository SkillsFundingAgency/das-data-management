CREATE TABLE [AsData_PL].[EI_IncentiveApplication]
(
	[Id]						UNIQUEIDENTIFIER	NOT NULL PRIMARY KEY,
	[AccountId]					BIGINT				NOT NULL,
	[AccountLegalEntityId]		BIGINT				NOT NULL,
	[DateCreated]				DATETIME			NOT NULL,
	[Status]					NVARCHAR(50)		NOT NULL,
	[DateSubmitted]				DATETIME2			NULL,
	[AsDm_UpdatedDateTime]		DateTime2			default(getdate())
)
