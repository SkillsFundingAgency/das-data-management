CREATE TABLE [AsData_PL].[CPG_UserData]
(
	[Id] int NOT NULL,
	[FirstName] [varchar](250) NOT NULL,
	[LastName] [varchar](250) NOT NULL,
	[Email] [varchar](250) NOT NULL,
	[UkEmployerSize] [varchar](50) NOT NULL,
	[PrimaryIndustry] [varchar](50) NOT NULL,
	[PrimaryLocation] [varchar](50) NOT NULL,
	[AppsgovSignUpDate] [datetime] NOT NULL,
	[PersonOrigin] [varchar](50) NULL,
	[IncludeInUR] [bit] NULL,
	[Asdm_UpdatedDateTime] datetime2 default getdate(),
    CONSTRAINT PK_CPG_UserData PRIMARY KEY CLUSTERED ([Id])
)