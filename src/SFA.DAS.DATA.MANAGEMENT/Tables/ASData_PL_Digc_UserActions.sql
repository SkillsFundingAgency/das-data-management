CREATE TABLE [ASData_PL].[Digc_UserActions]
(
	[Id] [bigint]  NULL,
	[UserId] [uniqueidentifier] NULL,
	[ActionType] [int] NULL,
	[ActionCode] [varchar](50) NULL,
	[ActionTime] [datetime2](7) NULL,
	[FamilyName] [varchar](255) NULL,
	[GivenNames] [varchar](255) NULL,
	[CertificateId] [uniqueidentifier] NULL,
	[CertificateType] [varchar](20) NULL,
	[CourseName] [varchar](1000) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)