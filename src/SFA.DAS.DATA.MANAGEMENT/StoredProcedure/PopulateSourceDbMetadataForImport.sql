CREATE PROCEDURE [dbo].[PopulateSourceDbMetadataForImport]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 28/05/2020
-- Description: Populate Metadata Table with Source Config for Import 
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
	   ,'PopulateSourceDbMetadataForImport'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='PopulateSourceDbMetadataForImport'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM Mtd.SourceConfigForImport

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude)
VALUES
/* AVMSPlus Metadata */
('AVMSPlus','Candidate','dbo','[CandidateId],[PersonId],[CandidateStatusTypeId],[CountyId],[Postcode],[LocalAuthorityId],[VoucherReferenceNumber],[UniqueLearnerNumber],[UlnStatusId],[Gender],[ApplicationLimitEnforced],[LastAccessedDate],[ReceivePushedContent],[ReferralAgent],[DisableAlerts],[DoBFailureCount],[ForgottenUsernameRequested],[ForgottenPasswordRequested],[TextFailureCount],[EmailFailureCount],[LastAccessedManageApplications],[ReferralPoints],[BeingSupportedBy],[LockedForSupportUntil],[AllowMarketingMessages],[ReminderMessageSent],[CandidateGuid],[DateofBirth]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[NiReference],[EthnicOrigin],[EthnicOriginOther],[AdditionalEmail],[Disability],[DisabilityOther],[HealthProblems],[UnconfirmedEmailAddress],[MobileNumberUnconfirmed],[NewVacancyAlertEmail],[NewVacancyAlertSMS]')
,('AVMSPlus','Vacancy','dbo','[VacancyId],[VacancyOwnerRelationshipId],[VacancyReferenceNumber],[VacancyStatusId],[CountyId],[PostCode],[LocalAuthorityId],[ApprenticeshipFrameworkId],[Title],[ApprenticeshipType],[ShortDescription],[Description],[WeeklyWage],[WageLowerBound],[WageUpperBound],[WageType],[WageTypeReason],[WageText],[NumberofPositions],[ApplicationClosingDate],[InterviewsFromDate],[ExpectedStartDate],[ExpectedDuration],[WorkingWeek],[NumberOfViews],[MaxNumberofApplications],[ApplyOutsideNAVMS],[BeingSupportedBy],[LockedForSupportUntil],[NoOfOfflineApplicants],[MasterVacancyId],[VacancyLocationTypeId],[NoOfOfflineSystemApplicants],[DeliveryOrganisationID],[ContractOwnerID],[SmallEmployerWageIncentive],[OriginalContractOwnerId],[VacancyGuid],[SubmissionCount],[StartedToQADateTime],[StandardId],[HoursPerWeek],[WageUnitId],[DurationTypeId],[DurationValue],[TrainingTypeId],[VacancyTypeId],[SectorId],[UpdatedDateTime],[EditedInRaa],[VacancySourceId],[OfflineVacancyTypeId]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[GeocodeEasting],[GeocodeNorthing],[Longitude],[Latitude],[ContactEmail],[ContactNumber],[QAUserName],[ContactName],[EmployerDescription],[EmployersWebsite],[EmployersRecruitmentWebsite],[EmployerAnonymousReason],[AnonymousAboutTheEmployer],[IsDisabilityConfident],[AdditionalLocationInformation],[VacancyManagerAnonymous],[VacancyManagerID],[EmployerAnonymousName],[EmployersApplicationInstructions]')
,('AVMSPlus','VacancyStatusType','dbo','[VacancyStatusTypeId],[CodeName],[ShortName],[FullName]','')
,('AVMSPlus','VacancyOwnerRelationship','dbo','[VacancyOwnerRelationshipId],[EmployerId],[ProviderSiteID],[ContractHolderIsEmployer],[StatusTypeId],[Notes],[NationWideAllowed],[EditedInRaa]','[ManagerIsEmployer],[EmployerDescription],[EmployerWebsite],[EmployerLogoAttachmentId]')
,('AvmsPlus','Employer','dbo','[EmployerId],[EdsUrn],[FullName],[TradingName],[CountyId],[PostCode],[LocalAuthorityId],[OwnerOrgnistaion],[TotalVacanciesPosted],[BeingSupportedBy],[LockedForSupportUntil],[EmployerStatusTypeId],[DisableAllowed],[TrackingAllowed]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[NumberofEmployeesAtSite],[NumberOfEmployeesInGroup],[PrimaryContact],[CompanyRegistrationNumber]')
,('AvmsPlus','ProviderSite','dbo','[ProviderSiteID],[FullName],[TradingName],[EDSURN],[CountyId],[PostCode],[LocalAuthorityId],[ManagingAreaID],[EmployerDescription],[CandidateDescription],[WebPage],[OutofDate],[HideFromSearch],[TrainingProviderStatusTypeId],[IsRecruitmentAgency],[ContactDetailsAsARecruitmentAgency],[OwnerOrganisation]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[ContactDetailsForEmployer],[ContactDetailsForCandidate]')
,('AvmsPlus','ProviderSiteRelationship','dbo','[ProviderSiteRelationshipID],[ProviderID],[ProviderSiteID],[ProviderSiteRelationShipTypeID]','')
,('AvmsPlus','ProviderSiteRelationshipType','dbo','[ProviderSiteRelationshipTypeID],[ProviderSiteRelationshipTypeName]','')
,('AvmsPlus','Provider','dbo','[ProviderID],[UPIN],[UKPRN],[FullName],[TradingName],[IsContracted],[ContractedFrom],[ContractedTo],[ProviderStatusTypeID],[IsNASProvider],[OriginalUPIN],[ProviderToUseFAA],[MigrateProviderMessageID]','')
,('AvmsPlus','TrainingType','dbo','[TrainingTypeId],[CodeName],[ShortName],[FullName]','')
,('AvmsPlus','Standard','Reference','[StandardId],[StandardSectorId],[LarsCode],[FullName],[EducationLevelId],[ApprenticeshipFrameworkStatusTypeId],[EducationLevelNumber]','')
,('AvmsPlus','StandardSector','Reference','[StandardSectorId],[FullName],[ApprenticeshipOccupationId],[LarsStandardSectorCode]','')
,('AvmsPlus','EducationLevel','Reference','[EducationLevelId],[CodeName],[ShortName],[FullName]','')
,('AvmsPlus','ApprenticeshipFramework','dbo','[ApprenticeshipFrameworkId],[ApprenticeshipOccupationId],[CodeName],[ShortName],[FullName],[ApprenticeshipFrameworkStatusTypeId],[ClosedDate],[PreviousApprenticeshipOccupationId],[StandardId]','')
,('AvmsPlus','AppprenticeshipOccupation','dbo','[ApprenticeshipOccupationId],[Codename],[ShortName],[FullName],[ApprenticeshipOccupationStatusTypeId],[ClosedDate]','')
,('AvmsPlus','VacancyHistory','dbo','[VacancyHistoryId],[VacancyId],[VacancyHistoryEventTypeId],[VacancyHistoryEventSubTypeId],[HistoryDate],[Comment]','[UserName]')
,('AvmsPlus','LocalAuthority','dbo','[LocalAuthorityId],[CodeName],[ShortName],[FullName],[CountyId]','')
,('AvmsPlus','County','dbo','[CountyId],[CodeName],[ShortName],[FullName]','')
,('AvmsPlus','ApprenticeshipType','dbo','[ApprenticeshipTypeId],[CodeName],[ShortName],[FullName],[EducationLevelId]','')
,('AvmsPlus','WageType','dbo','[WageTypeId],[CodeName],[ShortName],[FullName]','')
,('AvmsPlus','VacancySource','dbo','[VacancySourceId],[CodeName],[ShortName],[FullName]','')
,('AvmsPlus','Application','dbo','[ApplicationId],[CandidateId],[VacancyId],[ApplicationStatusTypeId],[WithdrawnOrDeclinedReasonId],[UnsuccessfulReasonId],[OutcomeReasonOther],[NextActionId],[NextActionOther],[BeingSupportedBy],[LockedForSupportUntil],[WithdrawalAcknowledged],[ApplicationGuid],[Notes]','[CVAttachmentId]')
,('AvmsPlus','ApplicationStatusType','dbo','[ApplicationStatusTypeId],[CodeName],[ShortName],[FullName]','')



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
	    'PopulateSourceDbMetadataForImport',
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


		  

