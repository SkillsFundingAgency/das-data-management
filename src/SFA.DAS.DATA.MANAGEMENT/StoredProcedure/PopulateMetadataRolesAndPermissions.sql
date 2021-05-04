﻿CREATE PROCEDURE [dbo].[PopulateMetadataRolesAndPermissions]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 26/04/2021
-- Description: Populate Metadata Roles And Permissions
-- =========================================================================
*/

BEGIN TRY


DECLARE @LogID int

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
	   ,'Step-3'
	   ,'PopulateMetadataRolesAndPermissions'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='PopulateMetadataRolesAndPermissions'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM Mtd.RolesAndPermissions

INSERT INTO Mtd.RolesAndPermissions
(RoleName, SchemaName, ObjectName, ObjectType, PermissionType, IsSchemaLevelAccess, IsEnabled)
VALUES
/* Developer*/
('Developer','Comt','','','SELECT',1,1),
('Developer','Acct','','','SELECT',1,1),
('Developer ','EAUser','','','SELECT',1,1),
('Developer','Fin','','','SELECT',1,1),
('Developer','Mgmt','','','SELECT',1,1),
('Developer','Resv','','','SELECT',1,1),
('Developer','Pmts','','','SELECT',1,1),
('Developer ','StgPmts','','','SELECT',1,1),
('Developer ','Stg','','','SELECT',1,1),
('Developer','AsData_PL','','','SELECT',1,1),
('Developer','Data_Pub','','','SELECT',1,1),
('Developer','Mtd','','','SELECT',1,1),
('Developer','Comp','','','SELECT',1,1),
('Developer','dbo','DASCalendarMonth','TABLE','SELECT',0,1),
('Developer','dbo','ReferenceData','TABLE','SELECT',0,1),
('Developer','dbo','SourceDbChanges','TABLE','SELECT',0,1),
('Developer','dbo','DataDictionary','VIEW','SELECT',0,1),
/* BetaUser */
('BetaUser','ASData_PL','Acc_Account','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Acc_AccountLegalEntity','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Acc_AccountUserRole','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Acc_EmployerAgreement','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Acc_LegalEntity','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Acc_User','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','AR_Apprentice','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','AR_Employer','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_Certificates','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_OrganisationStandard','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Comt_Apprenticeship','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Comt_Commitment','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_ApprenticeshipDaysInLearning','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_ApprenticeshipIncentive','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_ChangeOfCircumstance','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_ClawbackPayment','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_CollectionCalendar','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplication','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplicationApprenticeship','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplicationStatusAudit','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_Learner','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_LearningPeriod','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_Payment','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_PendingPayment','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_PendingPaymentValidationResult','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_ApprenticeshipFunding','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_Framework','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_FrameworkFundingPeriod','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_LarsStandard','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_NationalAchievementRate','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_NationalAchievementRateOverall','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistration','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistrationFeedbackAttribute','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistrationFeedbackRating','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_ProviderStandard','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_ProviderStandardLocation','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_SectorSubjectAreaTier2','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_ShortList','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_StandardLocation','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','FAT2_StandardSector','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','GA_SessionData','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoActivityTypes','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoCampaigns','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoLeadActivities','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoLeadPrograms','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoLeads','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoPrograms','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoSmartCampaigns','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','PFBE_EmployerFeedback','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Resv_Reservation','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_Application','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_ApprenticeshipFrameWorkAndOccupation','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_ApprenticeshipStandard','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_Candidate','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_CandidateDetails','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_EducationLevel','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_Employer','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_LegalEntity','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_Provider','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Va_Vacancy','TABLE','SELECT',0,1),
('BetaUser','Stg','GA_SessionDataDetail','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','DAS_UserAccountLegalEntity','VIEW','SELECT',0,1),
('BetaUser','ASData_PL','DAS_Users','VIEW','SELECT',0,1),
('BetaUser','dbo','DataDictionary','VIEW','SELECT',0,1),
/* Data Analyst */
('DataAnalyst','ASData_PL','Payments_SS','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_Commitments_LevyInd','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_Employer_LegalEntities_LevyInd','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_Payments_LevyInd','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_SpendControl_V2','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_SpendControlNonLevy_V2','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_TransactionLine','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_TransactionLine_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_CalendarMonth','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Commitments','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Commitments_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Account_Transfers','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Account_Transfers_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Accounts','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Accounts_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_AccountTransactions','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_AccountTransactions_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Agreements','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Agreements_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_LegalEntities','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_LegalEntities_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_PayeSchemes','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_PayeSchemes_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Transfer_Relationship','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Transfer_Relationship_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_LevyDeclarations','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_LevyDeclarations_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Payments','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Payments_V2','VIEW','SELECT',0,1),
/* DataGov */
('DataGov','ASData_PL','MarketoActivityTypes','TABLE','SELECT',0,1),
('DataGov','ASData_PL','MarketoCampaigns','TABLE','SELECT',0,1),
('DataGov','ASData_PL','MarketoLeadActivities','TABLE','SELECT',0,1),
('DataGov','ASData_PL','MarketoLeadPrograms','TABLE','SELECT',0,1),
('DataGov','ASData_PL','MarketoLeads','TABLE','SELECT',0,1),
('DataGov','ASData_PL','MarketoPrograms','TABLE','SELECT',0,1),
('DataGov','ASData_PL','MarketoSmartCampaigns','TABLE','SELECT',0,1),
('DataGov','ASData_PL','DAS_UserAccountLegalEntity','VIEW','SELECT',0,1),
('DataGov','ASData_PL','DAS_Users','VIEW','SELECT',0,1),
('DataGov','Data_Pub','DAS_Commitments_V2','VIEW','SELECT',0,1),
('DataGov','ASData_PL','Comt_Commitment','TABLE','SELECT',0,1),
('DataGov','ASData_PL','Comt_Apprenticeship','TABLE','SELECT',0,1),
('DataGov','ASData_PL','Acc_AccountLegalEntity','TABLE','SELECT',0,1),
('DataGov','ASData_PL','Acc_Account','TABLE','SELECT',0,1),
('DataGov','ASData_PL','Acc_LegalEntity','TABLE','SELECT',0,1),
('DataGov','ASData_PL','EI_ApprenticeshipIncentive','TABLE','SELECT',0,1),
('DataGov','ASData_PL','EI_Payment','TABLE','SELECT',0,1),
('DataGov','dbo','ReferenceData','TABLE','SELECT',0,1),
('DataGov','ASData_PL','Fin_Payment','TABLE','SELECT',0,1),
('DataGov','','','DATABASE','VIEW DEFINITION',0,1),
('DataGov','sys','sql_expression_dependencies','VIEW','SELECT',0,1),

/* Finance */
('Finance','ASData_PL','DAS_SpendControl','VIEW','SELECT',0,1),
('Finance','ASData_PL','DAS_SpendControlNonLevy','VIEW','SELECT',0,1),
/* MarketoUser */
('MarketoUser','ASData_PL','DAS_UserAccountLegalEntity','VIEW','SELECT',0,1),
('MarketoUser','ASData_PL','DAS_Users','VIEW','SELECT',0,1),
/* Service Ops */
('ServiceOps','Stg','RAA_ApplicationReviews','TABLE','SELECT',0,1),
('ServiceOps','Stg','RAA_ReferenceDataApprenticeshipProgrammes','TABLE','SELECT',0,1),
('ServiceOps','Stg','RAA_Vacancies','TABLE','SELECT',0,1),
/* Va User for Nigel's Team in Data Science */
('VaUser','ASData_PL','Va_Application','TABLE','SELECT',0,1),
('VaUser','ASData_PL','Va_Vacancy','TABLE','SELECT',0,1)


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
	    'PopulateMetadataRolesAndPermissions',
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

GO