CREATE TABLE [ASData_PL].[Digc_SharingEmailAccess]
(
	[Id] [uniqueidentifier] NULL,
	[SharingEmailId] [uniqueidentifier] NULL,
	[AccessedAt] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)