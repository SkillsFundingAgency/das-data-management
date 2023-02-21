CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderCourse]
(	
	[Id]					bigint					NOT NULL,
	[ProviderId]			int						NOT NULL,
	[StandardInfoUrl]		varchar(1000)			NULL,
	[ContactUsEmail]		varchar(260)			NULL,
	[LarsCode]				int						NULL,
	[IsApprovedByRegulator]	bit						NULL,
    [IsImported]			bit						NULL,
    [HasPortableFlexiJobOption]bit					NULL,
	[AsDm_UpdatedDateTime] [datetime2](7)		DEFAULT (getdate())	
)
