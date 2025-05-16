CREATE TABLE [ASData_PL].[AODP_Applications](
	[Id] [uniqueidentifier] PRIMARY KEY NOT NULL,
	[FormVersionId] [uniqueidentifier] NOT NULL,
	[OrganisationId] [uniqueidentifier] NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Owner] [nvarchar](4000) NOT NULL,
	[Submitted] [bit] NULL,
	[SubmittedAt] [date] NULL,
	[CreatedAt] [datetime] NULL,
	[QualificationNumber] [nvarchar](100) NULL,
	[ReferenceId] [int] NOT NULL,
	[UpdatedAt] [datetime] NOT NULL,
	[Status] [nvarchar](100) NULL,
	[AwardingOrganisationName] [nvarchar](400) NULL,
	[AwardingOrganisationUkprn] [nvarchar](100) NULL,
	[NewMessage] [bit] NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
)