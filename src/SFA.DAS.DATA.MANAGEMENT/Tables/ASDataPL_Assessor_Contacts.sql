CREATE TABLE [ASData_PL].[Assessor_Contacts](
	[Id] [uniqueidentifier] NOT NULL,
	[CreatedAt] [datetime2](7) NOT NULL,
	[DeletedAt] [datetime2](7) NULL,
	[EndPointAssessorOrganisationId] [nvarchar](12) NULL,
	[OrganisationId] [uniqueidentifier] NULL,
	[Status] [nvarchar](20) NOT NULL,
	[UpdatedAt] [datetime2](7) NULL,
	[SignInType] [nvarchar](20) NOT NULL,
	[SignInId] [uniqueidentifier] NULL,
	[AsDm_UpdatedDateTime]			[Datetime2](7)		default getdate()
)