CREATE TABLE [ASData_PL].[PREL_Requests]
(

	[Id] uniqueidentifier NOT NULL,
	[RequestType] nvarchar(20) NOT NULL,
	[Ukprn] bigint NOT NULL,
	[RequestedBy] nvarchar(255) NOT NULL,
	[RequestedDate] datetime2(7) NOT NULL,
	[AccountLegalEntityId] bigint NULL,
	[EmployerOrganisationName] nvarchar(250) NULL,
	[EmployerPAYE] nvarchar(16) NULL,
	[EmployerAORN] nvarchar(25) NULL,
	[Status] nvarchar(10) NOT NULL,
	[ActionedBy] nvarchar(255) NULL,
	[UpdatedDate] datetime2(7) NULL,
	[AsDm_UpdatedDateTime]	Datetime2(7)		default getdate()
)
