CREATE TABLE [Asdata_PL].[EVS_ApprovalsStatus](
	[ApprovalsStatusId] [smallint] NOT NULL,
	[Status] [varchar](100) NULL,
    [AsDm_UpdatedDateTime]	DateTime2 default(getdate())
)
