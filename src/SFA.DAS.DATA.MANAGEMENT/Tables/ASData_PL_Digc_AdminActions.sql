CREATE TABLE [ASData_PL].[Digc_AdminActions]
(
	[Id] [uniqueidentifier] NULL,
	[Username] [varchar](255) NULL,
	[ActionTime] [datetime2](7) NULL,
	[Action] [varchar](50) NULL,
	[UserActionId] [bigint] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate()

)