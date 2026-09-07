CREATE TABLE [ASData_PL].[Appsi_Review]
(
	[Id] [bigint]  NOT NULL,
	[AppId] [int] NOT NULL,
	[VendorId] [tinyint] NOT NULL,
	[ExternalId] [nvarchar](100) NOT NULL,
	[ReviewerName] [nvarchar](200) NULL,
	[Rating] [tinyint] NOT NULL,
	[Title] [nvarchar](500) NULL,
	[Comment] [nvarchar](max) NULL,
	[ReviewDate] [datetime2](7) NOT NULL,
	[DeviceInfo] [nvarchar](500) NULL,
	[IsNegative] [bit] NOT NULL,
	[ZendeskTicketId] [nvarchar](50) NULL,
	[CreatedAt] [datetime2](7) NULL,
	[ProcessedAt] [datetime2](7) NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()	NULL
	PRIMARY KEY([VendorId] ,[ExternalId])

)
