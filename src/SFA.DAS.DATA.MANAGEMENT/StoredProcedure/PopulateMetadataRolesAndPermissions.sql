CREATE PROCEDURE [dbo].[PopulateMetadataRolesAndPermissions]
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

INSERT INTO Mtd.RolesAndPermissions
(RoleName, SchemaName, TableOrViewName, IsSchemaLevelAccess, IsEnabled)
VALUES
/* Developer*/
('Developer','Comt','',1,1),
('Developer','Acct','',1,1),
('Developer ','EAUser','',1,1),
('Developer','Fin','',1,1),
('Developer','Mgmt','',1,1),
('Developer','Resv','',1,1),
('Developer','Pmts','',1,1),
('Developer ','StgPmts','',1,1),
('Developer ','Stg','',1,1),
('Developer','AsData_PL','',1,1),
('Developer','Data_Pub','',1,1),
('Developer','Mtd','',1,1),
('Developer','Comp','',1,1),
('Developer','dbo','DASCalendarMonth',0,1),
('Developer','dbo','ReferenceData',0,1),
('Developer','dbo','SourceDbChanges',0,1),
('Developer','Data_Pub','DAS_CalendarMonth',0,1),
('Developer','dbo','DataDictionary',0,1),
/* BetaUser */
('BetaUser','ASData_PL','Acc_Account',0,1),
('BetaUser','ASData_PL','Acc_AccountLegalEntity',0,1),
('BetaUser','ASData_PL','Acc_AccountUserRole',0,1),
('BetaUser','ASData_PL','Acc_EmployerAgreement',0,1),
('BetaUser','ASData_PL','Acc_LegalEntity',0,1),
('BetaUser','ASData_PL','Acc_User',0,1),
('BetaUser','ASData_PL','AR_Apprentice',0,1),
('BetaUser','ASData_PL','AR_Employer',0,1),
('BetaUser','ASData_PL','Assessor_Certificates',0,1),
('BetaUser','ASData_PL','Assessor_OrganisationStandard',0,1),
('BetaUser','ASData_PL','Comt_Apprenticeship',0,1),
('BetaUser','ASData_PL','Comt_Commitment',0,1),
('BetaUser','ASData_PL','EI_ApprenticeshipDaysInLearning',0,1),
('BetaUser','ASData_PL','EI_ApprenticeshipIncentive',0,1),
('BetaUser','ASData_PL','EI_ChangeOfCircumstance',0,1),
('BetaUser','ASData_PL','EI_ClawbackPayment',0,1),
('BetaUser','ASData_PL','EI_CollectionCalendar',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplication',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplicationApprenticeship',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplicationStatusAudit',0,1),
('BetaUser','ASData_PL','EI_Learner',0,1),
('BetaUser','ASData_PL','EI_LearningPeriod',0,1),
('BetaUser','ASData_PL','EI_Payment',0,1),
('BetaUser','ASData_PL','EI_PendingPayment',0,1),
('BetaUser','ASData_PL','EI_PendingPaymentValidationResult',0,1),
('BetaUser','ASData_PL','FAT2_ApprenticeshipFunding',0,1),
('BetaUser','ASData_PL','FAT2_Framework',0,1),
('BetaUser','ASData_PL','FAT2_FrameworkFundingPeriod',0,1),
('BetaUser','ASData_PL','FAT2_LarsStandard',0,1),
('BetaUser','ASData_PL','FAT2_NationalAchievementRate',0,1),
('BetaUser','ASData_PL','FAT2_NationalAchievementRateOverall',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistration',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistrationFeedbackAttribute',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistrationFeedbackRating',0,1),
('BetaUser','ASData_PL','FAT2_ProviderStandard',0,1),
('BetaUser','ASData_PL','FAT2_ProviderStandardLocation',0,1),
('BetaUser','ASData_PL','FAT2_SectorSubjectAreaTier2',0,1),
('BetaUser','ASData_PL','FAT2_ShortList',0,1),
('BetaUser','ASData_PL','FAT2_StandardLocation',0,1),
('BetaUser','ASData_PL','FAT2_StandardSector',0,1),
('BetaUser','ASData_PL','GA_SessionData',0,1),
('BetaUser','ASData_PL','MarketoActivityTypes',0,1),
('BetaUser','ASData_PL','MarketoCampaigns',0,1),
('BetaUser','ASData_PL','MarketoLeadActivities',0,1),
('BetaUser','ASData_PL','MarketoLeadPrograms',0,1),
('BetaUser','ASData_PL','MarketoLeads',0,1),
('BetaUser','ASData_PL','MarketoPrograms',0,1),
('BetaUser','ASData_PL','MarketoSmartCampaigns',0,1),
('BetaUser','ASData_PL','PFBE_EmployerFeedback',0,1),
('BetaUser','ASData_PL','Resv_Reservation',0,1),
('BetaUser','ASData_PL','Va_Application',0,1),
('BetaUser','ASData_PL','Va_ApprenticeshipFrameWorkAndOccupation',0,1),
('BetaUser','ASData_PL','Va_ApprenticeshipStandard',0,1),
('BetaUser','ASData_PL','Va_Candidate',0,1),
('BetaUser','ASData_PL','Va_CandidateDetails',0,1),
('BetaUser','ASData_PL','Va_EducationLevel',0,1),
('BetaUser','ASData_PL','Va_Employer',0,1),
('BetaUser','ASData_PL','Va_LegalEntity',0,1),
('BetaUser','ASData_PL','Va_Provider',0,1),
('BetaUser','ASData_PL','Va_Vacancy',0,1),
('BetaUser','Stg','GA_SessionDataDetail',0,1),
('BetaUser','ASData_PL','DAS_UserAccountLegalEntity',0,1),
('BetaUser','ASData_PL','DAS_Users',0,1),
('BetaUser','dbo','DataDictionary',0,1),
/* DataAnalyst */
('DataAnalyst','ASData_PL','Payments_SS',0,1),
('DataAnalyst','ASData_PL','DAS_Commitments_LevyInd',0,1),
('DataAnalyst','ASData_PL','DAS_Employer_LegalEntities_LevyInd',0,1),
('DataAnalyst','ASData_PL','DAS_Payments_LevyInd',0,1),
('DataAnalyst','ASData_PL','DAS_SpendControl_V2',0,1),
('DataAnalyst','ASData_PL','DAS_SpendControlNonLevy_V2',0,1),
('DataAnalyst','ASData_PL','DAS_TransactionLine',0,1),
('DataAnalyst','ASData_PL','DAS_TransactionLine_V2',0,1),
('DataAnalyst','Data_Pub','DAS_CalendarMonth',0,1),
('DataAnalyst','Data_Pub','DAS_Commitments',0,1),
('DataAnalyst','Data_Pub','DAS_Commitments_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Account_Transfers',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Account_Transfers_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Accounts',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Accounts_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_AccountTransactions',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_AccountTransactions_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Agreements',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Agreements_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_LegalEntities',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_LegalEntities_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_PayeSchemes',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_PayeSchemes_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Transfer_Relationship',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Transfer_Relationship_V2',0,1),
('DataAnalyst','Data_Pub','DAS_LevyDeclarations',0,1),
('DataAnalyst','Data_Pub','DAS_LevyDeclarations_V2',0,1),
('DataAnalyst','Data_Pub','DAS_Payments',0,1),
('DataAnalyst','Data_Pub','DAS_Payments_V2',0,1),
/* DataGov */
('DataGov','ASData_PL','MarketoActivityTypes',0,1),
('DataGov','ASData_PL','MarketoCampaigns',0,1),
('DataGov','ASData_PL','MarketoLeadActivities',0,1),
('DataGov','ASData_PL','MarketoLeadPrograms',0,1),
('DataGov','ASData_PL','MarketoLeads',0,1),
('DataGov','ASData_PL','MarketoPrograms',0,1),
('DataGov','ASData_PL','MarketoSmartCampaigns',0,1),
('DataGov','ASData_PL','DAS_UserAccountLegalEntity',0,1),
('DataGov','ASData_PL','DAS_Users',0,1),
('DataGov','Data_Pub','DAS_Commitments_V2',0,1),
/* Finance */
('Finance','ASData_PL','DAS_SpendControl',0,1),
('Finance','ASData_PL','DAS_SpendControlNonLevy',0,1),
/* Marketo User */
('MarketoUser','ASData_PL','DAS_UserAccountLegalEntity',0,1),
('MarketoUser','ASData_PL','DAS_Users',0,1),
/* Service Ops */
('ServiceOps','Stg','RAA_ApplicationReviews',0,1),
('ServiceOps','Stg','RAA_ReferenceDataApprenticeshipProgrammes',0,1),
('ServiceOps','Stg','RAA_Vacancies',0,1)




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