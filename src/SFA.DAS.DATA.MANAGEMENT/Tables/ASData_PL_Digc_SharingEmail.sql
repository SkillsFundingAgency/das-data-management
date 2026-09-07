CREATE TABLE [ASData_PL].[Digc_SharingEmail]
(
	[Id] [uniqueidentifier] NULL,
	[SharingId] [uniqueidentifier] NULL,
	[EmailAddress] [varchar](254) NULL,
	[EmailLinkCode] [uniqueidentifier] NULL,
	[SentTime] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)