﻿CREATE TABLE [AsData_PL].[Assessor_Learner]
(
	[Id]							[uniqueidentifier]	NOT NULL,
	[Uln]							[bigint]			NULL,
	[UkPrn]							[int]				NULL,
	[StdCode]						[int]				NULL,
	[LearnStartDate]				[datetime2](7)		NULL,
	[EpaOrgId]						[nvarchar](50)		NULL,
	[FundingModel]					[int]				NULL,
	[ApprenticeshipId]				[bigint]			NULL,
	[Source]						[nvarchar](10)		NULL,	
	[CompletionStatus]				[int]				NULL,
	[PlannedEndDate]				[datetime2](7)		NULL,	
	[LearnActEndDate]				[datetime2](7)		NULL,
	[WithdrawReason]				[int]				NULL,
	[Outcome]						[int]				NULL,
	[AchDate]						[datetime]			NULL,
	[OutGrade]						[nvarchar](50)		NULL,
	[Version]						[nvarchar](10)		NULL,
	[VersionConfirmed]				[bit]				NOT NULL,
	[CourseOption]					[nvarchar](126)		NULL,
	[StandardUId]					[nvarchar](20)		NULL,
	[StandardReference]				[nvarchar](10)		NULL,
	[StandardName]					[nvarchar](1000)	NULL,
	[LastUpdated]					[date]				NULL,
	[EstimatedEndDate]				[date]				NULL,
	[ApprovalsStopDate]				[date]				NULL,
	[ApprovalsPauseDate]			[date]				NULL,
	[ApprovalsCompletionDate]		[date]				NULL,
	[ApprovalsPaymentStatus]		[smallint]			NULL,
	[LatestIlrs]					[datetime]			NULL,
	[LatestApprovals]				[datetime]			NULL,
	[IsTransfer]                    [bit]				NULL,
	[DelLoc_Pst_Lower_Layer_SOA]    [nvarchar](9)		NULL,                  
	[DelLoc_Pst_Lower_Layer_SOA2001][nvarchar](9)		NULL,    
	[AsDm_UpdatedDateTime]			[Datetime2](7)		default getdate()
)


GO
CREATE NONCLUSTERED INDEX IDX_Learner_WatermarkColumn
ON [ASData_PL].[Assessor_Learner] (LastUpdated);