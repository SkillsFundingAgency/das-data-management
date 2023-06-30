CREATE TABLE [ASData_PL].[FAT_ROATPV2_Audit]
(
	[Id]					bigint								NOT NULL,
	[UserAction] [nvarchar](256)  NULL,
	[AuditDate] [datetime2](7)  NULL,
	[InitialState] [nvarchar](max) NULL,
	[UpdatedState] [nvarchar](max) NULL,
	[UKPRN][int]								 NULL,
	[LARSCode][int]						 NULL,
	[ProviderId][int]						 NULL,
	[IsApprovedByRegulator][nvarchar](256)  NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
