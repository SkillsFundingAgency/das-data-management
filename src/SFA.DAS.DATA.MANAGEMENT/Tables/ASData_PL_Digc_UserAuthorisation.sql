CREATE TABLE [ASData_PL].[Digc_UserAuthorisation]
(
	[Id] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier]NULL,
	[ULN] [bigint]NULL,
	[AuthorisedAt] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)