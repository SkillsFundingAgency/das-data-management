﻿CREATE PROCEDURE [dbo].[ImportPublicSectorReportDataToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Sarma Evani
-- Create Date: 19/May/2021
-- Description: Import, Transform and Load Public Sector Data Presentation Layer Table
-- ==========================================================================================================
BEGIN TRY
		DECLARE @LogID int
	    DECLARE @DynSQL   NVarchar(max)
		/* Start Logging Execution */

			  INSERT INTO Mgmt.Log_Execution_Results
				  (
					RunId
				   ,StepNo
				   ,StoredProcedureName
				   ,StartDateTime
				   ,Execution_Status
				  )
			  SELECT 
					@RunId
				   ,'Step-6'
				   ,'ImportPublicSectorReportDataToPL'
				   ,getdate()
				   ,0

			  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
			  WHERE StoredProcedureName='ImportPublicSectorReportDataToPL'
			  AND RunId=@RunID

			BEGIN TRANSACTION
				
				TRUNCATE TABLE [AsData_PL].[PubSector_Report];

				;with basedata As
				(
				SELECT [DasAccountId]
					  ,[FullTimeEquivalent_atStart]
					  ,[ID_FullTimeEquivalent]
					  ,[OrganisationName]
					  ,[IsLocalAuthority]
					  ,[Questions_AnythingElse_Answer]
					  ,[Questions_AnythingElse_Id]
					  ,[Questions_Challenges_Answer]
					  ,[Questions_Challenges_Id]
					  ,[Questions_OutlineActions_Answer]
					  ,[Questions_OutlineActions_Id]
					  ,[Questions_TargetPlans_Answer]
					  ,[Questions_TargetPlans_Id]
					  ,[ReportingPeriod]
					  ,CalendarData.ReportingPeriodLabel
					  ,[SubmittedAt]
					  ,[SubmittedEmail]
					  ,[SubmittedName]
					  ,[SummaryText_FullTimeEquivalent]
					  ,[ZenDeskLabel_FullTimeEquivalent]
					  ,[YourApprentices_AtEnd]
					  ,[YourApprentices_AtStart]
					  ,[YourApprentices_NewThisPeriod]
					  ,[YourEmployees_AtEnd]
					  ,[YourEmployees_AtStart]
					  ,[YourEmployees_NewThisPeriod]  
					  ,YourEmployeesExcludingMainatainedSchools_AtStart
	   				  ,YourEmployeesExcludingMainatainedSchools_AtEnd
					  ,YourEmployeesExcludingMainatainedSchools_NewThisPeriod
					  ,YourApprenticesExcludingMainatainedSchools_AtStart
					  ,YourApprenticesExcludingMainatainedSchools_AtEnd
					  ,YourApprenticesExcludingMainatainedSchools_NewThisPeriod
					  ,YourEmployeesMaintainedSchoolsOnly_AtStart
					  ,YourEmployeesMaintainedSchoolsOnly_AtEnd
					  ,YourEmployeesMaintainedSchoolsOnly_NewThisPeriod
					  ,YourApprenticesMaintainedSchoolsOnly_AtStart
					  ,YourApprenticesMaintainedSchoolsOnly_AtEnd
					  ,YourApprenticesMaintainedSchoolsOnly_NewThisPeriod   	  
					  ,cast(coalesce([YourApprentices_NewThisPeriod],0) as float)/ cast(case when [YourEmployees_NewThisPeriod] IS NULL or [YourEmployees_NewThisPeriod] = 0 then 1 Else [YourEmployees_NewThisPeriod] end as int) As FigureE
					  ,cast(coalesce([YourApprentices_AtEnd],0) as float) / cast(case when [YourEmployees_AtEnd] IS NULL or [YourEmployees_AtEnd] = 0 then 1 Else [YourEmployees_AtEnd] end as int) As FigureF
					  ,cast(coalesce([YourApprentices_AtStart],0) as float) / cast(case when [YourEmployees_AtStart] IS NULL or [YourEmployees_AtStart] = 0 then 1 Else [YourEmployees_AtStart] end as int) As FigureI
					  ,1 As FlagLatest
				  FROM [Stg].[PublicSector_Report]  LEFT JOIN 
				  (
						SELECT distinct replace([TaxYear],'-','') As RptPeriod, '1 April 20' + SUBSTRING([TaxYear],1,2) + ' To 31 March 20' + SUBSTRING([TaxYear],4,2) As ReportingPeriodLabel  FROM [dbo].[DASCalendarMonth]
				  ) As CalendarData  on [Stg].[PublicSector_Report].[ReportingPeriod] = CalendarData.RptPeriod
				)
				, OutlineActionsAnswers  As 
				(SELECT [DasAccountId],[ReportingPeriod],count(value) As OutlineActionsAnswers_Count FROM basedata CROSS APPLY STRING_SPLIT(trim([Questions_OutlineActions_Answer]),' ')  where [Questions_OutlineActions_Answer] != '' group by [DasAccountId],[ReportingPeriod])
				, TargetPlanAnswers  As 
				(SELECT [DasAccountId],[ReportingPeriod],count(value) As TargetPlanAnswers_Count FROM basedata CROSS APPLY STRING_SPLIT(trim([Questions_TargetPlans_Answer]),' ')  where [Questions_TargetPlans_Answer] != '' group by [DasAccountId],[ReportingPeriod])
				, ChallengesAnswers  As 
				(SELECT [DasAccountId],[ReportingPeriod],count(value) As ChallengesAnswers_Count FROM basedata CROSS APPLY STRING_SPLIT(trim([Questions_Challenges_Answer]),' ')  where [Questions_Challenges_Answer] != '' group by [DasAccountId],[ReportingPeriod])
				, AnythingElseAnswers  As 
				(SELECT [DasAccountId],[ReportingPeriod],count(value) As AnythingElseAnswers_Count FROM basedata CROSS APPLY STRING_SPLIT(trim([Questions_AnythingElse_Answer]),' ')  where [Questions_AnythingElse_Answer] != '' group by [DasAccountId],[ReportingPeriod])
				INSERT INTO [AsData_PL].[PubSector_Report]
				(
						DasAccountId,
						OrganisationName,
						DasOrganisationName,
						ReportingPeriod,
						ReportingPeriodLabel,
						EmployeesNewThisPeriod,
						ApprenticesNewThisPeriod,
						AppEmpNewThisPeriod,
						EmployeesAtEnd,
						ApprenticesAtEnd,
						AppEmpAtEnd,
						ApprenticesAtStart,
						EmployeesAtStart,
						AppEmpAtStart,
						FullTimeEquivalent,
						OutlineActions,
						OutlineActionsWordCount,
						Challenges,
						ChallengesWordCount,
						TargetPlans,
						TargetPlansWordCount,
						AnythingElse,
						AnythingElseWordCount,
						SubmittedAt,
						SubmittedName,
						SubmittedEmail,
						FlagLatest,
						IsLocalAuthority,
						EmployeesExcludingMainatainedSchools_AtStart,
						EmployeesExcludingMainatainedSchools_AtEnd,
						EmployeesExcludingMainatainedSchools_NewThisPeriod,
						ApprenticesExcludingMainatainedSchools_AtStart,
						ApprenticesExcludingMainatainedSchools_AtEnd,
						ApprenticesExcludingMainatainedSchools_NewThisPeriod,
						EmployeesMaintainedSchoolsOnly_AtStart,
						EmployeesMaintainedSchoolsOnly_AtEnd,
						EmployeesMaintainedSchoolsOnly_NewThisPeriod,
						ApprenticesMaintainedSchoolsOnly_AtStart,
						ApprenticesMaintainedSchoolsOnly_AtEnd,
						ApprenticesMaintainedSchoolsOnly_NewThisPeriod
				)
				select 
						basedata.DasAccountId					 
						,[OrganisationName]
						,[OrganisationName]
						,basedata.[ReportingPeriod]
						,[ReportingPeriodLabel]
						,[YourEmployees_NewThisPeriod]
						,[YourApprentices_NewThisPeriod]
						,[FigureE]
						,[YourEmployees_AtEnd]
						,[YourApprentices_AtEnd]
						,[FigureF]
						,[YourApprentices_AtStart]
						,[YourEmployees_AtStart]
						,[FigureI]
						,[FullTimeEquivalent_atStart]					  
						,[Questions_OutlineActions_Answer]
						,[OutlineActionsAnswers_Count]
						,[Questions_Challenges_Answer]
						,[ChallengesAnswers_Count]
						,[Questions_TargetPlans_Answer]
						,TargetPlanAnswers_Count
						,[Questions_AnythingElse_Answer]
						,[AnythingElseAnswers_Count]					  
						,[SubmittedAt]						
						,[SubmittedName]		
						,[SubmittedEmail]
						,[FlagLatest]
						,cast([IsLocalAuthority] AS bit)
						,YourEmployeesExcludingMainatainedSchools_AtStart
						,YourEmployeesExcludingMainatainedSchools_AtEnd
						,YourEmployeesExcludingMainatainedSchools_NewThisPeriod
						,YourApprenticesExcludingMainatainedSchools_AtStart
						,YourApprenticesExcludingMainatainedSchools_AtEnd
						,YourApprenticesExcludingMainatainedSchools_NewThisPeriod
						,YourEmployeesMaintainedSchoolsOnly_AtStart
						,YourEmployeesMaintainedSchoolsOnly_AtEnd
						,YourEmployeesMaintainedSchoolsOnly_NewThisPeriod
						,YourApprenticesMaintainedSchoolsOnly_AtStart
						,YourApprenticesMaintainedSchoolsOnly_AtEnd
						,YourApprenticesMaintainedSchoolsOnly_NewThisPeriod   
				from basedata
				LEFT JOIN  OutlineActionsAnswers OAA on  basedata.DasAccountId =  OAA.DasAccountId and basedata.[ReportingPeriod] =  OAA.[ReportingPeriod]
				LEFT JOIN  TargetPlanAnswers TPA on  basedata.DasAccountId =  TPA.DasAccountId and basedata.[ReportingPeriod] =  TPA.[ReportingPeriod]
				LEFT JOIN  ChallengesAnswers CA on  basedata.DasAccountId =  CA.DasAccountId and basedata.[ReportingPeriod] =  CA.[ReportingPeriod]
				LEFT JOIN  AnythingElseAnswers AEA on  basedata.DasAccountId =  AEA.DasAccountId and basedata.[ReportingPeriod] =  AEA.[ReportingPeriod]

				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='PublicSector_Report' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				  DROP TABLE [Stg].[PublicSector_Report]
				
			COMMIT TRANSACTION

					UPDATE Mgmt.Log_Execution_Results
					   SET Execution_Status=1
						  ,EndDateTime=getdate()
						  ,FullJobStatus='Pending'
					 WHERE LogId=@LogID
					   AND RunId=@RunId
END TRY
BEGIN CATCH
			IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION;

			DECLARE @ErrorId int

		  INSERT INTO Mgmt.Log_Error_Details
			  (UserName
			  ,ErrorNumber
			  ,ErrorState
			  ,ErrorSeverity
			  ,ErrorLine
			  ,ErrorProcedure
			  ,ErrorMessage
			  ,ErrorDateTime
			  ,RunId
			  )
		  SELECT 
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				'ImportPublicSectorReportDataToPL',
				ERROR_MESSAGE(),
				GETDATE(),
				@RunId as RunId; 

		  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

		/* Update Log Execution Results as Fail if there is an Error*/

		UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=0
			  ,EndDateTime=getdate()
			  ,ErrorId=@ErrorId
		 WHERE LogId=@LogID
		   AND RunID=@RunId
  END CATCH