CREATE TABLE [ASData_PL].[AODP_AwardingOrganisation]
(
	[Id] [uniqueidentifier] PRIMARY KEY NOT NULL,
	[Ukprn] [int] NULL,
	[RecognitionNumber] [varchar](250) NULL,
	[NameLegal] [varchar](250) NULL,
	[NameOfqual] [varchar](250) NULL,
	[NameGovUk] [varchar](250) NULL,
	[Name_Dsi] [varchar](250) NULL,
	[Acronym] [varchar](100) NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
)