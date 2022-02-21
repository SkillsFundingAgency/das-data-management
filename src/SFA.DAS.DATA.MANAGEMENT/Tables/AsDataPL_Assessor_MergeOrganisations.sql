CREATE TABLE [AsData_PL].[Assessor_MergeOrganisations]
(
	[Id]										[int]  NOT NULL,
	[PrimaryEndPointAssessorOrganisationId]		[nvarchar](12) NOT NULL,
	[PrimaryEndPointAssessorOrganisationName]	[nvarchar](100) NOT NULL,
	[SecondaryEndPointAssessorOrganisationId]	[nvarchar](12) NOT NULL,
	[SecondaryEndPointAssessorOrganisationName] [nvarchar](100) NOT NULL,
	[SecondaryEPAOEffectiveTo]					[datetime2](7) NOT NULL,
	[CreatedAt]									[datetime2](7) NOT NULL,
	[UpdatedAt]									[datetime2](7) NULL,
	[Status]									[nvarchar](11) NOT NULL,	
	[ApprovedAt]								[datetime2](7) NULL,	
	[CompletedAt]								[datetime2](7) NULL,	
	[AsDm_UpdatedDateTime] datetime2 default(getdate())
)
;
