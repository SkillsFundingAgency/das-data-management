CREATE TABLE  [AsData_PL].[EVS_CommitmentStatus](
	[CommitmentStatusId] [smallint] NOT NULL Primary Key,
	[CommitmentStatus] [varchar](20) NULL,
	[AsDm_UpdatedDateTime]	DateTime2 default(getdate())
)