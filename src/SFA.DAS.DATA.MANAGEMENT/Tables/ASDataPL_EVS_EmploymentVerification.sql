CREATE TABLE [AsData_PL].[EVS_EmploymentVerification](
	[EmploymentVerificationId] [bigint]  NOT NULL PRIMARY KEY ,
	[CorrelationId] [uniqueidentifier] NOT NULL,
	[ApprenticeshipId] [bigint] NULL,
	[Employed] [bit] NULL,
	[EmploymentCheckDate] [datetime2](7) NULL,
	[EmploymentCheckRequestDate] [datetime2](7) NULL,
	[RequestCompletionStatus] [smallint] NULL,
	[ErrorType] [varchar](200) NULL,
	[MessageSentDate] [datetime2](7) NULL,
	[MinDate] [date] NULL,
	[MaxDate] [date] NULL,
	[CheckTypeId] [smallint] NOT NULL,
	[CreatedOn] [datetime2](7) NULL,
	[LastUpdatedOn] [datetime2](7) NULL,
	[IsDeleted] BIT NOT NULL,
	[AsDm_UpdatedDateTime]	DateTime2 default(getdate())
)
