CREATE TABLE [ASData_PL].[FAT2_ProviderRegistration]
(
		[UkPrn]					int				NOT NULL,
		[StatusDate]			datetime		NOT NULL,
		[StatusId]				int				NOT NULL,
		[ProviderTypeId]		int				NOT	NULL,
		[OrganisationTypeId]    int				NOT NULL,
		[FeedbackTotal]			int				NOT NULL,	
		[Postcode]				varchar(20)		NULL,
		[Lat]					float			NULL,
		[Long]					float			NULL,
		[LegalName]				varchar(1000)	NULL,
		[AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate()),
		PRIMARY KEY CLUSTERED ([UkPrn] ASC) ON [PRIMARY]
)ON [PRIMARY]