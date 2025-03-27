/****** Object:  Table [regulated].[MS_KPI_RQR_CR_CT_001]    Script Date: 27/03/2025 11:57:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
) 
GO
