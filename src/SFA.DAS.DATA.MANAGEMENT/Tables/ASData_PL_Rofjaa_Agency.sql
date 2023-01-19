CREATE TABLE [ASData_PL].[Rofjaa_Agency]
(
	[LegalEntityId] [bigint] NULL,
	[IsGrantFunded] [bit] NULL,
	[EffectiveFrom] [datetime2](7) default getdate() NULL,
	[EffectiveTo] [datetime2](7) NULL,
	[RemovalReason] [nvarchar](max) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[LastUpdatedDate] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)