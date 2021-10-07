CREATE TABLE [AsData_PL].[Comt_StandardOption]
(
	[StandardUId] [nvarchar](20) NOT NULL,
	[Option] [nvarchar](200) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
)
