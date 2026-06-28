CREATE TABLE [ASData_PL].[Digc_User]
(
    [Id] [uniqueidentifier] NULL,
	[GovUkIdentifier] [varchar](100) NULL,
	[EmailAddress] [varchar](100) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[LastLoginAt] [datetime2](7) NULL,
	[IsLocked] [bit] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)