CREATE TABLE [ASData_PL].[Resv_Course](
	[CourseId] [varchar](20) NOT NULL,
	[Title] [varchar](500) NOT NULL,
	[Level] [tinyint] NOT NULL,
	[EffectiveTo] [datetime] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
PRIMARY KEY CLUSTERED  ([CourseId] ASC )) ON [PRIMARY]
GO