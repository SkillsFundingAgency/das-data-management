CREATE TABLE [ASData_PL].[AODP_Messages]
(
	[Id] [uniqueidentifier] PRIMARY KEY NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[Type] [nvarchar](4000) NOT NULL,
	[MessageHeader] [nvarchar](4000) NOT NULL,
	[SharedWithDfe] [bit] NOT NULL,
	[SharedWithOfqual] [bit] NOT NULL,
	[SharedWithSkillsEngland] [bit] NOT NULL,
	[SharedWithAwardingOrganisation] [bit] NOT NULL,
	[SentAt] [datetime] NOT NULL,
	[SentByName] [nvarchar](255) NOT NULL,
	[SentByEmail] [nvarchar](255) NOT NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
	)