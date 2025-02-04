CREATE TABLE [ASData_PL].[PREL_Notifications]
(

	[Id] uniqueidentifier NOT NULL,
	[TemplateName] nvarchar(200) NOT NULL,
	[NotificationType] nvarchar(10) NOT NULL,
	[Ukprn] bigint NULL,
	[RequestId] uniqueidentifier NULL,
	[AccountLegalEntityId] bigint NULL,
	[PermitApprovals] smallint NULL,
	[PermitRecruit] smallint NULL,
	[CreatedBy] nvarchar(255) NOT NULL,
	[CreatedDate] Datetime2(7),
	[SentTime] Datetime2(7),
	[AsDm_UpdatedDateTime]	Datetime2(7)		default getdate()
)
