CREATE TABLE [ASData_PL].[Appsi_Vendor]
(
	[Id] [tinyint] NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate() NULL
)
