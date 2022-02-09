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
('Developer','Pds_AI','','','SELECT',1,1),
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
('BetaUser','ASData_PL','AED_CourseDemand','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','AED_CourseDemandNotificationAudit','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','AED_ProviderInterest','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','AR_Apprentice','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','AR_Employer','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_Apply','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_Certificates','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_CertificateLogs','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_Organisations','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_OrganisationStandard','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_DeliveryArea','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_OrganisationStandardDeliveryArea','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Assessor_OrganisationStandardVersion','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','DAS_AssessorAssessmentData','VIEW','SELECT',0,1),
('BetaUser','ASData_PL','Comt_Apprenticeship','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Comt_Commitment','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Comt_ApprenticeshipConfirmationStatus','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Comt_ApprenticeshipUpdate','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Comt_StandardOption','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','EI_ApprenticeshipBreakInLearning','TABLE','SELECT',0,1),
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
--('BetaUser','ASData_PL','LTM_Application','TABLE','SELECT',0,1),
--('BetaUser','ASData_PL','LTM_ApplicationEmailAddress','TABLE','SELECT',0,1),
--('BetaUser','ASData_PL','LTM_Pledge','TABLE','SELECT',0,1),
--('BetaUser','ASData_PL','LTM_PledgeLocation','TABLE','SELECT',0,1),
--('BetaUser','ASData_PL','LTM_ApplicationStatusHistory','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoActivityTypes','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoCampaigns','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoLeadActivities','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoLeadPrograms','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoLeads','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoPrograms','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','MarketoSmartCampaigns','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','PFBE_EmployerFeedback','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','Resv_Reservation','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_Apply','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_Organisations','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_Appeal','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_AppealFile','TABLE','SELECT',0,1),
--('BetaUser','ASData_PL','RP_AppealUpload','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_AssessorPageReviewOutcome','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_Contacts','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_GatewayAnswer','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_ModeratorPageReviewOutcome','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_OversightReview','TABLE','SELECT',0,1),
('BetaUser','ASData_PL','RP_SubmittedApplicationAnswers','TABLE','SELECT',0,1),
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
('DataAnalyst','ASData_PL','DAS_SpendControl_V2','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_SpendControlNonLevy_V2','VIEW','SELECT',0,1),
('DataAnalyst','ASData_PL','DAS_TransactionLine_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_CalendarMonth','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Commitments_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Account_Transfers_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Accounts_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_AccountTransactions_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Agreements_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_LegalEntities_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_PayeSchemes_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Employer_Transfer_Relationship_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_LevyDeclarations_V2','VIEW','SELECT',0,1),
('DataAnalyst','Data_Pub','DAS_Payments_V2','VIEW','SELECT',0,1),
/* Data Science access to Import LTM & Reservation Tables */
('DataAnalyst','ASData_PL','LTM_Application','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','LTM_Pledge','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','LTM_PledgeJobRole','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','LTM_PledgeLevel','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','LTM_PledgeLocation','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','LTM_PledgeSector','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','Resv_Reservation','TABLE','SELECT',0,1),
('DataAnalyst','dbo','ReferenceData','TABLE','SELECT',0,1),
('DataAnalyst','ASData_PL','FAT2_StandardSector','TABLE','SELECT',0,1),
/* DataGov */
--('DataGov','ASData_PL','MarketoActivityTypes','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','MarketoCampaigns','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','MarketoLeadActivities','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','MarketoLeadPrograms','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','MarketoLeads','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','MarketoPrograms','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','MarketoSmartCampaigns','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','DAS_UserAccountLegalEntity','VIEW','SELECT',0,1),
--('DataGov','ASData_PL','DAS_Users','VIEW','SELECT',0,1),
--('DataGov','Data_Pub','DAS_Commitments_V2','VIEW','SELECT',0,1),
--('DataGov','ASData_PL','Comt_Commitment','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','Comt_Apprenticeship','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','Acc_AccountLegalEntity','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','Acc_Account','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','Acc_LegalEntity','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','EI_ApprenticeshipIncentive','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','EI_Payment','TABLE','SELECT',0,1),
--('DataGov','dbo','ReferenceData','TABLE','SELECT',0,1),
--('DataGov','ASData_PL','Fin_Payment','TABLE','SELECT',0,1),
('DataGov','','','DATABASE','VIEW DEFINITION',0,1),
('DataGov','sys','sql_expression_dependencies','VIEW','SELECT',0,1),

