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
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,[ModelDataToPL])
VALUES
/* AVMSPlus Metadata */
('AvmsPlus','Candidate','dbo','[CandidateId],[PersonId],[CandidateStatusTypeId],[ApplicationLimitEnforced],[LastAccessedDate],[DisableAlerts],[LastAccessedManageApplications],[BeingSupportedBy],[LockedForSupportUntil],[AllowMarketingMessages],[CandidateGuid]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[NiReference],[EthnicOrigin],[EthnicOriginOther],[AdditionalEmail],[Disability],[DisabilityOther],[HealthProblems],[UnconfirmedEmailAddress],[MobileNumberUnconfirmed],[NewVacancyAlertEmail],[NewVacancyAlertSMS],[CountyId],[Postcode],[LocalAuthorityId],[UniqueLearnerNumber],[UlnStatusId],[Gender],[ReferralAgent],[ReceivePushedContent],[DoBFailureCount],[ForgottenUsernameRequested],[ForgottenPasswordRequested],[TextFailureCount],[EmailFailureCount],[ReferralPoints],[ReminderMessageSent],[DateofBirth],[VoucherReferenceNumber]','',0)
,('AvmsPlus','Vacancy','dbo','[VacancyId],[VacancyOwnerRelationshipId],[VacancyReferenceNumber],[VacancyStatusId],[ApprenticeshipFrameworkId],[Title],[ApprenticeshipType],[ShortDescription],[Description],[WeeklyWage],[WageLowerBound],[WageUpperBound],[WageType],[WageTypeReason],[WageText],[NumberofPositions],[ApplicationClosingDate],[InterviewsFromDate],[ExpectedStartDate],[ExpectedDuration],[WorkingWeek],[NumberOfViews],[MaxNumberofApplications],[ApplyOutsideNAVMS],[BeingSupportedBy],[LockedForSupportUntil],[NoOfOfflineApplicants],[MasterVacancyId],[VacancyLocationTypeId],[NoOfOfflineSystemApplicants],[DeliveryOrganisationID],[ContractOwnerID],[SmallEmployerWageIncentive],[OriginalContractOwnerId],[VacancyGuid],[SubmissionCount],[StartedToQADateTime],[StandardId],[HoursPerWeek],[WageUnitId],[DurationTypeId],[DurationValue],[TrainingTypeId],[VacancyTypeId],[SectorId],[UpdatedDateTime],[EditedInRaa],[VacancySourceId],[OfflineVacancyTypeId]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[GeocodeEasting],[GeocodeNorthing],[Longitude],[Latitude],[ContactEmail],[ContactNumber],[QAUserName],[ContactName],[EmployerDescription],[EmployersWebsite],[EmployersRecruitmentWebsite],[EmployerAnonymousReason],[AnonymousAboutTheEmployer],[IsDisabilityConfident],[AdditionalLocationInformation],[VacancyManagerAnonymous],[VacancyManagerID],[EmployerAnonymousName],[EmployersApplicationInstructions],[LocalAuthorityId],[CountyId],[PostCode]','',0)
,('AvmsPlus','VacancyStatusType','dbo','[VacancyStatusTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','VacancyOwnerRelationship','dbo','[VacancyOwnerRelationshipId],[EmployerId],[ProviderSiteID],[ContractHolderIsEmployer],[StatusTypeId],[NationWideAllowed],[EditedInRaa]','[ManagerIsEmployer],[EmployerDescription],[EmployerWebsite],[EmployerLogoAttachmentId],[Notes]','',0)
,('AvmsPlus','Employer','dbo','[EmployerId],[FullName],[TradingName],[OwnerOrgnistaion],[TotalVacanciesPosted],[BeingSupportedBy],[LockedForSupportUntil],[EmployerStatusTypeId]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[NumberofEmployeesAtSite],[NumberOfEmployeesInGroup],[PrimaryContact],[CompanyRegistrationNumber],[EdsUrn],[CountyId],[PostCode],[DisableAllowed],[TrackingAllowed],[LocalAuthorityId]','',0)
,('AvmsPlus','ProviderSite','dbo','[ProviderSiteID],[FullName],[TradingName],[TrainingProviderStatusTypeId],[IsRecruitmentAgency],[OwnerOrganisation]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[ContactDetailsForEmployer],[ContactDetailsForCandidate],[EDSURN],[CountyId],[PostCode],[LocalAuthorityId],[ManagingAreaID],[EmployerDescription],[CandidateDescription],[WebPage],[OutofDate],[HideFromSearch],[ContactDetailsAsARecruitmentAgency]','',0)
,('AvmsPlus','ProviderSiteRelationship','dbo','[ProviderSiteRelationshipID],[ProviderID],[ProviderSiteID],[ProviderSiteRelationShipTypeID]','','',0)
,('AvmsPlus','ProviderSiteRelationshipType','dbo','[ProviderSiteRelationshipTypeID],[ProviderSiteRelationshipTypeName]','','',0)
,('AvmsPlus','Provider','dbo','[ProviderID],[UKPRN],[FullName],[TradingName],[IsContracted],[ContractedFrom],[ContractedTo],[ProviderStatusTypeID],[IsNASProvider],[ProviderToUseFAA]','[UPIN],[OriginalUPIN],[MigrateProviderMessageID]','',0)
,('AvmsPlus','TrainingType','dbo','[TrainingTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','Standard','Reference','[StandardId],[StandardSectorId],[LarsCode],[FullName],[EducationLevelId],[ApprenticeshipFrameworkStatusTypeId],[EducationLevelNumber]','','',0)
,('AvmsPlus','StandardSector','Reference','[StandardSectorId],[FullName],[ApprenticeshipOccupationId],[LarsStandardSectorCode]','','',0)
,('AvmsPlus','EducationLevel','Reference','[EducationLevelId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','ApprenticeshipFramework','dbo','[ApprenticeshipFrameworkId],[ApprenticeshipOccupationId],[CodeName],[ShortName],[FullName],[ApprenticeshipFrameworkStatusTypeId],[ClosedDate],[PreviousApprenticeshipOccupationId],[StandardId]','','',0)
,('AvmsPlus','ApprenticeshipOccupation','dbo','[ApprenticeshipOccupationId],[Codename],[ShortName],[FullName],[ApprenticeshipOccupationStatusTypeId],[ClosedDate]','','',0)
,('AvmsPlus','VacancyHistory','dbo','[VacancyHistoryId],[VacancyId],[VacancyHistoryEventTypeId],[VacancyHistoryEventSubTypeId],[HistoryDate],[Comment]','[UserName]','',0)
,('AvmsPlus','LocalAuthority','dbo','[LocalAuthorityId],[CodeName],[ShortName],[FullName],[CountyId]','','',0)
,('AvmsPlus','County','dbo','[CountyId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','ApprenticeshipType','dbo','[ApprenticeshipTypeId],[CodeName],[ShortName],[FullName],[EducationLevelId]','','',0)
,('AvmsPlus','WageType','dbo','[WageTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','VacancySource','dbo','[VacancySourceId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','Application','dbo','[ApplicationId],[CandidateId],[VacancyId],[ApplicationStatusTypeId],[BeingSupportedBy],[LockedForSupportUntil],[WithdrawalAcknowledged],[ApplicationGuid]','[CVAttachmentId],[Notes],[WithdrawnOrDeclinedReasonId],[UnsuccessfulReasonId],[OutcomeReasonOther],[NextActionId],[NextActionOther]','',0)
,('AvmsPlus','ApplicationStatusType','dbo','[ApplicationStatusTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','VacancyHistoryEventType','dbo','[VacancyHistoryEventTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','ApplicationHistoryEvent','dbo','[ApplicationHistoryEventId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','EmployerTrainingProviderStatus','dbo','[EmployerTrainingProviderStatusId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','ApprenticeshipFrameworkStatusType','dbo','[ApprenticeshipFrameworkStatusTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','ApprenticeshipOccupationStatusType','dbo','[ApprenticeshipOccupationStatusTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','LocalAuthorityGroup','dbo','[LocalAuthorityGroupID],[CodeName],[ShortName],[FullName],[LocalAuthorityGroupTypeID],[LocalAuthorityGroupPurposeID],[ParentLocalAuthorityGroupID]','','',0)
,('AvmsPlus','LocalAuthorityGroupMembership','dbo','[LocalAuthorityID],[LocalAuthorityGroupID]','','',0)
,('AvmsPlus','LocalAuthorityGroupType','dbo','[LocalAuthorityGroupTypeID],[LocalAuthorityGroupTypeName]','','',0)
,('AvmsPlus','VacancyLocationType','dbo','[VacancyLocationTypeId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','WageUnit','dbo','[WageUnitId],[CodeName],[ShortName],[FullName]','','',0)
,('AvmsPlus','ApplicationHistory','dbo','[ApplicationHistoryId],[ApplicationId],[ApplicationHistoryEventDate],[ApplicationHistoryEventTypeId],[ApplicationHistoryEventSubTypeId]','[UserName],[Comment]','',0)
/* Employer Incentives */
,('EmpInc','Accounts','dbo','[Id],[AccountLegalEntityId],[LegalEntityId],[HasSignedIncentivesTerms],[VrfVendorId],[VrfCaseId],[VrfCaseStatus],[VrfCaseStatusLastUpdatedDateTime]','[LegalEntityName]','',1)
,('EmpInc','IncentiveApplication','dbo','[Id],[AccountId],[AccountLegalEntityId],[DateCreated],[Status],[DateSubmitted]','[SubmittedByEmail],[SubmittedByName]','',0)
,('EmpInc','IncentiveApplicationApprenticeship','dbo','[Id],[IncentiveApplicationId],[ApprenticeshipId],[PlannedStartDate],[ApprenticeshipEmployerTypeOnApproval],[TotalIncentiveAmount],[EarningsCalculated]','[FirstName],[LastName],[DateOfBirth],[ULN]','',0)
,('EmpInc','ApprenticeshipIncentive','incentives','[Id],[AccountId],[ApprenticeshipId],[EmployerType],[IncentiveApplicationApprenticeshipId],[AccountLegalEntityId]','[FirstName],[LastName],[DateOfBirth],[ULN],[PlannedStartDate]','',0)
,('EmpInc','PendingPayment','incentives','[Id],[AccountId],[ApprenticeshipIncentiveId],[DueDate],[Amount],[CalculatedDate],[PaymentMadeDate],[PeriodNumber],[PaymentYear],[AccountLegalEntityId]','','',0)
,('EmpInc','CollectionCalendar','incentives','[Id],[PeriodNumber],[CalendarMonth],[CalendarYear],[EIScheduledOpenDateUTC]','','',0)


INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,PLTableName,[ModelDataToPL])
/* Accounts and Users */
VALUES
 ('Users','User','dbo','[Id],[IsActive],[FailedLoginAttempts],[IsLocked]','[Salt],[PasswordProfileId]','[FirstName],[LastName],[Email]','EAU_User',0)
,('Accounts','Account','Employer_Account','[Id],[HashedId],[CreatedDate],[ModifiedDate],[ApprenticeshipEmployerType]','','[Name],[PublicHashedId]','Acc_Account',1)
,('Accounts','EmployerAgreement','Employer_Account','[Id],[TemplateId],[StatusId],[SignedDate],[AccountLegalEntityId],[ExpiredDate],[SignedById]','[SignedByName]','','Acc_EmployerAgreement',0)
,('Accounts','EmployerAgreementStatus','Employer_Account','[Id],[name]','','','Acc_EmployerAgreementStatus',0)
,('Accounts','AccountLegalEntity','Employer_Account','[Id],[AccountId],[LegalEntityId],[Created],[Modified],[SignedAgreementVersion],[SignedAgreementId],[PendingAgreementVersion],[PendingAgreementId],[Deleted]','[Address],[PublicHashedId]','[Name]','Acc_AccountLegalEntity',1)
,('Accounts','LegalEntity','Employer_Account','[Id],[Code],[DateOfIncorporation],[Status],[Source],[PublicSectorDataSource],[Sector]','','','Acc_LegalEntity',0)
,('Accounts','Membership','Employer_Account','[AccountId],[UserId],[Role],[CreatedDate],[ShowWizard]','','','Acc_AccountUserRole',0)
,('Accounts','UserAccountSettings','Employer_Account','[ID],[UserId],[AccountId],[ReceiveNotifications]','','','Acc_UserAccountSettings',0)
,('Accounts','User','Employer_Account','[ID],[UserRef],[CorrelationId]','','[Email],[FirstName],[LastName]','Acc_User',0)
,('Accounts','AccountHistory','Employer_Account','[Id],[AccountId],[AddedDate],[RemovedDate]','','[PayeRef]','Acc_AccountHistory',0)
,('Accounts','Paye','employer_account','[Ref]','[AccessToken],[RefreshToken],[Aorn]','[Name]','Acc_Paye',0)
,('Accounts','TransferConnectionInvitation','employer_account','[Id],[SenderAccountId],[ReceiverAccountId],[Status],[DeletedBySender],[DeletedByReceiver],[CreatedDate]','[ConnectionHash]','','Acc_TransferConnectionInvitation',0)
,('Accounts','TransferConnectionInvitationChange','employer_account','[Id],[TransferConnectionInvitationId],[SenderAccountId],[ReceiverAccountId],[Status],[DeletedBySender],[DeletedByReceiver],[UserId],[CreatedDate]','','','Acc_TransferConnectionInvitationChange',0)
,('Commitments','Accounts','dbo','[Id],[HashedId],[Created],[Updated],[LevyStatus]','[PublicHashedId],[Name]','','Comt_Accounts',1)
,('Commitments','Commitment','dbo','[Id],[Reference],[EmployerAccountId],[ProviderId],[CommitmentStatus],[EditStatus],[CreatedOn],[LastAction],[TransferSenderId],[TransferApprovalStatus],[TransferApprovalActionedOn],[Originator],[ApprenticeshipEmployerTypeOnApproval],[IsFullApprovalProcessed],[IsDeleted],[AccountLegalEntityId],[IsDraft],[WithParty],[LastUpdatedOn],[Approvals],[EmployerAndProviderApprovedOn],[ChangeOfPartyRequestId]','[LastUpdatedByEmployerName],[LastUpdatedByEmployerEmail],[LastUpdatedByProviderName],[LastUpdatedByProviderEmail],[TransferApprovalActionedByEmployerName],[TransferApprovalActionedByEmployerEmail],[RowVersion]','','comt_commitment',0)
,('Commitments','Apprenticeship','dbo','[Id],[CommitmentId],[TrainingType],[TrainingCode],[TrainingName],[Cost],[StartDate],[EndDate],[AgreementStatus],[PaymentStatus],[EmployerRef],[ProviderRef],[CreatedOn],[AgreedOn],[PaymentOrder],[StopDate],[PauseDate],[HasHadDataLockSuccess],[PendingUpdateOriginator],[EPAOrgId],[CloneOf],[ReservationId],[IsApproved],[CompletionDate],[ContinuationOfId],[MadeRedundant],[OriginalStartDate],[Age]','[NINumber]','[FirstName],[LastName],[DateOfBirth],[ULN]','comt_Apprenticeship',0)
,('Commitments','Providers','dbo','[Created],[Updated]','','[Ukprn],[Name]','Comt_Providers',0)
,('Finance','AccountTransfers','employer_financial','[Id],[SenderAccountId],[ReceiverAccountId],[ApprenticeshipId],[CourseName],[CourseLevel],[PeriodEnd],[Amount],[Type],[CreatedDate],[RequiredPaymentId]','[SenderAccountName],[ReceiverAccountName]','','fin_AccountTransfers',0)
,('Finance','GetLevyDeclarationAndTopUp','employer_financial','[Id],[AccountId],[SubmissionDate],[SubmissionId],[LevyDueYTD],[EnglishFraction],[TopUpPercentage],[PayrollYear],[PayrollMonth],[LastSubmission],[CreatedDate],[EndOfYearAdjustment],[EndOfYearAdjustmentAmount],[LevyAllowanceForYear],[DateCeased],[InactiveFrom],[InactiveTo],[HmrcSubmissionId],[NoPaymentForPeriod],[LevyDeclaredInMonth],[TopUp],[TotalAmount]','','[EmpRef]','fin_GetLevyDeclarationAndTopUp',0)
,('Finance','Payment','employer_financial','[PaymentId],[AccountId],[ApprenticeshipId],[DeliveryPeriodMonth],[DeliveryPeriodYear],[CollectionPeriodId],[CollectionPeriodMonth],[CollectionPeriodYear],[EvidenceSubmittedOn],[EmployerAccountVersion],[ApprenticeshipVersion],[FundingSource],[TransactionType],[Amount],[PeriodEnd],[PaymentMetaDataId],[DateImported]','[Ukprn],[Uln]','','fin_Payment',0)
,('Finance','TransactionLine','employer_financial','[Id],[AccountId],[DateCreated],[SubmissionId],[TransactionDate],[TransactionType],[LevyDeclared],[Amount],[PeriodEnd],[SfaCoInvestmentAmount],[EmployerCoInvestmentAmount],[EnglishFraction],[TransferSenderAccountId],[TransferReceiverAccountId]','[TransferSenderAccountName],[TransferReceiverAccountName]','[EmpRef],[Ukprn]','fin_TransactionLine',0)
,('Reservation','Reservation','dbo','[Id],[AccountId],[IsLevyAccount],[CreatedDate],[StartDate],[ExpiryDate],[Status],[CourseId],[AccountLegalEntityId],[ProviderId],[TransferSenderAccountId],[UserId],[ClonedReservationId],[ConfirmedDate],[CohortId],[DraftApprenticeshipId]','[AccountLegalEntityName]','','resv_Reservation',0)
,('Reservation','Course','dbo','[CourseId],[Title],[Level],[EffectiveTo]','','','resv_Course',0)



/* Redundancy */

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,FullCopyToPL,ModelDataToPL,PLTableName)
/* Apprenticeship Redundancy */
VALUES 
 ('AppRedundancy','apprentice','dbo','[Id],[UpdatesWanted],[ContactableForFeedback],[PreviousTraining],[Employer],[TrainingProvider],[LeftOnApprenticeshipMonths],[LeftOnApprenticeshipYears],[Sectors],[CreatedOn]','[PhoneNumber],[PostCode],[EmployerLocation]','[FirstName],[LastName],[DateOfBirth],[Email],[Ethnicity],[EthnicitySubgroup],[EthnicityText],[Gender],[GenderText]',0,1,'AR_Apprentice')
,('AppRedundancy','employer','dbo','[ID],[OrganisationName],[ContactableForFeedback],[Locations],[Sectors],[CreatedOn]','[PhoneNumber]','[Email],[ApprenticeshipMoreDetails],[ContactFirstName],[ContactLastName]',0,1,'AR_Employer')





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