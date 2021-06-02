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

				INSERT INTO #StgClientIDs(ClientId,ClientIDSource)
				SELECT [ClientId],'STG'
				FROM   [Stg].[GA_SessionDataDetail]  with (nolock)
				WHERE  [StgImportDate] > @importdatetime AND 
				(COALESCE([ESFAToken],[EventLabel_ESFAToken],[CD_ESFAToken]) IS NOT NULL Or COALESCE(EmployerID,[CD_EmployerId]) IS NOT NULL) 
				GROUP BY  [ClientId]
		
				INSERT INTO #StgClientIDs(ClientId,ClientIDSource)
				SELECT [ClientId],'PL'
				FROM   [ASData_PL].[GA_SessionData]  with (nolock)
				WHERE ClientId   NOT IN (Select ClientId from #StgClientIDs Where ClientIDSource='STG')
				GROUP BY [ClientId]

				Insert into [ASData_PL].[GA_SessionData]
				(
					[FullVisitorId],[ClientId],[VisitId],[VisitNumber],[VisitStartDateTime],
					[VisitDate],[VisitorId],[UserId],[Hits_Page_Hostname],[Hits_Page_PageTitle],[TrafficSource_Campaign],
					[Hits_Page_PagePath],[Hits_Time],[Hits_IsEntrance],
					[Hits_IsExit],[Hits_Type],[EmployerId],[ID2],[ID3],[ESFAToken],[EventCategory],[EventAction],[EventLabel_ESFAToken],
					[EventLabel_Keyword],[EventLabel_Postcode],[EventLabel_WithinDistance],[EventLabel_Level],
					[CD_ClientId],[CD_SearchTerms],[CD_UserId],[CD_LevyFlag],[CD_EmployerId],[CD_ESFAToken],[CD_LegalEntityId],[CD_IsCookieless],[ESFATokenFlag],										
					[SignIn],[SignedAgreement],[SignUp],[ReservedFunding],[Commitment],[CreatedAccount],[GovernmentGateway],[AORN],[ApplyNowIncentives],
					[IncentivesApplyNow],[GA_ImportDate]
				)
				Select 
				[FullVisitorId],GAData.[ClientId],[VisitId],[VisitNumber],[VisitStartDateTime],
				[VisitDate],[VisitorId],[UserId],[Hits_Page_Hostname],[Hits_Page_PageTitle],[TrafficSource_Campaign],
				[Hits_Page_PagePath],[Hits_Time],[Hits_IsEntrance],
				[Hits_IsExit],[Hits_Type],[EmployerId],[ID2],[ID3],trim(replace(upper([ESFAToken]),'P','')) As [ESFAToken],[EventCategory],[EventAction],trim(replace(upper([EventLabel_ESFAToken]),'P','')) As [EventLabel_ESFAToken],
				[EventLabel_Keyword],[EventLabel_Postcode],[EventLabel_WithinDistance],[EventLabel_Level],
				[CD_ClientId],[CD_SearchTerms],[CD_UserId],[CD_LevyFlag],[CD_EmployerId],trim(replace(upper([CD_ESFAToken]),'P','')) As [CD_ESFAToken],[CD_LegalEntityId],[CD_IsCookieless],[ESFATokenFlag],				
				case when hits_page_pagePath like '%accounts/agreements/page-company-homepage%' and hits_page_pagePath  like '%page-auth-homepage%'  Then 1 Else 0 End SignIn,
                case when hits_page_pagePath like '%accounts/agreements/accepted-employer-agreement%' Then 1 Else 0 End SignedAgreement,
                case when (
                        Case when hits_page_pagePath like '%page-confirm-identity' Then 1 
                            when hits_page_pagePath like '%service/getApprenticeshipFunding/get-government-funding' Then 2 
                            Else 0 
                        End
                        ) = 2 Then 1 Else 0 End  
				SignUp,
                case when hits_page_pagePath like '%/accounts/reservations/completed%' Then 1 Else 0 End ReservedFunding,
                case when hits_page_pagePath like '%/unapproved/cohort/approved%' Then 1 Else 0 End Commitment,
                case when (
                            Case when hits_page_pagePath like '%page-confirm-identity' Then 1 
                                 when hits_page_pagePath like '%service/getApprenticeshipFunding/get-government-funding' Then 2 
                                 Else 0 
                            End
                          ) = 2 Then 1 Else 0 End CreatedAccount,                
                case when (
                                Case when hits_page_pagePath like '%/gatewayInform' Then 1 
                                    when hits_page_pagePath like '%/page-company-homepage%' Then 2 
                                    Else 0 
                                End
                          ) =  2 Then 1 Else 0 End as GovernmentGateway,        
                Case when (
                            Case when hits_page_pagePath like '%/onboarding/address/update/page-extra-confirm-organisation' Then 1 
                                when hits_page_pagePath like '%/page-company-homepage%' Then 2 
                                Else 0 
                            End
                           ) = 2 Then 1 Else 0 End 
                as AORN,
                case when hits_page_hostname like '%employer-incentives.manage-apprenticeships.service.gov.uk%' and  hits_page_pagepath like '%/application-complete/%'  Then 1 Else 0 End as ApplyNowIncentives,  
				case when hits_page_pagepath like '%engage.apprenticeships.gov.uk/Incentives_ApplyNow%' Then 1 Else 0 End As IncentivesApplyNow, 								
				getdate()
				FROM [Stg].[GA_SessionDataDetail] GAData with (nolock) JOIN #StgClientIDs ClientIDs
				ON GAData.ClientId =  ClientIDs.ClientId
				Where GAData.[StgImportDate] > @importdatetime AND ClientIDSource ='PL'

				Insert into [ASData_PL].[GA_SessionData]
				(
					[FullVisitorId],[ClientId],[VisitId],[VisitNumber],[VisitStartDateTime],
					[VisitDate],[VisitorId],[UserId],[Hits_Page_Hostname],[Hits_Page_PageTitle],[TrafficSource_Campaign],
					[Hits_Page_PagePath],[Hits_Time],[Hits_IsEntrance],
					[Hits_IsExit],[Hits_Type],[EmployerId],[ID2],[ID3],[ESFAToken],[EventCategory],[EventAction],[EventLabel_ESFAToken],
					[EventLabel_Keyword],[EventLabel_Postcode],[EventLabel_WithinDistance],[EventLabel_Level],
					[CD_ClientId],[CD_SearchTerms],[CD_UserId],[CD_LevyFlag],[CD_EmployerId],[CD_ESFAToken],[CD_LegalEntityId],[CD_IsCookieless],[ESFATokenFlag],										
					[SignIn],[SignedAgreement],[SignUp],[ReservedFunding],[Commitment],[CreatedAccount],[GovernmentGateway],[AORN],[ApplyNowIncentives],
					[IncentivesApplyNow],[GA_ImportDate]
				)
				Select 
				[FullVisitorId],GAData.[ClientId],[VisitId],[VisitNumber],[VisitStartDateTime],
				[VisitDate],[VisitorId],[UserId],[Hits_Page_Hostname],[Hits_Page_PageTitle],[TrafficSource_Campaign],
				[Hits_Page_PagePath],[Hits_Time],[Hits_IsEntrance],
				[Hits_IsExit],[Hits_Type],[EmployerId],[ID2],[ID3],trim(replace(upper([ESFAToken]),'P','')) As [ESFAToken],[EventCategory],[EventAction],trim(replace(upper([EventLabel_ESFAToken]),'P','')) As [EventLabel_ESFAToken],
				[EventLabel_Keyword],[EventLabel_Postcode],[EventLabel_WithinDistance],[EventLabel_Level],
				[CD_ClientId],[CD_SearchTerms],[CD_UserId],[CD_LevyFlag],[CD_EmployerId],trim(replace(upper([CD_ESFAToken]),'P','')) As [CD_ESFAToken],[CD_LegalEntityId],[CD_IsCookieless],[ESFATokenFlag],				
				case when hits_page_pagePath like '%accounts/agreements/page-company-homepage%' and hits_page_pagePath  like '%page-auth-homepage%'  Then 1 Else 0 End SignIn,
                case when hits_page_pagePath like '%accounts/agreements/accepted-employer-agreement%' Then 1 Else 0 End SignedAgreement,
                case when (
                        Case when hits_page_pagePath like '%page-confirm-identity' Then 1 
                            when hits_page_pagePath like '%service/getApprenticeshipFunding/get-government-funding' Then 2 
                            Else 0 
                        End
                        ) = 2 Then 1 Else 0 End  
				SignUp,
                case when hits_page_pagePath like '%/accounts/reservations/completed%' Then 1 Else 0 End ReservedFunding,
                case when hits_page_pagePath like '%/unapproved/cohort/approved%' Then 1 Else 0 End Commitment,
                case when (
                            Case when hits_page_pagePath like '%page-confirm-identity' Then 1 
                                 when hits_page_pagePath like '%service/getApprenticeshipFunding/get-government-funding' Then 2 
                                 Else 0 
                            End
                          ) = 2 Then 1 Else 0 End CreatedAccount,                
                case when (
                                Case when hits_page_pagePath like '%/gatewayInform' Then 1 
                                    when hits_page_pagePath like '%/page-company-homepage%' Then 2 
                                    Else 0 
                                End
                          ) =  2 Then 1 Else 0 End as GovernmentGateway,        
                Case when (
                            Case when hits_page_pagePath like '%/onboarding/address/update/page-extra-confirm-organisation' Then 1 
                                when hits_page_pagePath like '%/page-company-homepage%' Then 2 
                                Else 0 
                            End
                           ) = 2 Then 1 Else 0 End 
                as AORN,
                case when hits_page_hostname like '%employer-incentives.manage-apprenticeships.service.gov.uk%' and  hits_page_pagepath like '%/application-complete/%'  Then 1 Else 0 End as ApplyNowIncentives,  
				case when hits_page_pagepath like '%engage.apprenticeships.gov.uk/Incentives_ApplyNow%' Then 1 Else 0 End As IncentivesApplyNow, 
				getdate()
				FROM [Stg].[GA_SessionDataDetail] GAData with (nolock) JOIN #StgClientIDs ClientIDs
				ON GAData.ClientId =  ClientIDs.ClientId
				Where GAData.[StgImportDate] > @importdatetime AND ClientIDSource ='STG'
		
				IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='GA_SessionDataDetail' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				TRUNCATE TABLE [Stg].[GA_SessionDataDetail]				
				
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