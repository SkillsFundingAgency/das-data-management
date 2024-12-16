CREATE TABLE [AsData_PL].[EVS_AdhocEmploymentVerification]
(
	[AdhocEmploymentVerificationId] [bigint]  NOT NULL PRIMARY KEY ,
	[CorrelationId] [uniqueidentifier] NOT NULL,
	[ApprenticeshipId] [bigint] NULL,
	[ULN] [bigint] NOT NULL,
	[EmployerAccountId] [bigint] NOT NULL,
	[MinDate] [date] NOT NULL,
	[MaxDate] [date] NOT NULL,
	[CreatedOn] [datetime2](7) NULL,
	[AsDm_UpdatedDateTime]						DateTime2 default(getdate())
)
