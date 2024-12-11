CREATE TABLE [AsData_PL].[EVS_CheckType]
(
	[CheckTypeId] [smallint] NOT NULL Primary Key,
	[CheckType] [varchar](20) NULL,
	[AsDm_UpdatedDateTime]	DateTime2 default(getdate())
)