﻿CREATE TABLE [AsData_PL].[PubSector_Report]
(
	ReportID							Int							IDENTITY(1,1)  NOT NULL,
	DasAccountId						NVarchar(20)				NOT NULL,
	OrganisationName					NVarchar(250)				NULL,
	DasOrganisationName					NVarchar(250)				NULL,
	ReportingPeriod						NVarchar(25)				NULL,
	ReportingPeriodLabel				NVarchar(250)				NULL,
	EmployeesNewThisPeriod				int							NULL,
	ApprenticesNewThisPeriod			int							NULL,
	AppEmpNewThisPeriod					decimal(8,3)				NULL,	
	EmployeesAtEnd						int							NULL,
	ApprenticesAtEnd					int							NULL,
	AppEmpAtEnd							decimal(8,3)				NULL,
	ApprenticesAtStart					int							NULL,
	EmployeesAtStart					int							NULL,
	AppEmpAtStart						decimal(8,3)				NULL,
	FullTimeEquivalent					int							NULL,
	OutlineActions						nvarchar(4000)				NULL,
	OutlineActionsWordCount				int							NULL,
	Challenges							nvarchar(4000)				NULL,
	ChallengesWordCount					int							NULL,
	TargetPlans							nvarchar(4000)				NULL,
	TargetPlansWordCount				int							NULL,
	AnythingElse						nvarchar(4000)				NULL,
	AnythingElseWordCount				int							NULL,
	SubmittedAt							datetime2(7)				NULL,
	SubmittedName						nvarchar(150)				NULL,
	SubmittedEmail						nvarchar(100)				NULL,
	FlagLatest							smallint					NULL,
	AsDm_UpdatedDateTime				datetime2 default getdate()	NULL
)
