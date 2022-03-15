CREATE TABLE [ASData_PL].[LTM_Pledge]
(
	[Id] [int]						NOT NULL,
	[EmployerAccountId] [bigint]	NOT NULL,
	[Amount] [int]					NOT NULL,
	[RemainingAmount] [int]			NOT NULL,
	[IsNamePublic] [bit]			NOT NULL,
	[CreatedOn] [datetime2](7)		NOT NULL,
	[JobRoles] [int]				NOT NULL,
	[Levels] [int]					NOT NULL,
	[Sectors] [int]					NOT NULL,
	[ClosedOn] [datetime2]         NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