/* Finance */
('Finance','ASData_PL','DAS_SpendControl_v2','VIEW','SELECT',0,1),
('Finance','ASData_PL','DAS_SpendControlNonLevy_v2','VIEW','SELECT',0,1),
/* MarketoUser */
('MarketoUser','ASData_PL','DAS_UserAccountLegalEntity','VIEW','SELECT',0,1),
('MarketoUser','ASData_PL','DAS_Users','VIEW','SELECT',0,1),
/* PSR User */
('PSRUserDfeStats','ASData_PL','PubSector_Report','TABLE','SELECT',0,1),
/* Service Ops */
('ServiceOps','Stg','RAA_ApplicationReviews','TABLE','SELECT',0,1),
('ServiceOps','Stg','RAA_ReferenceDataApprenticeshipProgrammes','TABLE','SELECT',0,1),
('ServiceOps','Stg','RAA_Vacancies','TABLE','SELECT',0,1),
/* Va User for Nigel's Team in Data Science */
('VaUser','ASData_PL','Va_Application','TABLE','SELECT',0,1),
('VaUser','ASData_PL','Va_Vacancy','TABLE','SELECT',0,1),
/* Atos User Role for Atos Team working on AI Project */
('AtosUser','Pds_AI','PT_D','VIEW','SELECT',0,1),
('AtosUser','Pds_AI','PT_B','VIEW','SELECT',0,1),
('AtosUser','Pds_AI','PT_C','VIEW','SELECT',0,1),
('AtosUser','Pds_AI','PT_A','VIEW','SELECT',0,1),
('AtosUser','Pds_AI','PT_E','VIEW','SELECT',0,1),
('AtosUser','Pds_AI','PT_F','VIEW','SELECT',0,1),
('AtosUser','Pds_AI','PT_G','VIEW','SELECT',0,1),
('AtosUser','Stg','AI_TestData','TABLE','SELECT',0,1),
('AtosUser','Pds_AI','PT_I','VIEW','SELECT',0,1),
('AtosUser','Pds_AI','PT_J','VIEW','SELECT',0,1),

/* DataAnalystTier2 This new DataAnalystTier2 role is for Rosie's team*/
('DataAnalystTier2','ASData_PL','Acc_Account','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Acc_AccountLegalEntity','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Comt_Apprenticeship','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Comt_Commitment','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Comt_StandardOption','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','ApprenticeshipStdRoute','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Comt_Providers','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Resv_Reservation','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Payments_SS','TABLE','SELECT',0,1),
('DataAnalystTier2','StgPmts','EarningEvent','TABLE','SELECT',0,1),
('DataAnalystTier2','StgPmts','RequiredPaymentEvent','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','EI_IncentiveApplicationApprenticeship','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','EI_IncentiveApplication','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','EI_ApprenticeshipIncentive','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','EI_Payment','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','EI_IncentiveApplicationStatusAudit','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','EI_ClawbackPayment','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Va_Vacancy','TABLE','SELECT',0,1),
('DataAnalystTier2','ASData_PL','Va_Employer','TABLE','SELECT',0,1),
/*DWH Lookup tables*/
('DWHLkpUser','lkp','LARS_Framework','TABLE','ALTER',0,1),
('DWHLkpUser','lkp','LARS_Framework','TABLE','SELECT',0,1),
('DWHLkpUser','lkp','LARS_Framework','TABLE','INSERT',0,1),
('DWHLkpUser','lkp','LARS_SectorSubjectAreaTier1','TABLE','ALTER',0,1),
('DWHLkpUser','lkp','LARS_SectorSubjectAreaTier1','TABLE','SELECT',0,1),
('DWHLkpUser','lkp','LARS_SectorSubjectAreaTier1','TABLE','INSERT',0,1),
('DWHLkpUser','lkp','LARS_SectorSubjectAreaTier2','TABLE','ALTER',0,1),
('DWHLkpUser','lkp','LARS_SectorSubjectAreaTier2','TABLE','SELECT',0,1),
('DWHLkpUser','lkp','LARS_SectorSubjectAreaTier2','TABLE','INSERT',0,1),
('DWHLkpUser','lkp','LARS_Standard','TABLE','ALTER',0,1),
('DWHLkpUser','lkp','LARS_Standard','TABLE','SELECT',0,1),
('DWHLkpUser','lkp','LARS_Standard','TABLE','INSERT',0,1),
('DWHLkpUser','lkp','Postcode_GeographicalAttributes','TABLE','ALTER',0,1),
('DWHLkpUser','lkp','Postcode_GeographicalAttributes','TABLE','SELECT',0,1),
('DWHLkpUser','lkp','Postcode_GeographicalAttributes','TABLE','INSERT',0,1),
('DWHLkpUser','lkp','Pst_GOR','TABLE','ALTER',0,1),
('DWHLkpUser','lkp','Pst_GOR','TABLE','SELECT',0,1),
('DWHLkpUser','lkp','Pst_GOR','TABLE','INSERT',0,1),
('DWHLkpUser','lkp','Pst_LocalAuthority','TABLE','ALTER',0,1),
('DWHLkpUser','lkp','Pst_LocalAuthority','TABLE','SELECT',0,1),
('DWHLkpUser','lkp','Pst_LocalAuthority','TABLE','INSERT',0,1)


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