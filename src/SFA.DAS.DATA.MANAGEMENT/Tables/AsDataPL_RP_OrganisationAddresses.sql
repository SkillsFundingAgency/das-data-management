CREATE TABLE [AsData_PL].[RP_OrganisationAddresses]
(
	[Id] [int] NULL,
	[OrganisationId] [uniqueidentifier] NULL,
	[AddressType] [tinyint] NULL,
	[AddressLine1] [nvarchar](max) NULL,
	[AddressLine2] [nvarchar](max) NULL,
	[AddressLine3] [nvarchar](max) NULL,
	[City] [nvarchar](200) NULL,
	[Postcode] [nvarchar](10) NULL,
	[AsDm_UpdatedDateTime] DateTime2 default(getdate())
)