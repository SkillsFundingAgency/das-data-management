CREATE TABLE [ASData_PL].[Appsi_App]
(
	[Id] [int]  NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[AppleAppId] [nvarchar](50) NULL,
	[GoogleAppId] [nvarchar](50) NULL,
	[CreatedAt] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate() NULL
)
