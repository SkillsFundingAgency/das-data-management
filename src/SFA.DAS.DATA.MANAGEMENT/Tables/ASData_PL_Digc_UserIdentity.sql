CREATE TABLE [ASData_PL].[Digc_UserIdentity]
(
	[Id] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[FamilyName] [varchar](255) NULL,
	[DateOfBirth] [date] NULL,
	[GivenNames] [varchar](255) NULL,
	[ValidSince] [datetime2](7) NULL,
	[ValidUntil] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)