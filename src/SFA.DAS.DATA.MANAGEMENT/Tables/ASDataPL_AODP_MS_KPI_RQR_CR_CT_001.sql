CREATE TABLE [ASData_PL].[AODP_MS_KPI_RQR_CR_CT_001]
(
	[Qan] [varchar](10) NULL,
	[QualificationName] [varchar](250) NULL,
	[VersionNumber_StartReviewCycle] [int] NULL,
	[VersionNumber_EndReviewCycle] [int] NULL,
	[Status] [varchar](250) NULL,
	[IsOutcomeDecision] [int] NULL,
	[Duration_Hours] [int] NULL,
	[InsertedTimestamp] [datetime] NULL,
	[AsDm_UpdatedDateTime]  [datetime2](7)	DEFAULT (getdate())
);
