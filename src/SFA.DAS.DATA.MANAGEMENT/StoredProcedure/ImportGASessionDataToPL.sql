CREATE PROCEDURE [dbo].[ImportGASessionDataToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Sarma Evani
-- Create Date: 12/Jan/2021
-- Description: Import GA Session data to PL 
-- ==========================================================================================================
BEGIN TRY
		DECLARE @LogID int
		DECLARE @importdatetime datetime2(7) 
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
			   ,'ImportGASessionDataToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		  WHERE StoredProcedureName='ImportGASessionDataToPL'
			 AND RunId=@RunID
		 
		IF OBJECT_ID(N'tempdb..#StgClientIDs') IS NOT NULL
			DROP TABLE #StgClientIDs

		 CREATE TABLE #StgClientIDs(ClientId NVARCHAR(500),ClientIDSource  Varchar(50))

		BEGIN TRANSACTION		
		        
				if (select count([GASD_Id]) from [ASData_PL].[GA_SessionData]  with (nolock))  > 0 
					Select @importdatetime = ISNULL(max([GA_ImportDate]),cast('01-01-1900'  as datetime2(7))) from [ASData_PL].[GA_SessionData] with (nolock)
				else
					Set @importdatetime = cast('01-01-1900' as datetime2(7))


				Insert into [ASData_PL].[GA_SessionData]
				(
					[FullVisitorId],[ClientId],[VisitId],[VisitNumber],[VisitStartDateTime],
					[VisitDate],[VisitorId],[UserId],[Hits_Page_Hostname],[Hits_Page_PageTitle],[TrafficSource_Campaign],
					[Hits_Page_PagePath],[Hits_Time],[Hits_IsEntrance],
					[Hits_IsExit],[Hits_Type],[EmployerId],[ID2],[ID3],[ESFAToken],[EventCategory],[EventAction],[EventLabel_ESFAToken],
					[EventLabel_Keyword],[EventLabel_Postcode],[EventLabel_WithinDistance],[EventLabel_Level],
					[CD_ClientId],[CD_SearchTerms],[CD_UserId],[CD_LevyFlag],[CD_EmployerId],[CD_ESFAToken],[CD_LegalEntityId],[CD_IsCookieless],[ESFATokenFlag],										
					[SignIn],[SignedAgreement],[SignUp],[ReservedFunding],[Commitment],[CreatedAccount],[GovernmentGateway],[AORN],[ApplyNowIncentives],
					[IncentivesApplyNow],[GA_ImportDate],[CD_VacancyID], [CD_ApprenticeshipID],[TrafficSource_Source]
				)
				Select 
				NULL [FullVisitorId],GAData.[ClientId],NULL [VisitId],NULL [VisitNumber],NULL [VisitStartDateTime],
				[VisitDate],NULL [VisitorId],NULL [UserId],NULL [Hits_Page_Hostname],NULL [Hits_Page_PageTitle],[TrafficSource_Campaign],
				[Hits_Page_PagePath],NULL [Hits_Time],NULL [Hits_IsEntrance],
				NULL [Hits_IsExit],NULL [Hits_Type],NULL [EmployerId],NULL [ID2],NULL [ID3],trim(replace(upper([ESFAToken]),'P','')) As [ESFAToken],NULL [EventCategory],NULL [EventAction],trim(replace(upper([EventLabel_ESFAToken]),'P','')) As [EventLabel_ESFAToken],
				NULL [EventLabel_Keyword],NULL [EventLabel_Postcode],NULL [EventLabel_WithinDistance],NULL [EventLabel_Level],
				NULL [CD_ClientId],[CD_SearchTerms],[CD_UserId],NULL [CD_LevyFlag],[CD_EmployerId],trim(replace(upper([CD_ESFAToken]),'P','')) As [CD_ESFAToken],NULL [CD_LegalEntityId],NULL [CD_IsCookieless],NULL [ESFATokenFlag],				
				NULL SignIn,NULL SignedAgreement,NULL SignUp,NULL ReservedFunding,NULL Commitment,NULL CreatedAccount,NULL GovernmentGateway,NULL AORN, NULL ApplyNowIncentives, 
				NULL IncentivesApplyNow, getdate(),[CD_VacancyID], [CD_ApprenticeshipID],[TrafficSource_Source]
				FROM [Stg].[GA_SessionDataDetail] GAData
				Where GAData.[StgImportDate] > @importdatetime

		
				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='GA_SessionDataDetail' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				TRUNCATE TABLE [Stg].[GA_SessionDataDetail]			
				
			
		COMMIT TRANSACTION

/* Insert Into GA Table with required data for Summarized Reporting */

    BEGIN TRANSACTION

         DELETE FROM [ASData_PL].[GA_DataForReporting]

				INSERT INTO ASData_PL.GA_DataForReporting
				(CD_EmployerId,ESFATOKEN,ClientId,VisitDate,TrafficSource_Campaign,Hits_Page_PagePath,CD_Search_Terms,CD_UserID,CD_VacancyID,CD_ApprenticeshipID,TrafficSource_Source)
				SELECT DISTINCT
                      [CD_EmployerId]
                     ,g.ESFATOKEN
                     ,ga.ClientId
                     ,ga.VisitDate
					 ,ga.TrafficSource_Campaign
					 ,ga.Hits_Page_PagePath
					 ,ga.CD_SearchTerms
					 ,ga.CD_UserID
					 ,ga.CD_VacancyID
					 ,ga.CD_ApprenticeshipID
					 ,ga.TrafficSource_Source
                  FROM ASData_PL.GA_SessionData as ga with (nolock)
            INNER JOIN (SELECT  TRY_CONVERT(BIGINT,coalesce(ESFAToken,[EventLabel_ESFAToken],[CD_ESFAToken])) as ESFAToken,clientid	
                          FROM ASData_PL.GA_SessionData  with (nolock)		
                         WHERE TRY_CONVERT(BIGINT,coalesce(ESFAToken,[EventLabel_ESFAToken],[CD_ESFAToken])) IS NOT NULL) as g
                    ON ga.clientid=g.clientid

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
				'ImportGASessionDataToPL',
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