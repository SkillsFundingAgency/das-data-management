CREATE TABLE [AsData_PL].[Assessor_OrganisationStandardVersion]
(
	[OrganisationStandardVersionID]  [BigInt]			IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[StandardUId]					 [varchar](20)		NOT NULL,
	[Version]						 [decimal](18, 1)	NULL,
	[OrganisationStandardId]		 [int]				NOT NULL,
	[EffectiveFrom]					 [datetime]			NULL,
	[EffectiveTo]					 [datetime]			NULL,
	[DateVersionApproved]			 [datetime]			NULL,
	[Comments]					     [nvarchar](500)	NULL,
	[Status]					     [nvarchar](10)		NULL,
	[AsDm_UpdatedDateTime]		     [Datetime2](7)		default getdate()
)
