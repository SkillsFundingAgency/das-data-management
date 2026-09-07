CREATE TABLE [ASData_PL].[Digc_Sharing]
(
	[Id] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[CertificateId] [uniqueidentifier] NULL,
	[CertificateType] [varchar](20) NULL,
	[CourseName] [varchar](1000) NULL,
	[LinkCode] [uniqueidentifier] NULL,
	[CreatedAt] [datetime2](7)  NULL,
	[ExpiryTime] [datetime2](7)  NULL,
	[Status] [varchar](20)  NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)