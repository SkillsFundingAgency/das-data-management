CREATE TABLE [ASData_PL].[LTM_ApplicationEmailAddress]
(
	[Id] [int]						NOT NULL,
	[ApplicationId] [int]			NOT NULL,
	[EmailAddress] [nvarchar](50)	NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
