CREATE TABLE [AsData_PL].[Comt_Accounts]
(
	[Id] [bigint] NOT NULL,
	[HashedId] [nchar](6) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[Updated] [datetime2](7) NULL,
	[LevyStatus] [tinyint] NOT NULL,
	[AsDm_UpdatedDateTime]	[datetime2]			default getdate()
)
