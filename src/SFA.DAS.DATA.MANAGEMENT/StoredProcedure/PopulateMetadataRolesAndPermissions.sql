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
(RoleName, SchemaName, ObjectName, ObjectType, IsSchemaLevelAccess, IsEnabled)
VALUES
/* Developer*/
('Developer','Comt','','',1,1),
('Developer','Acct','','',1,1),
('Developer ','EAUser','','',1,1),
('Developer','Fin','','',1,1),
('Developer','Mgmt','','',1,1),
('Developer','Resv','','',1,1),
('Developer','Pmts','','',1,1),
('Developer ','StgPmts','','',1,1),
('Developer ','Stg','','',1,1),
('Developer','AsData_PL','','',1,1),
('Developer','Data_Pub','','',1,1),
('Developer','Mtd','','',1,1),
('Developer','Comp','','',1,1),
('Developer','dbo','DASCalendarMonth','',0,1),
('Developer','dbo','ReferenceData','',0,1),
('Developer','dbo','SourceDbChanges','',0,1),
('Developer','Data_Pub','DAS_CalendarMonth','',0,1),
('Developer','dbo','DataDictionary','',0,1),
/* BetaUser */
('BetaUser','ASData_PL','Acc_Account','TABLE',0,1),
('BetaUser','ASData_PL','Acc_AccountLegalEntity','TABLE',0,1),
('BetaUser','ASData_PL','Acc_AccountUserRole','TABLE',0,1),
('BetaUser','ASData_PL','Acc_EmployerAgreement','TABLE',0,1),
('BetaUser','ASData_PL','Acc_LegalEntity','TABLE',0,1),
('BetaUser','ASData_PL','Acc_User','TABLE',0,1),
('BetaUser','ASData_PL','AR_Apprentice','TABLE',0,1),
('BetaUser','ASData_PL','AR_Employer','TABLE',0,1),
('BetaUser','ASData_PL','Assessor_Certificates','TABLE',0,1),
('BetaUser','ASData_PL','Assessor_OrganisationStandard','TABLE',0,1),
('BetaUser','ASData_PL','Comt_Apprenticeship','TABLE',0,1),
('BetaUser','ASData_PL','Comt_Commitment','TABLE',0,1),
('BetaUser','ASData_PL','EI_ApprenticeshipDaysInLearning','TABLE',0,1),
('BetaUser','ASData_PL','EI_ApprenticeshipIncentive','TABLE',0,1),
('BetaUser','ASData_PL','EI_ChangeOfCircumstance','TABLE',0,1),
('BetaUser','ASData_PL','EI_ClawbackPayment','TABLE',0,1),
('BetaUser','ASData_PL','EI_CollectionCalendar','TABLE',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplication','TABLE',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplicationApprenticeship','TABLE',0,1),
('BetaUser','ASData_PL','EI_IncentiveApplicationStatusAudit','TABLE',0,1),
('BetaUser','ASData_PL','EI_Learner','TABLE',0,1),
('BetaUser','ASData_PL','EI_LearningPeriod','TABLE',0,1),
('BetaUser','ASData_PL','EI_Payment','TABLE',0,1),
('BetaUser','ASData_PL','EI_PendingPayment','TABLE',0,1),
('BetaUser','ASData_PL','EI_PendingPaymentValidationResult','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_ApprenticeshipFunding','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_Framework','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_FrameworkFundingPeriod','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_LarsStandard','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_NationalAchievementRate','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_NationalAchievementRateOverall','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistration','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistrationFeedbackAttribute','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_ProviderRegistrationFeedbackRating','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_ProviderStandard','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_ProviderStandardLocation','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_SectorSubjectAreaTier2','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_ShortList','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_StandardLocation','TABLE',0,1),
('BetaUser','ASData_PL','FAT2_StandardSector','TABLE',0,1),
('BetaUser','ASData_PL','GA_SessionData','TABLE',0,1),
('BetaUser','ASData_PL','MarketoActivityTypes','TABLE',0,1),
('BetaUser','ASData_PL','MarketoCampaigns','TABLE',0,1),
('BetaUser','ASData_PL','MarketoLeadActivities','TABLE',0,1),
('BetaUser','ASData_PL','MarketoLeadPrograms','TABLE',0,1),
('BetaUser','ASData_PL','MarketoLeads','TABLE',0,1),
('BetaUser','ASData_PL','MarketoPrograms','TABLE',0,1),
('BetaUser','ASData_PL','MarketoSmartCampaigns','TABLE',0,1),
('BetaUser','ASData_PL','PFBE_EmployerFeedback','TABLE',0,1),
('BetaUser','ASData_PL','Resv_Reservation','TABLE',0,1),
('BetaUser','ASData_PL','Va_Application','TABLE',0,1),
('BetaUser','ASData_PL','Va_ApprenticeshipFrameWorkAndOccupation','TABLE',0,1),
('BetaUser','ASData_PL','Va_ApprenticeshipStandard','TABLE',0,1),
('BetaUser','ASData_PL','Va_Candidate','TABLE',0,1),
('BetaUser','ASData_PL','Va_CandidateDetails','TABLE',0,1),
('BetaUser','ASData_PL','Va_EducationLevel','TABLE',0,1),
('BetaUser','ASData_PL','Va_Employer','TABLE',0,1),
('BetaUser','ASData_PL','Va_LegalEntity','TABLE',0,1),
('BetaUser','ASData_PL','Va_Provider','TABLE',0,1),
('BetaUser','ASData_PL','Va_Vacancy','TABLE',0,1),
('BetaUser','Stg','GA_SessionDataDetail','TABLE',0,1),
('BetaUser','ASData_PL','DAS_UserAccountLegalEntity','VIEW',0,1),
('BetaUser','ASData_PL','DAS_Users','VIEW',0,1),
('BetaUser','dbo','DataDictionary','VIEW',0,1),
/* Data Analyst */
('DataAnalyst','ASData_PL','Payments_SS','TABLE',0,1),
('DataAnalyst','ASData_PL','DAS_Commitments_LevyInd','VIEW',0,1),
('DataAnalyst','ASData_PL','DAS_Employer_LegalEntities_LevyInd','VIEW',0,1),
('DataAnalyst','ASData_PL','DAS_Payments_LevyInd','VIEW',0,1),
('DataAnalyst','ASData_PL','DAS_SpendControl_V2','VIEW',0,1),
('DataAnalyst','ASData_PL','DAS_SpendControlNonLevy_V2','VIEW',0,1),
('DataAnalyst','ASData_PL','DAS_TransactionLine','VIEW',0,1),
('DataAnalyst','ASData_PL','DAS_TransactionLine_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_CalendarMonth','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Commitments','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Commitments_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Account_Transfers','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Account_Transfers_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Accounts','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Accounts_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_AccountTransactions','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_AccountTransactions_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Agreements','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Agreements_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_LegalEntities','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_LegalEntities_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_PayeSchemes','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_PayeSchemes_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Transfer_Relationship','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Transfer_Relationship_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_LevyDeclarations','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_LevyDeclarations_V2','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Payments','VIEW',0,1),
('DataAnalyst','Data_Pub','DAS_Payments_V2','VIEW',0,1),
/* DataGov */
('DataGov','ASData_PL','MarketoActivityTypes','TABLE',0,1),
('DataGov','ASData_PL','MarketoCampaigns','TABLE',0,1),
('DataGov','ASData_PL','MarketoLeadActivities','TABLE',0,1),
('DataGov','ASData_PL','MarketoLeadPrograms','TABLE',0,1),
('DataGov','ASData_PL','MarketoLeads','TABLE',0,1),
('DataGov','ASData_PL','MarketoPrograms','TABLE',0,1),
('DataGov','ASData_PL','MarketoSmartCampaigns','TABLE',0,1),
('DataGov','ASData_PL','DAS_UserAccountLegalEntity','VIEW',0,1),
('DataGov','ASData_PL','DAS_Users','VIEW',0,1),
('DataGov','Data_Pub','DAS_Commitments_V2','VIEW',0,1),
('DataGov','ASData_PL','Comt_Commitment','TABLE',0,1),
('DataGov','ASData_PL','Comt_Apprenticeship','TABLE',0,1),
('DataGov','ASData_PL','Acc_AccountLegalEntity','TABLE',0,1),
('DataGov','ASData_PL','Acc_Account','TABLE',0,1),
('DataGov','ASData_PL','Acc_LegalEntity','TABLE',0,1),
('DataGov','ASData_PL','EI_ApprenticeshipIncentive','TABLE',0,1),
('DataGov','ASData_PL','EI_Payment','TABLE',0,1),
('DataGov','ASData_PL','ReferenceData','TABLE',0,1),
('DataGov','ASData_PL','Fin_Payment','TABLE',0,1),
/* Finance */
('Finance','ASData_PL','DAS_SpendControl','VIEW',0,1),
('Finance','ASData_PL','DAS_SpendControlNonLevy','VIEW',0,1),
/* MarketoUser */
('MarketoUser','ASData_PL','DAS_UserAccountLegalEntity','VIEW',0,1),
('MarketoUser','ASData_PL','DAS_Users','VIEW',0,1),
/* Service Ops */
('ServiceOps','Stg','RAA_ApplicationReviews','TABLE',0,1),
('ServiceOps','Stg','RAA_ReferenceDataApprenticeshipProgrammes','TABLE',0,1),
('ServiceOps','Stg','RAA_Vacancies','TABLE',0,1),
/* Va User for Nigel's Team in Data Science */
('VaUser','ASData_PL','Va_Application','TABLE',0,1),
('VaUser','ASData_PL','Va_Application','TABLE',0,1)


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