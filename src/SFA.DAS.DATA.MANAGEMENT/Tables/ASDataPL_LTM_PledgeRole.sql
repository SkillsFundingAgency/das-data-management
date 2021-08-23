CREATE TABLE [ASData_PL].[LTM_PledgeRole]
(
	[PledgeRoleId] [int] NOT NULL,
	[RoleId] [tinyint] NOT NULL,
	[PledgeId] [int] NOT NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
