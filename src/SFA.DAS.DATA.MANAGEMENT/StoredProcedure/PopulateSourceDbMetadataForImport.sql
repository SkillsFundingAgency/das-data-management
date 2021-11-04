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
 ('AvmsPlus','Candidate','dbo','[CandidateId],[PersonId],[CandidateStatusTypeId],[ApplicationLimitEnforced],[LastAccessedDate],[DisableAlerts],[LastAccessedManageApplications],[BeingSupportedBy],[LockedForSupportUntil],[AllowMarketingMessages],[CandidateGuid]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[NiReference],[EthnicOrigin],[EthnicOriginOther],[AdditionalEmail],[Disability],[DisabilityOther],[HealthProblems],[UnconfirmedEmailAddress],[MobileNumberUnconfirmed],[NewVacancyAlertEmail],[NewVacancyAlertSMS],[CountyId],[LocalAuthorityId],[UniqueLearnerNumber],[UlnStatusId],[Gender],[ReferralAgent],[ReceivePushedContent],[DoBFailureCount],[ForgottenUsernameRequested],[ForgottenPasswordRequested],[TextFailureCount],[EmailFailureCount],[ReferralPoints],[ReminderMessageSent],[VoucherReferenceNumber],[DateofBirth],[Postcode]','',1)
,('AvmsPlus','CandidateHistory','dbo','[CandidateHistoryId],[CandidateId],[CandidateHistoryEventTypeId],[CandidateHistorySubEventTypeId],[EventDate],[Comment],[UserName]','','',1)
,('AvmsPlus','CandidateHistoryEvent','dbo','[CandidateHistoryEventId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','Vacancy','dbo','[VacancyId],[VacancyOwnerRelationshipId],[VacancyReferenceNumber],[VacancyStatusId],[ApprenticeshipFrameworkId],[Title],[ApprenticeshipType],[ShortDescription],[Description],[WeeklyWage],[WageLowerBound],[WageUpperBound],[WageType],[WageTypeReason],[WageText],[NumberofPositions],[ApplicationClosingDate],[InterviewsFromDate],[ExpectedStartDate],[ExpectedDuration],[WorkingWeek],[NumberOfViews],[MaxNumberofApplications],[ApplyOutsideNAVMS],[BeingSupportedBy],[LockedForSupportUntil],[NoOfOfflineApplicants],[MasterVacancyId],[VacancyLocationTypeId],[NoOfOfflineSystemApplicants],[DeliveryOrganisationID],[ContractOwnerID],[SmallEmployerWageIncentive],[OriginalContractOwnerId],[VacancyGuid],[SubmissionCount],[StartedToQADateTime],[StandardId],[HoursPerWeek],[WageUnitId],[DurationTypeId],[DurationValue],[TrainingTypeId],[VacancyTypeId],[SectorId],[UpdatedDateTime],[EditedInRaa],[VacancySourceId],[OfflineVacancyTypeId],[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[GeocodeEasting],[GeocodeNorthing],[Longitude],[Latitude],[LocalAuthorityId],[CountyId],[PostCode]','[ContactEmail],[ContactNumber],[QAUserName],[ContactName],[EmployerDescription],[EmployersWebsite],[EmployersRecruitmentWebsite],[EmployerAnonymousReason],[AnonymousAboutTheEmployer],[IsDisabilityConfident],[AdditionalLocationInformation],[VacancyManagerAnonymous],[VacancyManagerID],[EmployerAnonymousName],[EmployersApplicationInstructions]','',1)
,('AvmsPlus','VacancyStatusType','dbo','[VacancyStatusTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','VacancyOwnerRelationship','dbo','[VacancyOwnerRelationshipId],[EmployerId],[ProviderSiteID],[ContractHolderIsEmployer],[StatusTypeId],[NationWideAllowed],[EditedInRaa]','[ManagerIsEmployer],[EmployerDescription],[EmployerWebsite],[EmployerLogoAttachmentId],[Notes]','',1)
,('AvmsPlus','Employer','dbo','[EmployerId],[FullName],[TradingName],[OwnerOrgnistaion],[TotalVacanciesPosted],[BeingSupportedBy],[LockedForSupportUntil],[EmployerStatusTypeId]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[NumberofEmployeesAtSite],[NumberOfEmployeesInGroup],[PrimaryContact],[CompanyRegistrationNumber],[EdsUrn],[CountyId],[PostCode],[DisableAllowed],[TrackingAllowed],[LocalAuthorityId]','',1)
,('AvmsPlus','ProviderSite','dbo','[ProviderSiteID],[FullName],[TradingName],[TrainingProviderStatusTypeId],[IsRecruitmentAgency],[OwnerOrganisation]','[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[ContactDetailsForEmployer],[ContactDetailsForCandidate],[EDSURN],[CountyId],[PostCode],[LocalAuthorityId],[ManagingAreaID],[EmployerDescription],[CandidateDescription],[WebPage],[OutofDate],[HideFromSearch],[ContactDetailsAsARecruitmentAgency]','',1)
,('AvmsPlus','ProviderSiteRelationship','dbo','[ProviderSiteRelationshipID],[ProviderID],[ProviderSiteID],[ProviderSiteRelationShipTypeID]','','',1)
,('AvmsPlus','ProviderSiteRelationshipType','dbo','[ProviderSiteRelationshipTypeID],[ProviderSiteRelationshipTypeName]','','',1)
,('AvmsPlus','Provider','dbo','[ProviderID],[UKPRN],[FullName],[TradingName],[IsContracted],[ContractedFrom],[ContractedTo],[ProviderStatusTypeID],[IsNASProvider],[ProviderToUseFAA]','[UPIN],[OriginalUPIN],[MigrateProviderMessageID]','',1)
,('AvmsPlus','TrainingType','dbo','[TrainingTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','Standard','Reference','[StandardId],[StandardSectorId],[LarsCode],[FullName],[EducationLevelId],[ApprenticeshipFrameworkStatusTypeId],[EducationLevelNumber]','','',1)
,('AvmsPlus','StandardSector','Reference','[StandardSectorId],[FullName],[ApprenticeshipOccupationId],[LarsStandardSectorCode]','','',1)
,('AvmsPlus','EducationLevel','Reference','[EducationLevelId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','ApprenticeshipFramework','dbo','[ApprenticeshipFrameworkId],[ApprenticeshipOccupationId],[CodeName],[ShortName],[FullName],[ApprenticeshipFrameworkStatusTypeId],[ClosedDate],[PreviousApprenticeshipOccupationId],[StandardId]','','',1)
,('AvmsPlus','ApprenticeshipOccupation','dbo','[ApprenticeshipOccupationId],[Codename],[ShortName],[FullName],[ApprenticeshipOccupationStatusTypeId],[ClosedDate]','','',1)
,('AvmsPlus','VacancyHistory','dbo','[VacancyHistoryId],[VacancyId],[VacancyHistoryEventTypeId],[VacancyHistoryEventSubTypeId],[HistoryDate],[Comment]','[UserName]','',1)
,('AvmsPlus','LocalAuthority','dbo','[LocalAuthorityId],[CodeName],[ShortName],[FullName],[CountyId]','','',1)
,('AvmsPlus','County','dbo','[CountyId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','ApprenticeshipType','dbo','[ApprenticeshipTypeId],[CodeName],[ShortName],[FullName],[EducationLevelId]','','',1)
,('AvmsPlus','WageType','dbo','[WageTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','VacancySource','dbo','[VacancySourceId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','Application','dbo','[ApplicationId],[CandidateId],[VacancyId],[ApplicationStatusTypeId],[BeingSupportedBy],[LockedForSupportUntil],[WithdrawalAcknowledged],[ApplicationGuid]','[CVAttachmentId],[Notes],[WithdrawnOrDeclinedReasonId],[UnsuccessfulReasonId],[OutcomeReasonOther],[NextActionId],[NextActionOther]','',1)
,('AvmsPlus','ApplicationStatusType','dbo','[ApplicationStatusTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','VacancyHistoryEventType','dbo','[VacancyHistoryEventTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','ApplicationHistoryEvent','dbo','[ApplicationHistoryEventId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','EmployerTrainingProviderStatus','dbo','[EmployerTrainingProviderStatusId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','ApprenticeshipFrameworkStatusType','dbo','[ApprenticeshipFrameworkStatusTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','ApprenticeshipOccupationStatusType','dbo','[ApprenticeshipOccupationStatusTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','LocalAuthorityGroup','dbo','[LocalAuthorityGroupID],[CodeName],[ShortName],[FullName],[LocalAuthorityGroupTypeID],[LocalAuthorityGroupPurposeID],[ParentLocalAuthorityGroupID]','','',1)
,('AvmsPlus','LocalAuthorityGroupMembership','dbo','[LocalAuthorityID],[LocalAuthorityGroupID]','','',1)
,('AvmsPlus','LocalAuthorityGroupType','dbo','[LocalAuthorityGroupTypeID],[LocalAuthorityGroupTypeName]','','',1)
,('AvmsPlus','VacancyLocationType','dbo','[VacancyLocationTypeId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','WageUnit','dbo','[WageUnitId],[CodeName],[ShortName],[FullName]','','',1)
,('AvmsPlus','ApplicationHistory','dbo','[ApplicationHistoryId],[ApplicationId],[ApplicationHistoryEventDate],[ApplicationHistoryEventTypeId],[ApplicationHistoryEventSubTypeId]','[UserName],[Comment]','',1)
,('AvmsPlus','VacancyTextField','dbo','[VacancyTextFieldId],[VacancyId],[Field],[Value]','','',1)
,('AvmsPlus','VacancyTextFieldValue','dbo','[VacancyTextFieldValueId],[CodeName],[ShortName],[FullName]','','',1)

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,ModelDataToPL,IsQueryBasedImport,SourceQuery,StagingTableName)
VALUES
  ('AvmsPlus','ModelledCandidateAgePostcode','NA','[CandidateId]','','[AgeAtRegistration],[PostCode]',1,1,'SELECT C.CandidateId as [CandidateId],CASE WHEN [c].[DateOfBirth] IS NULL	THEN - 1 WHEN DATEPART([M], [c].[DateOfBirth]) > DATEPART([M], CH.EventDate) OR DATEPART([M], [c].[DateOfBirth]) = DATEPART([M], CH.EventDate) AND DATEPART([DD], [c].[DateOfBirth]) > DATEPART([DD], CH.EventDate) THEN DATEDIFF(YEAR, [c].[DateOfBirth], CH.EventDate) - 1 ELSE DATEDIFF(YEAR, [c].[DateOfBirth], CH.EventDate) END as [AgeAtRegistration],CASE WHEN CHARINDEX('''' '''',Postcode)<>0 THEN SUBSTRING(PostCode,1,CHARINDEX('''' '''',Postcode)) ELSE SUBSTRING(Postcode,1,LEN(Postcode)-3) end as [PostCode] FROM dbo.Candidate c LEFT JOIN dbo.CandidateHistory CH ON CH.CandidateId=C.CandidateId AND CH.Comment=''''NAS Exemplar registered Candidate.''''','Avms_CandidateAgePostCode')
 ,('AvmsPlus','ModelledAgeAtRegistration','NA','[ApplicationId]','','[AgeAtApplication]',1,1,'SELECT A.ApplicationId as [ApplicationId],CASE WHEN [c].[DateOfBirth] IS NULL	THEN - 1 WHEN DATEPART([M], [c].[DateOfBirth]) > DATEPART([M], AH.HistoryDate) OR DATEPART([M], [c].[DateOfBirth]) = DATEPART([M], AH.HistoryDate) AND DATEPART([DD], [c].[DateOfBirth]) > DATEPART([DD], AH.HistoryDate) THEN DATEDIFF(YEAR, [c].[DateOfBirth], AH.HistoryDate) - 1 ELSE DATEDIFF(YEAR, [c].[DateOfBirth], AH.HistoryDate) END as [AgeAtApplication] from dbo.Application A left join (select ApplicationId,min(ApplicationHistoryEventDate) HistoryDate from dbo.ApplicationHistory Ah group by ApplicationId) AH ON AH.ApplicationId=A.ApplicationId left join dbo.Candidate c on c.CandidateId=a.CandidateId','Avms_AgeAtApplication')
/* Employer Incentives */

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,[ModelDataToPL])
VALUES
 ('EmpInc','Accounts','dbo','[Id],[AccountLegalEntityId],[LegalEntityId],[SignedAgreementVersion],[VrfVendorId],[VrfCaseId],[VrfCaseStatus],[VrfCaseStatusLastUpdatedDateTime]','[LegalEntityName]','[HashedLegalEntityId]',1)
,('EmpInc','IncentiveApplication','dbo','[Id],[AccountId],[AccountLegalEntityId],[DateCreated],[Status],[DateSubmitted]','[SubmittedByEmail],[SubmittedByName]','',0)
,('EmpInc','IncentiveApplicationApprenticeship','dbo','[Id],[IncentiveApplicationId],[ApprenticeshipId],[PlannedStartDate],[ApprenticeshipEmployerTypeOnApproval],[EarningsCalculated],[WithdrawnByEmployer],[WithdrawnByCompliance],[CourseName],[EmploymentStartDate],[Phase],[HasEligibleEmploymentStartDate]','[FirstName],[LastName],[DateOfBirth],[ULN],[TotalIncentiveAmount]','[UKPRN]',0)
,('EmpInc','IncentiveApplicationStatusAudit','dbo','[Id],[IncentiveApplicationApprenticeshipId],[Process],[ServiceRequestTaskId],[ServiceRequestCreatedDate],[CreatedDateTime]','','[ServiceRequestDecisionReference]',0)
,('EmpInc','ApprenticeshipBreakInLearning','incentives','[ApprenticeshipIncentiveId],[StartDate],[EndDate]','','',0)
,('EmpInc','ApprenticeshipDaysInLearning','incentives','[LearnerId],[NumberOfDaysInLearning],[CollectionPeriodNumber],[CollectionPeriodYear],[CreatedDate],[UpdatedDate]','','',0)
,('EmpInc','ApprenticeshipIncentive','incentives','[Id],[AccountId],[ApprenticeshipId],[EmployerType],[StartDate],[IncentiveApplicationApprenticeshipId],[AccountLegalEntityId],[RefreshedLearnerForEarnings],[HasPossibleChangeOfCircumstances],[PausePayments],[SubmittedDate],[CourseName],[Status],[MinimumAgreementVersion],[EmploymentStartDate],[Phase]','[FirstName],[LastName],[DateOfBirth],[ULN],[SubmittedByEmail]','[UKPRN]',0)
,('EmpInc','ChangeOfCircumstance','incentives','[Id],[ApprenticeshipIncentiveId],[ChangeType],[PreviousValue],[NewValue],[ChangedDate]','','',0)
,('EmpInc','ClawbackPayment','incentives','[Id],[ApprenticeshipIncentiveId],[PendingPaymentId],[AccountId],[AccountLegalEntityId],[Amount],[DateClawbackCreated],[DateClawbackSent],[CollectionPeriod],[CollectionPeriodYear],[SubNominalCode],[PaymentId]','','',0)
,('EmpInc','CollectionCalendar','incentives','[Id],[PeriodNumber],[CalendarMonth],[CalendarYear],[EIScheduledOpenDateUTC],[CensusDate],[AcademicYear],[Active]','','',0)
,('EmpInc','Learner','incentives','[Id],[ApprenticeshipIncentiveId],[ApprenticeshipId],[SubmissionFound],[SubmissionDate],[LearningFound],[HasDataLock],[StartDate],[InLearning],[CreatedDate],[UpdatedDate],[LearningStoppedDate],[LearningResumedDate]','[ULN],[RawJSON]','[Ukprn]',0)
,('EmpInc','LearningPeriod','incentives','[LearnerId],[StartDate],[EndDate],[CreatedDate]','','',0)
,('EmpInc','Payment','incentives','[Id],[ApprenticeshipIncentiveId],[PendingPaymentId],[AccountId],[AccountLegalEntityId],[CalculatedDate],[PaidDate],[SubNominalCode],[PaymentPeriod],[PaymentYear],[Amount]','','',0)
,('EmpInc','PendingPayment','incentives','[Id],[AccountId],[ApprenticeshipIncentiveId],[DueDate],[Amount],[CalculatedDate],[PaymentMadeDate],[PeriodNumber],[PaymentYear],[AccountLegalEntityId],[EarningType],[ClawedBack]','','',0)
,('EmpInc','PendingPaymentValidationResult','incentives','[Id],[PendingPaymentId],[Step],[Result],[PeriodNumber],[PaymentYear],[CreatedDateUTC]','','',0)

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,PLTableName,[ModelDataToPL])
/* Accounts and Users */
VALUES
 ('Users','User','dbo','[Id],[IsActive],[FailedLoginAttempts],[IsLocked],[IsSuspended]','[Salt],[PasswordProfileId]','[FirstName],[LastName],[Email]','EAU_User',0)
,('Accounts','Account','Employer_Account','[Id],[HashedId],[CreatedDate],[ModifiedDate],[ApprenticeshipEmployerType]','','[Name],[PublicHashedId]','Acc_Account',1)
,('Accounts','EmployerAgreement','Employer_Account','[Id],[TemplateId],[StatusId],[SignedDate],[AccountLegalEntityId],[ExpiredDate],[SignedById]','[SignedByName]','','Acc_EmployerAgreement',0)
,('Accounts','EmployerAgreementStatus','Employer_Account','[Id],[name]','','','Acc_EmployerAgreementStatus',0)
,('Accounts','AccountLegalEntity','Employer_Account','[Id],[AccountId],[LegalEntityId],[Created],[Modified],[SignedAgreementVersion],[SignedAgreementId],[PendingAgreementVersion],[PendingAgreementId],[Deleted]','[PublicHashedId]','[Name],[Address]','Acc_AccountLegalEntity',1)
,('Accounts','LegalEntity','Employer_Account','[Id],[Code],[DateOfIncorporation],[Status],[Source],[PublicSectorDataSource],[Sector]','','','Acc_LegalEntity',0)
,('Accounts','Membership','Employer_Account','[AccountId],[UserId],[Role],[CreatedDate],[ShowWizard]','','','Acc_AccountUserRole',0)
,('Accounts','UserAccountSettings','Employer_Account','[ID],[UserId],[AccountId],[ReceiveNotifications]','','','Acc_UserAccountSettings',0)
,('Accounts','User','Employer_Account','[ID],[UserRef],[CorrelationId]','','[Email],[FirstName],[LastName]','Acc_User',0)
,('Accounts','AccountHistory','Employer_Account','[Id],[AccountId],[AddedDate],[RemovedDate]','','[PayeRef]','Acc_AccountHistory',1)
,('Accounts','Paye','employer_account','[Name]','[AccessToken],[RefreshToken],[Aorn]','[Ref]','Acc_Paye',1)
,('Accounts','TransferConnectionInvitation','employer_account','[Id],[SenderAccountId],[ReceiverAccountId],[Status],[DeletedBySender],[DeletedByReceiver],[CreatedDate]','[ConnectionHash]','','Acc_TransferConnectionInvitation',0)
,('Accounts','TransferConnectionInvitationChange','employer_account','[Id],[TransferConnectionInvitationId],[SenderAccountId],[ReceiverAccountId],[Status],[DeletedBySender],[DeletedByReceiver],[UserId],[CreatedDate]','','','Acc_TransferConnectionInvitationChange',0)
,('Commitments','Accounts','dbo','[Id],[HashedId],[Created],[Updated],[LevyStatus]','[PublicHashedId],[Name]','','Comt_Accounts',1)
,('Commitments','Commitment','dbo','[Id],[Reference],[EmployerAccountId],[ProviderId],[CommitmentStatus],[EditStatus],[CreatedOn],[LastAction],[TransferSenderId],[TransferApprovalStatus],[TransferApprovalActionedOn],[Originator],[ApprenticeshipEmployerTypeOnApproval],[IsFullApprovalProcessed],[IsDeleted],[AccountLegalEntityId],[IsDraft],[WithParty],[LastUpdatedOn],[Approvals],[EmployerAndProviderApprovedOn],[ChangeOfPartyRequestId]','[LastUpdatedByEmployerName],[LastUpdatedByEmployerEmail],[LastUpdatedByProviderName],[LastUpdatedByProviderEmail],[TransferApprovalActionedByEmployerName],[TransferApprovalActionedByEmployerEmail],[RowVersion]','','comt_commitment',0)
,('Commitments','Apprenticeship','dbo','[Id],[CommitmentId],[TrainingType],[TrainingCode],[TrainingName],[Cost],[StartDate],[EndDate],[AgreementStatus],[PaymentStatus],[CreatedOn],[AgreedOn],[PaymentOrder],[StopDate],[PauseDate],[HasHadDataLockSuccess],[PendingUpdateOriginator],[EPAOrgId],[CloneOf],[ReservationId],[IsApproved],[CompletionDate],[ContinuationOfId],[MadeRedundant],[OriginalStartDate],[TrainingCourseVersion],[TrainingCourseVersionConfirmed],[TrainingCourseOption],[Age]','[NINumber],[EmployerRef],[ProviderRef]','[FirstName],[LastName],[DateOfBirth],[ULN],[StandardUId]','comt_Apprenticeship',1)
,('Commitments','ApprenticeshipUpdate','dbo','[Id],[ApprenticeshipId],[Originator],[Status],[TrainingType],[TrainingCode],[TrainingName],[TrainingCourseVersion],[TrainingCourseOption],[Cost],[StartDate],[EndDate],[CreatedOn],[UpdateOrigin],[EffectiveFromDate],[EffectiveToDate]','[FirstName],[LastName],[DateOfBirth],[Email]','','comt_ApprenticeshipUpdate',1)
,('Commitments','Providers','dbo','[Created],[Updated]','','[Ukprn],[Name]','Comt_Providers',1)
,('Commitments','DataLockStatus','dbo','[Id],[DataLockEventId],[DataLockEventDatetime],[PriceEpisodeIdentifier],[ApprenticeshipId],[IlrTrainingCourseCode],[IlrTrainingType],[IlrActualStartDate],[IlrEffectiveFromDate],[IlrPriceEffectiveToDate],[IlrTotalCost],[ErrorCode],[Status],[TriageStatus],[ApprenticeshipUpdateId],[IsResolved],[EventStatus],[IsExpired],[Expired]','','','Comt_DataLockStatus',0)
,('Commitments','ApprenticeshipConfirmationStatus','dbo','[ApprenticeshipId],[ApprenticeshipConfirmedOn],[CommitmentsApprovedOn],[ConfirmationOverdueOn]','','','Comt_ApprenticeshipConfirmationStatus',0)
,('Commitments','Standard','dbo','[StandardUId],[LarsCode],[IFateReferenceNumber],[Version],[Level],[Duration],[MaxFunding],[EffectiveFrom],[EffectiveTo],[VersionMajor],[VersionMinor],[StandardPageUrl],[Status],[IsLatestVersion]','','[Title]','Comt_Standard',1)
,('Commitments','StandardOption','dbo','[StandardUId],[Option]','','','Comt_StandardOption',0)
,('Finance','AccountTransfers','employer_financial','[Id],[SenderAccountId],[ReceiverAccountId],[ApprenticeshipId],[CourseName],[CourseLevel],[PeriodEnd],[Amount],[Type],[CreatedDate],[RequiredPaymentId]','[SenderAccountName],[ReceiverAccountName]','','fin_AccountTransfers',0)
,('Finance','GetLevyDeclarationAndTopUp','employer_financial','[Id],[AccountId],[SubmissionDate],[SubmissionId],[LevyDueYTD],[EnglishFraction],[TopUpPercentage],[PayrollYear],[PayrollMonth],[LastSubmission],[CreatedDate],[EndOfYearAdjustment],[EndOfYearAdjustmentAmount],[LevyAllowanceForYear],[DateCeased],[InactiveFrom],[InactiveTo],[HmrcSubmissionId],[NoPaymentForPeriod],[LevyDeclaredInMonth],[TopUp],[TotalAmount]','','[EmpRef]','fin_GetLevyDeclarationAndTopUp',1)
,('Finance','Payment','employer_financial','[PaymentId],[AccountId],[ApprenticeshipId],[DeliveryPeriodMonth],[DeliveryPeriodYear],[CollectionPeriodId],[CollectionPeriodMonth],[CollectionPeriodYear],[EvidenceSubmittedOn],[EmployerAccountVersion],[ApprenticeshipVersion],[FundingSource],[TransactionType],[Amount],[PeriodEnd],[PaymentMetaDataId],[DateImported]','[Ukprn],[Uln]','','fin_Payment',0)
,('Finance','TransactionLine','employer_financial','[Id],[AccountId],[DateCreated],[SubmissionId],[TransactionDate],[TransactionType],[LevyDeclared],[Amount],[PeriodEnd],[SfaCoInvestmentAmount],[EmployerCoInvestmentAmount],[EnglishFraction],[TransferSenderAccountId],[TransferReceiverAccountId],[TransferSenderAccountName],[TransferReceiverAccountName]','','[EmpRef],[Ukprn]','fin_TransactionLine',1)
,('Reservation','Reservation','dbo','[Id],[AccountId],[IsLevyAccount],[CreatedDate],[StartDate],[ExpiryDate],[Status],[CourseId],[AccountLegalEntityId],[ProviderId],[TransferSenderAccountId],[UserId],[ClonedReservationId],[ConfirmedDate],[CohortId],[DraftApprenticeshipId]','[AccountLegalEntityName]','','resv_Reservation',0)
,('Reservation','Course','dbo','[CourseId],[Title],[Level],[EffectiveTo]','','','resv_Course',0)

/* Commitments Query Based Import */

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,StagingTableName,PLTableName,[ModelDataToPL],[IsQueryBasedImport],SourceQuery)
VALUES
('Commitments','History','dbo','[Id],[EntityType],[EntityId],[CommitmentId],[ApprenticeshipId],[UpdatedByRole],[ChangeType],[CreatedOn],[ProviderId],[EmployerAccountId],[OriginalState_PaymentStatus],[UpdatedState_PaymentStatus],[CorrelationId]','[UpdatedByName],[Diff],[UserId]','','Comt_History','Comt_History',0,1,'SELECT [Id],[EntityType],[EntityId],[CommitmentId],[ApprenticeshipId],[UserId],[UpdatedByRole],[ChangeType],[CreatedOn],[ProviderId],[EmployerAccountId],[UpdatedByName],JSON_VALUE(History.OriginalState, ''''$.PaymentStatus'''') OriginalState_PaymentStatus , JSON_VALUE(History.UpdatedState, ''''$.PaymentStatus'''') UpdatedState_PaymentStatus,[Diff],[CorrelationId] FROM [dbo].[History]')


/* Redundancy */

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,FullCopyToPL,ModelDataToPL,PLTableName)
/* Apprenticeship Redundancy */
VALUES 
 ('AppRedundancy','apprentice','dbo','[Id],[UpdatesWanted],[ContactableForFeedback],[PreviousTraining],[Employer],[TrainingProvider],[LeftOnApprenticeshipMonths],[LeftOnApprenticeshipYears],[Sectors],[CreatedOn]','[PhoneNumber],[PostCode],[EmployerLocation]','[FirstName],[LastName],[DateOfBirth],[Email],[Ethnicity],[EthnicitySubgroup],[EthnicityText],[Gender],[GenderText]',0,1,'AR_Apprentice')
,('AppRedundancy','employer','dbo','[ID],[OrganisationName],[ContactableForFeedback],[Locations],[Sectors],[CreatedOn]','[PhoneNumber]','[Email],[ApprenticeshipMoreDetails],[ContactFirstName],[ContactLastName]',0,1,'AR_Employer')


/* CRS Delivery Import Configurations */
INSERT INTO Mtd.SourceConfigForImport (SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,FullCopyToPL,ModelDataToPL,PLTableName)
VALUES
('CRSDelivery','NationalAchievementRate','dbo','[Id],[Age],[SectorSubjectArea],[ApprenticeshipLevel],[OverallCohort],[OverallAchievementRate]','','[UkPrn]',1,0,'FAT2_NationalAchievementRate'),
('CRSDelivery','NationalAchievementRateOverall','dbo','[Id],[Age],[SectorSubjectArea],[ApprenticeshipLevel],[OverallCohort],[OverallAchievementRate]','','',1,0,'FAT2_NationalAchievementRateOverall'),
('CRSDelivery','Provider','dbo','[TradingName],[EmployerSatisfaction],[LearnerSatisfaction]','[Phone],[Website],[MarketingInfo]','[UkPrn],[Name],[Email]',1,1,'Provider'),
('CRSDelivery','ProviderRegistration','dbo','[StatusDate],[StatusId],[ProviderTypeId],[OrganisationTypeId],[FeedbackTotal],[Postcode],[Lat],[Long]','[Address1],[Address2],[Address3],[Address4],[Town]','[UkPrn],[LegalName]',1,0,'FAT2_ProviderRegistration'),
('CRSDelivery','ProviderRegistrationFeedbackAttribute','dbo','[AttributeName],[Weakness],[Strength]','','[UkPrn]',1,0,'FAT2_ProviderRegistrationFeedbackAttribute'),
('CRSDelivery','ProviderRegistrationFeedbackRating','dbo','[FeedbackName],[FeedbackCount]','','[UkPrn]',1,0,'FAT2_ProviderRegistrationFeedbackRating'),
('CRSDelivery','ProviderStandard','dbo','[StandardId],[StandardInfoUrl]','[Phone],[ContactUrl]','[UkPrn],[Email]',1,0,'FAT2_ProviderStandard'),
('CRSDelivery','ProviderStandardLocation','dbo','[StandardId],[LocationId],[DeliveryModes],[Radius],[National]','','[UkPrn]',1,0,'FAT2_ProviderStandardLocation'),
('CRSDelivery','StandardLocation','dbo','[LocationId],[Postcode],[Lat],[Long]','[Phone],[Address1],[Address2],[Town],[County]','[Name],[Email],[Website]',1,0,'FAT2_StandardLocation'),
('CRSDelivery','ShortList','dbo','[Id],[ShortlistUserId],[StandardId],[CreatedDate],[Lat],[Long]','[LocationDescription]','[UkPrn],[CourseSector]',1,0,'FAT2_ShortList')


/* CRS Import Configurations */
INSERT INTO Mtd.SourceConfigForImport (SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,FullCopyToPL,ModelDataToPL,PLTableName)
VALUES
('CRS','ApprenticeshipFunding','dbo','[Id],[StandardUId],[EffectiveFrom],[EffectiveTo],[MaxEmployerLevyCap],[Duration]','','',1,0,'FAT2_ApprenticeshipFunding'),
('CRS','Framework','dbo','[Id],[ProgType],[FrameworkCode],[PathwayCode],[Level],[TypicalLengthFrom],[TypicalLengthTo],[TypicalLengthUnit],[Duration],[CurrentFundingCap],[MaxFunding],[Ssa1],[Ssa2],[EffectiveFrom],[EffectiveTo],[IsActiveFramework],[ProgrammeType],[HasSubGroups],[ExtendedTitle]','','[Title],[FrameworkName],[PathwayName]',1,1,'FAT2_Framework'),
('CRS','FrameworkFundingPeriod','dbo','[Id],[FrameworkId],[EffectiveFrom],[EffectiveTo],[FundingCap]','','',1,0,'FAT2_FrameworkFundingPeriod'),
('CRS','LarsStandard','dbo','[LarsCode],[Version],[EffectiveFrom],[EffectiveTo],[LastDateStarts],[SectorSubjectAreaTier2],[OtherBodyApprovalRequired],[SectorCode]','','',1,0,'FAT2_LarsStandard'),
('CRS','Route','dbo','[Id],[Name]','','',1,1,'FAT2_StandardSector'),
('CRS','SectorSubjectAreaTier2','dbo','[SectorSubjectAreaTier2],[SectorSubjectAreaTier2Desc],[EffectiveFrom],[EffectiveTo]','','[Name]',1,0,'FAT2_SectorSubjectAreaTier2'),
('CRS','Standard','dbo','[StandardUId],[IfateReferenceNumber],[LarsCode],[Status],[VersionEarliestStartDate],[VersionLatestStartDate],[VersionLatestEndDate],[Level],[ProposedTypicalDuration],[ProposedMaxFunding],[IntegratedDegree],[OverviewOfRole],[RouteCode],[AssessmentPlanUrl],[ApprovedForDelivery],[Keywords],[TypicalJobTitles],[StandardPageUrl],[Version],[RegulatedBody],[Skills],[Knowledge],[Behaviours],[Duties],[CoreAndOptions],[IntegratedApprenticeship],[Options],[CoreDuties]','','[Title],[TrailBlazerContact],[EqaProviderName],[EqaProviderContactName],[EqaProviderContactEmail],[EqaProviderWebLink]',1,1,'FAT2_StandardSector')

/* Roatp Import Configuration */

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,ModelDataToPL,IsQueryBasedImport,SourceQuery,StagingTableName)
VALUES
('Apply','Apply','NA','[ID],[ApplicationId],[OrganisationId],[ReferenceNumber],[ApplicationSubmittedOn],[ProviderRoute],[ProviderRouteName],[ApplicationStatus],[OutcomeDateTime],[GatewayReviewStatus],[AssessorReviewStatus],[ModerationStatus],[ModeratorClarificationRequestedOn],[FinancialReviewStatus],[FinancialClarificationRequestedOn],[CreatedAt],[UpdatedAt],[DeletedAt],[Assessor1ReviewStatus],[Assessor2ReviewStatus],[ApplicationDeterminedDate],[Comments],[ExternalComments],[ProviderRouteOnRegister],[ProviderRouteNameOnRegister]','','[UKPRN],[OrganisationName],[TradingName],[ApplicationSubmittedBy],[Assessor1Name],[Assessor2Name],[FinancialClarificationRequestedBy],[FinancialReviewGradedBy],[CreatedBy],[GatewayUserName],[FinancialGrade]',0,1
		,'SELECT Id,ApplicationId,OrganisationId,UKPRN,ReferenceNumber,OrganisationName,TradingName,ProviderRoute,ApplicationSubmittedOn,ApplicationSubmittedBy,ProviderRouteName,ApplicationStatus,OutcomeDateTime,GatewayReviewStatus,AssessorReviewStatus,ModerationStatus,ModeratorClarificationRequestedOn,STUFF(Assessor1Name,2,len(Assessor1Name)-2,REPLICATE(''''*'''',len(Assessor1Name)-2)) As Assessor1Name,STUFF(Assessor2Name,2,len(Assessor2Name)-2,REPLICATE(''''*'''',len(Assessor2Name)-2)) As Assessor2Name,FinancialReviewStatus,STUFF(FinancialClarificationRequestedBy,2,len(FinancialClarificationRequestedBy)-2,REPLICATE(''''*'''',len(FinancialClarificationRequestedBy)-2)) As FinancialClarificationRequestedBy,FinancialClarificationRequestedOn,STUFF(FinancialReviewGradedBy,2,len(FinancialReviewGradedBy)-2,REPLICATE(''''*'''',len(FinancialReviewGradedBy)-2)) As FinancialReviewGradedBy,STUFF(GatewayUserName,2,len(GatewayUserName)-2,REPLICATE(''''*'''',len(GatewayUserName)-2)) As GatewayUserName,CreatedAt,case when TRY_CONVERT(UNIQUEIDENTIFIER,[CreatedBy]) IS NOT NULL Then [CreatedBy] Else  STUFF([CreatedBy],2,len([CreatedBy])-2,REPLICATE(''''*'''',len([CreatedBy])-2)) End As [CreatedBy],UpdatedAt,DeletedAt,FinancialGrade,[Assessor1ReviewStatus],[Assessor2ReviewStatus],[ApplicationDeterminedDate],[Comments],[ExternalComments],ProviderRouteOnRegister,ProviderRouteNameOnRegister FROM (Select Id,ApplicationId,OrganisationId,UKPRN,JSON_VALUE(ApplyData,''''$.ApplyDetails.ReferenceNumber'''') ReferenceNumber,JSON_VALUE(ApplyData,''''$.ApplyDetails.OrganisationName'''') OrganisationName,JSON_VALUE(ApplyData,''''$.ApplyDetails.TradingName'''') TradingName,JSON_VALUE(ApplyData,''''$.ApplyDetails.ProviderRoute'''') ProviderRoute,JSON_VALUE(ApplyData,''''$.ApplyDetails.ApplicationSubmittedBy'''') ApplicationSubmittedBy,JSON_VALUE(ApplyData,''''$.ApplyDetails.ApplicationSubmittedOn'''') ApplicationSubmittedOn,JSON_VALUE(ApplyData,''''$.ApplyDetails.ProviderRouteName'''') ProviderRouteName,ApplicationStatus,JSON_VALUE(ApplyData,''''$.GatewayReviewDetails.OutcomeDateTime'''') OutcomeDateTime,GatewayReviewStatus,AssessorReviewStatus,ModerationStatus,JSON_VALUE(ApplyData,''''$.ModeratorReviewDetails.ClarificationRequestedOn'''') ModeratorClarificationRequestedOn,Assessor1Name,Assessor2Name,FinancialReviewStatus,JSON_VALUE(FinancialGrade,''''$.ClarificationRequestedBy'''') FinancialClarificationRequestedBy,JSON_VALUE(FinancialGrade,''''$.ClarificationRequestedOn'''') FinancialClarificationRequestedOn,JSON_VALUE(FinancialGrade,''''$.GradedBy'''') FinancialReviewGradedBy,GatewayUserName,CreatedAt,CreatedBy,UpdatedAt,DeletedAt,JSON_VALUE(FinancialGrade,''''$.SelectedGrade'''') As FinancialGrade,[Assessor1ReviewStatus],[Assessor2ReviewStatus],[ApplicationDeterminedDate],[Comments],[ExternalComments],JSON_VALUE(ApplyData, ''''$.ApplyDetails.ProviderRouteOnRegister'''') AS ProviderRouteOnRegister,JSON_VALUE(ApplyData, ''''$.ApplyDetails.ProviderRouteNameOnRegister'''') AS ProviderRouteNameOnRegister  from dbo.Apply) As a'
		,'RP_Apply')
,('Apply','Organisation','NA','[Id],[OrganisationType],[Status],[RoEPAOApproved],[RoATPApproved],[CreatedAt],[UpdatedAt],[DeletedAt],[OrganisationReferenceType],[VerificationId],[PrimaryVerificationSource],[VerificationId],[PrimaryVerificationSource]',''
		,'[Name],[OrganisationUKPRN],[UkprnOnRegister],[PostCode],[EndPointAssessmentOrgId],[OrganisationLegalName],[OrganisationTradingName],[VerificationAuthority],[CreatedBy]',0,1
		,'SELECT [Id],[Name],[OrganisationType],[OrganisationUKPRN],[Status],[RoEPAOApproved],[RoATPApproved],[CreatedAt],case when TRY_CONVERT(UNIQUEIDENTIFIER,[CreatedBy]) IS NOT NULL Then [CreatedBy] Else  STUFF([CreatedBy],2,len([CreatedBy])-2,REPLICATE(''''*'''',len([CreatedBy])-2)) End As [CreatedBy],[UpdatedAt],[DeletedAt],JSON_VALUE(OrganisationDetails,''''$.RoatpDetails.UkprnOnRegister'''') UkprnOnRegister,CASE WHEN CHARINDEX('''' '''',JSON_VALUE(OrganisationDetails,''''$.Postcode''''))<>0 THEN SUBSTRING(JSON_VALUE(OrganisationDetails,''''$.Postcode''''),1,CHARINDEX('''' '''',JSON_VALUE(OrganisationDetails,''''$.Postcode''''))) ELSE SUBSTRING(JSON_VALUE(OrganisationDetails,''''$.Postcode''''),1,LEN(JSON_VALUE(OrganisationDetails,''''$.Postcode''''))-3) end PostCode,JSON_VALUE(OrganisationDetails,''''$.OrganisationReferenceType'''') OrganisationReferenceType,JSON_VALUE(OrganisationDetails,''''$.LegalName'''') OrganisationLegalName,JSON_VALUE(OrganisationDetails,''''$.TradingName'''') OrganisationTradingName,JSON_VALUE(OrganisationDetails,''''$.EndPointAssessmentOrgId'''') EndPointAssessmentOrgId,JSON_VALUE(OrganisationDetails,''''$.UKRLPDetails.VerificationDetails[0].VerificationAuthority'''') VerificationAuthority,JSON_VALUE(OrganisationDetails,''''$.UKRLPDetails.VerificationDetails[0].VerificationId'''') VerificationId,JSON_VALUE(OrganisationDetails,''''$.UKRLPDetails.VerificationDetails[0].PrimaryVerificationSource'''') PrimaryVerificationSource  FROM [dbo].[Organisations]'
		,'RP_Organisations')
,('Apply','Appeal','dbo','[Id],[ApplicationId],[Status],[AppealSubmittedDate],[AppealDeterminedDate],[InProgressDate],[CreatedOn],[UpdatedOn]','[InternalComments],[ExternalComments],[InProgressInternalComments],[InProgressExternalComments],[HowFailedOnPolicyOrProcesses],[HowFailedOnEvidenceSubmitted]'
		,'[UserId],[UserName],[InProgressUserId],[InProgressUserName]',0,1
		,'select [Id],[ApplicationId],[Status],[AppealSubmittedDate],[AppealDeterminedDate],STUFF([UserId],2,len([UserId])-2,REPLICATE(''''*'''',len([UserId])-2)) As [UserId],STUFF([UserName],2,len([UserName])-2,REPLICATE(''''*'''',len([UserName])-2)) As [UserName],[InProgressDate],STUFF([InProgressUserId],2,len([InProgressUserId])-2,REPLICATE(''''*'''',len([InProgressUserId])-2)) As [InProgressUserId],STUFF([InProgressUserName],2,len([InProgressUserName])-2,REPLICATE(''''*'''',len([InProgressUserName])-2)) As [InProgressUserName],[CreatedOn],[UpdatedOn]   From [dbo].[Appeal]'
		,'RP_Appeal')
,('Apply','AssessorPageReviewOutcome','dbo','[Id],[ApplicationId],[SequenceNumber],[SectionNumber],[PageId],[Assessor1ReviewStatus],[Assessor1ReviewComment],[Assessor2ReviewStatus],[Assessor2ReviewComment],[CreatedAt],[UpdatedAt]',''
		,'[Assessor1UserId],[Assessor2UserId],[CreatedBy]',0,1
		,'select [Id],[ApplicationId],[SequenceNumber],[SectionNumber],[PageId],STUFF([Assessor1UserId],2,len([Assessor1UserId])-2,REPLICATE(''''*'''',len([Assessor1UserId])-2)) As [Assessor1UserId],[Assessor1ReviewStatus],[Assessor1ReviewComment],STUFF([Assessor2UserId],2,len([Assessor2UserId])-2,REPLICATE(''''*'''',len([Assessor2UserId])-2)) As [Assessor2UserId],[Assessor2ReviewStatus],[Assessor2ReviewComment],[CreatedAt],case when TRY_CONVERT(UNIQUEIDENTIFIER,[CreatedBy]) IS NOT NULL Then [CreatedBy] Else  STUFF([CreatedBy],2,len([CreatedBy])-2,REPLICATE(''''*'''',len([CreatedBy])-2)) End As [CreatedBy],[UpdatedAt]  from [dbo].[AssessorPageReviewOutcome]'
		,'RP_AssessorPageReviewOutcome')
,('Apply','Contacts','dbo','[Id],[ApplyOrganisationID],[Status],[CreatedAt],[UpdatedAt],[DeletedAt]','[GivenNames],[FamilyName],[ContactDetails]'
		,'[SigninId],[SigninType],[CreatedBy],[Email]',0,1
		,'select [Id],[Email],[GivenNames],[FamilyName],[SigninId],[SigninType],[ApplyOrganisationID],[ContactDetails],[Status],[CreatedAt],case when TRY_CONVERT(UNIQUEIDENTIFIER,[CreatedBy]) IS NOT NULL Then [CreatedBy] Else  STUFF([CreatedBy],2,len([CreatedBy])-2,REPLICATE(''''*'''',len([CreatedBy])-2)) End As [CreatedBy],[UpdatedAt],[DeletedAt]  from [dbo].[Contacts]'
		,'RP_Contacts')
,('Apply','FinancialData','dbo','[Id],[ApplicationId]',''
		,'[TurnOver],[Depreciation],[ProfitLoss],[Dividends],[IntangibleAssets],[Assets],[Liabilities],[ShareholderFunds],[Borrowings],[AccountingReferenceDate],[AccountingPeriod],[AverageNumberofFTEEmployees]',0,1
		,'select [Id],[ApplicationId],[TurnOver],[Depreciation],[ProfitLoss],[Dividends],[IntangibleAssets],[Assets],[Liabilities],[ShareholderFunds],[Borrowings],[AccountingReferenceDate],[AccountingPeriod],[AverageNumberofFTEEmployees]  from [dbo].[FinancialData]'
		,'RP_FinancialData')
,('Apply','GatewayAnswer','dbo','[Id],[ApplicationId],[PageId],[UpdatedAt]',''
		,'[Status],[Comments],[ClarificationComments],[ClarificationDate],[ClarificationBy],[ClarificationAnswer],[GatewayPageData]',0,1
		,'select [Id],[ApplicationId],[PageId],[Status],[Comments],[ClarificationComments],[ClarificationDate],STUFF([ClarificationBy],2,len([ClarificationBy])-2,REPLICATE(''''*'''',len([ClarificationBy])-2)) As [ClarificationBy],[ClarificationAnswer],[GatewayPageData],[UpdatedAt] from [dbo].[GatewayAnswer]'
		,'RP_GatewayAnswer')
,('Apply','ModeratorPageReviewOutcome','dbo','[Id],[ApplicationId],[SequenceNumber],[SectionNumber],[PageId],[ClarificationUpdatedAt],[CreatedAt],[UpdatedAt]',''
		,'[ModeratorUserId],[ModeratorReviewStatus],[ModeratorReviewComment],[ClarificationUserId],[ClarificationStatus],[ClarificationComment],[ClarificationResponse],[ClarificationFile],[CreatedBy],[ModeratorUserName],[ClarificationUserName]',0,1
		,'Select [Id],[ApplicationId],[SequenceNumber],[SectionNumber],[PageId],STUFF([ModeratorUserId],2,len([ModeratorUserId])-2,REPLICATE(''''*'''',len([ModeratorUserId])-2)) As [ModeratorUserId],STUFF([ModeratorUserName],2,len([ModeratorUserName])-2,REPLICATE(''''*'''',len([ModeratorUserName])-2)) As [ModeratorUserName],[ModeratorReviewStatus],[ModeratorReviewComment],STUFF([ClarificationUserId],2,len([ClarificationUserId])-2,REPLICATE(''''*'''',len([ClarificationUserId])-2)) As [ClarificationUserId],STUFF([ClarificationUserName],2,len([ClarificationUserName])-2,REPLICATE(''''*'''',len([ClarificationUserName])-2)) As [ClarificationUserName],[ClarificationStatus],[ClarificationComment],[ClarificationResponse],[ClarificationFile],[ClarificationUpdatedAt],[CreatedAt],case when TRY_CONVERT(UNIQUEIDENTIFIER,[CreatedBy]) IS NOT NULL Then [CreatedBy] Else  STUFF([CreatedBy],2,len([CreatedBy])-2,REPLICATE(''''*'''',len([CreatedBy])-2)) End As [CreatedBy],[UpdatedAt] from [dbo].[ModeratorPageReviewOutcome]'
		,'RP_ModeratorPageReviewOutcome')
,('Apply','OversightReview','dbo','[Id],[ApplicationId],[GatewayApproved],[ModerationApproved],[Status],[ApplicationDeterminedDate],[InternalComments],[ExternalComments],[InProgressDate],[InProgressInternalComments],[InProgressExternalComments],[CreatedOn],[UpdatedOn]',''
		,'[UserId],[InProgressUserId],[UserName],[InProgressUserName]',0,1
		,'select [Id],[ApplicationId],[GatewayApproved],[ModerationApproved],[Status],[ApplicationDeterminedDate],[InternalComments],[ExternalComments],STUFF([UserId],2,len([UserId])-2,REPLICATE(''''*'''',len([UserId])-2)) As [UserId],STUFF([UserName],2,len([UserName])-2,REPLICATE(''''*'''',len([UserName])-2)) As [UserName],[InProgressDate],STUFF([InProgressUserId],2,len([InProgressUserId])-2,REPLICATE(''''*'''',len([InProgressUserId])-2)) As [InProgressUserId],STUFF([InProgressUserName],2,len([InProgressUserName])-2,REPLICATE(''''*'''',len([InProgressUserName])-2)) As [InProgressUserName],[InProgressInternalComments],[InProgressExternalComments],[CreatedOn],[UpdatedOn] from [dbo].[OversightReview]'
		,'RP_OversightReview')
,('Apply','SubmittedApplicationAnswers','dbo','[Id],[ApplicationId],[SequenceNumber],[SectionNumber],[PageId],[Answer2],[RowNumber],[ColumnNumber]',''
		,'[QuestionId],[QuestionType],[ColumnHeading],[Answer1]',1,1
		,'Select [Id],[ApplicationId],[SequenceNumber],[SectionNumber],[PageId],[QuestionId],[QuestionType],Case when len([Answer]) <= 500 then  [Answer] Else NULL End As [Answer1],Case when len([Answer]) > 500 then [Answer] Else NULL End As [Answer2],[ColumnHeading],[RowNumber],[ColumnNumber] FROM [dbo].[SubmittedApplicationAnswers]'
		,'RP_SubmittedApplicationAnswers')
,('Apply','AppealFile','dbo','[Id],[ApplicationId],[CreatedOn]',''
		,'[Filename],[ContentType],[Size],[UserId],[UserName]',0,1
		,'select [Id],[ApplicationId],[Filename],[ContentType],[Size],STUFF([UserId],2,len([UserId])-2,REPLICATE(''''*'''',len([UserId])-2)) As [UserId],STUFF([UserName],2,len([UserName])-2,REPLICATE(''''*'''',len([UserName])-2)) As [UserName],[CreatedOn]  from [dbo].[AppealFile]'
		,'RP_AppealFile')
  /* Assessor Configuration for Certificates,OrganisationStandard,CertificateLogs and  Organisations */

 INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,ModelDataToPL,IsQueryBasedImport,SourceQuery,StagingTableName)
VALUES
   ('Assessor','Certificates','dbo','[Id],[StandardName],[StandardLevel],[StandardPublicationDate],[ContactOrganisation],[LearningStartDate],[AchievementDate],[CourseOption],[OverallGrade],[Department],[ToBePrinted],[CreatedAt],[DeletedAt],[OrganisationId],[BatchNumber],[Status],[UpdatedAt],[StandardCode],[IsPrivatelyFunded],[PrivatelyFundedStatus],[StandardUId],[EPADate]','[ContactAddLine1],[ContactAddLine2],[ContactAddLine3],[ContactAddLine4],[LearnRefNumber],[FullName],[LearnerGivenNames],[LearnerFamilyName],[ContactName]','[ContactPostCode],[Registration],[ProviderName],[StandardReference],[CertificateReference],[ProviderUkPrn],[CertificateReferenceId],[CreateDay],[Uln],[CreatedBy]',0,1
      ,'select [Id],[ToBePrinted],[CreatedAt],[CreatedBy],[DeletedAt],[DeletedBy],[CertificateReference],[OrganisationId],[BatchNumber],[Status],[UpdatedAt],[UpdatedBy],[StandardCode],[ProviderUkPrn],[CertificateReferenceId],[CreateDay],[IsPrivatelyFunded],[PrivatelyFundedStatus],[StandardUId],[uln],STUFF(LearnerGivenNames,2,len(LearnerGivenNames)-2,REPLICATE(''''X'''', len(LearnerGivenNames)-2)) As LearnerGivenNames,STUFF(LearnerFamilyName,2,len(LearnerFamilyName)-2,REPLICATE(''''X'''',len(LearnerFamilyName)-2)) As LearnerFamilyName,StandardName,StandardLevel,StandardPublicationDate,STUFF(ContactName,2,len(ContactName)-2,REPLICATE(''''X'''',len(ContactName)-2)) As ContactName,ContactOrganisation,left(ContactPostCode,len(ContactPostCode)-charindex('''' '''',ContactPostCode)+1) As ContactPostCode,STUFF(Registration,2,len(Registration)-2,REPLICATE(''''X'''',len(Registration)-2)) As Registration,LearningStartDate,AchievementDate,CourseOption,OverallGrade,Department,ProviderName,StandardReference,EPADate FROM (select [Id],[ToBePrinted],[CreatedAt],[CreatedBy],[DeletedAt],[DeletedBy],[CertificateReference],[OrganisationId],[BatchNumber],[Status],[UpdatedAt],[UpdatedBy],[StandardCode],[ProviderUkPrn],[CertificateReferenceId],[CreateDay],[IsPrivatelyFunded],[PrivatelyFundedStatus],[StandardUId],[uln],JSON_VALUE(certificatedata,''''$.LearnerGivenNames'''') LearnerGivenNames,JSON_VALUE(certificatedata,''''$.LearnerFamilyName'''') LearnerFamilyName,JSON_VALUE(certificatedata,''''$.StandardName'''') StandardName,JSON_VALUE(certificatedata,''''$.StandardLevel'''') StandardLevel,JSON_VALUE(certificatedata,''''$.StandardPublicationDate'''') StandardPublicationDate,JSON_VALUE(certificatedata,''''$.ContactName'''') ContactName,JSON_VALUE(certificatedata,''''$.ContactOrganisation'''') ContactOrganisation,JSON_VALUE(certificatedata,''''$.ContactPostCode'''') ContactPostCode,JSON_VALUE(certificatedata,''''$.Registration'''') Registration,JSON_VALUE(certificatedata,''''$.LearningStartDate'''') LearningStartDate,JSON_VALUE(certificatedata,''''$.AchievementDate'''') AchievementDate,JSON_VALUE(certificatedata,''''$.CourseOption'''') CourseOption,JSON_VALUE(certificatedata,''''$.OverallGrade'''') OverallGrade,JSON_VALUE(certificatedata,''''$.Department'''') Department,JSON_VALUE(certificatedata,''''$.FullName'''') FullName,JSON_VALUE(certificatedata,''''$.ProviderName'''') ProviderName,JSON_VALUE(certificatedata,''''$.StandardReference'''') StandardReference,JSON_VALUE(certificatedata,''''$.EpaDetails.LatestEpaDate'''') EPADate  from [dbo].[Certificates]) As Query '
      ,'Assessor_Certificates')
 ,('Assessor','OrganisationStandard','dbo','[Id],[EndPointAssessorOrganisationId],[StandardCode],[EffectiveFrom],[EffectiveTo],[DateStandardApprovedOnRegister],[Status],[ContactId],[DeliveryAreasComments],[StandardReference]','','[Comments]',0,1
      ,'select [Id],[EndPointAssessorOrganisationId],[StandardCode],[EffectiveFrom],[EffectiveTo],[DateStandardApprovedOnRegister],[Comments],[Status],[ContactId],JSON_VALUE(OrganisationStandardData,''''$.DeliveryAreasComments'''') [DeliveryAreasComments],[StandardReference] from [dbo].[OrganisationStandard]'
      ,'Assessor_OrganisationStandard')
 ,('Assessor','CertificateLogs','dbo','[Id],[Action],[CertificateId],[EventTime],[Status],[BatchNumber],[ReasonForChange],[LatestEpaOutcome],[StandardName],[StandardLevel],[StandardPublicationDate],[ContactOrganisation],[Registration],[LearningStartDate],[AchievementDate],[CourseOption],[OverallGrade],[Department]','','[ContactPostCode]',0,1,
	'select [Id],[Action],[CertificateId],[EventTime],[Status],[BatchNumber],[ReasonForChange],[LatestEpaOutcome],[StandardName],[StandardLevel],[StandardPublicationDate],[ContactOrganisation],left(ContactPostCode,len(ContactPostCode)-charindex('''' '''',ContactPostCode)+1) [ContactPostCode],[Registration],[LearningStartDate],[AchievementDate],[CourseOption],[OverallGrade],[Department] FROM ( select [Id],[Action],[CertificateId],[EventTime],[Status],[BatchNumber],[ReasonForChange],[LatestEpaOutcome],JSON_VALUE(CertificateData,''''$.StandardName'''') [StandardName],JSON_VALUE(CertificateData,''''$.StandardLevel'''') [StandardLevel],JSON_VALUE(CertificateData,''''$.StandardPublicationDate'''') [StandardPublicationDate],JSON_VALUE(CertificateData,''''$.ContactOrganisation'''') [ContactOrganisation],JSON_VALUE(CertificateData,''''$.ContactPostCode'''') [ContactPostCode],JSON_VALUE(CertificateData,''''$.Registration'''') [Registration],JSON_VALUE(CertificateData,''''$.LearningStartDate'''') [LearningStartDate],JSON_VALUE(CertificateData,''''$.AchievementDate'''') [AchievementDate],JSON_VALUE(CertificateData,''''$.CourseOption'''') [CourseOption],JSON_VALUE(CertificateData,''''$.OverallGrade'''') [OverallGrade],JSON_VALUE(CertificateData,''''$.Department'''') [Department] from [dbo].[CertificateLogs] ) As Query',
    'Assessor_CertificateLogs')
 ,('Assessor','Organisations','dbo','[Id],[CreatedAt],[DeletedAt],[EndPointAssessorOrganisationId],[Status],[UpdatedAt],[OrganisationTypeId],[ApiEnabled],[ApiUser]','','[EndPointAssessorName],[EndPointAssessorUkprn]',0,1,
    'select [Id],[CreatedAt],[DeletedAt],[EndPointAssessorName],[EndPointAssessorOrganisationId],[EndPointAssessorUkprn],[Status],[UpdatedAt],[OrganisationTypeId],[ApiEnabled],[ApiUser] From [dbo].[Organisations]',
    'Assessor_Organisations')
 ,('Assessor','OrganisationStandardDeliveryArea','dbo','[Id],[OrganisationStandardId],[DeliveryAreaId],[Comments],[Status]','','',0,1,
    'select [Id],[OrganisationStandardId],[DeliveryAreaId],[Comments],[Status] From [dbo].[OrganisationStandardDeliveryArea]',
    'Assessor_OrganisationStandardDeliveryArea')
 ,('Assessor','DeliveryArea','dbo','[Id],[Area],[Ordering],[Status]','','',0,1,
    'select [Id],[Area],[Status],[Ordering] From [dbo].[DeliveryArea]',
    'Assessor_DeliveryArea')
 ,('Assessor','OrganisationStandardVersion','dbo','[StandardUId],[Version],[OrganisationStandardId],[EffectiveFrom],[EffectiveTo],[DateVersionApproved],[Comments],[Status]','','',0,1,
    'Select [StandardUId],[Version],[OrganisationStandardId],[EffectiveFrom],[EffectiveTo],[DateVersionApproved],[Comments],[Status] From [dbo].[OrganisationStandardVersion]',
    'Assessor_OrganisationStandardVersion')
 ,('Assessor','Standards','dbo','[StandardUId],[Title],[Version],[Level],[Status],[TypicalDuration],[MaxFunding],[IsActive],[LastDateStarts],[EffectiveFrom],[EffectiveTo],[VersionEarliestStartDate],[VersionLatestStartDate],[VersionLatestEndDate],[VersionApprovedForDelivery],[ProposedTypicalDuration],[ProposedMaxFunding]','','[IFateReferenceNumber],[LarsCode]',1,1,
    'Select [StandardUId],[IFateReferenceNumber],[LarsCode],[Title],[Version],[Level],[Status],[TypicalDuration],[MaxFunding],[IsActive],[LastDateStarts],[EffectiveFrom],[EffectiveTo],[VersionEarliestStartDate],[VersionLatestStartDate],[VersionLatestEndDate],[VersionApprovedForDelivery],[ProposedTypicalDuration],[ProposedMaxFunding]  From [dbo].[Standards]',
    'Assessor_Standards')
,('Assessor','Apply','dbo','[Id],[ApplicationId],[OrganisationId],[ApplicationStatus],[ReviewStatus],[FinancialReviewStatus],[FinancialDueDate],[StandardCode],[CreatedAt],[UpdatedAt],[DeletedAt],[StandardApplicationType],[StandardReference]','','[SelectedGrade],[GradedBy],[CreatedBy]',0,1,
    'select [Id],[ApplicationId],[OrganisationId],[ApplicationStatus],[ReviewStatus],[FinancialReviewStatus],[SelectedGrade],[FinancialDueDate],[GradedBy],[StandardCode],[CreatedAt],[CreatedBy],[UpdatedAt],[DeletedAt],[StandardApplicationType],[StandardReference] FROM ( Select [Id],[ApplicationId],[OrganisationId],[ApplicationStatus],[ReviewStatus],[FinancialReviewStatus],JSON_VALUE([FinancialGrade],''''$.SelectedGrade'''') SelectedGrade,JSON_VALUE([FinancialGrade],''''$.FinancialDueDate'''') FinancialDueDate,JSON_VALUE([FinancialGrade],''''$.GradedBy'''') GradedBy,[StandardCode],[CreatedAt],[CreatedBy],[UpdatedAt],[DeletedAt],[StandardApplicationType],[StandardReference]  from [dbo].[Apply] ) As a ',
    'Assessor_Apply')

/* Public Sector Config */
INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,ModelDataToPL,IsQueryBasedImport,SourceQuery,StagingTableName)
VALUES
   ('PublicSector','Report','dbo','[DasAccountId],[OrganisationName],[ReportingPeriod],[ID_FullTimeEquivalent],[SummaryText_FullTimeEquivalent],[ZenDeskLabel_FullTimeEquivalent],[YourEmployees_AtStart],[YourEmployees_AtEnd],[YourEmployees_NewThisPeriod],[YourApprentices_AtStart],[YourApprentices_AtEnd],[YourApprentices_NewThisPeriod],[FullTimeEquivalent_atStart],[Questions_OutlineActions_Id],[Questions_OutlineActions_Answer],[Questions_Challenges_Id],[Questions_Challenges_Answer],[Questions_TargetPlans_Id],[Questions_TargetPlans_Answer],[Questions_AnythingElse_Id],[Questions_AnythingElse_Answer],[SubmittedAt]','','[SubmittedName],[SubmittedEmail]',1,1
      ,'Select  DasAccountId,OrganisationName,ReportingPeriod,ID_FullTimeEquivalent,SummaryText_FullTimeEquivalent,ZenDeskLabel_FullTimeEquivalent,YourEmployees_AtStart,YourEmployees_AtEnd,YourEmployees_NewThisPeriod,YourApprentices_AtStart,YourApprentices_AtEnd,YourApprentices_NewThisPeriod,FullTimeEquivalent_atStart,Questions_OutlineActions_Id,Questions_OutlineActions_Answer,Questions_Challenges_Id,Questions_Challenges_Answer,Questions_TargetPlans_Id,Questions_TargetPlans_Answer,Questions_AnythingElse_Id,Questions_AnythingElse_Answer,SubmittedAt,STUFF(SubmittedName,2,len(SubmittedName)-2,REPLICATE(''''*'''', len(SubmittedName)-2)) As SubmittedName,STUFF(SubmittedEmail,2,charindex(''''@'''',SubmittedEmail)-3,REPLICATE(''''*'''',charindex(''''@'''',SubmittedEmail)-3)) As SubmittedEmail FROM (select [EmployerId] As DasAccountId,JSON_VALUE(ReportingData,''''$.OrganisationName'''') As OrganisationName,ReportingPeriod,JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[2].Id'''') As ID_FullTimeEquivalent,JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[2].SummaryText'''') As SummaryText_FullTimeEquivalent,JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[2].ZenDeskLabel'''') As ZenDeskLabel_FullTimeEquivalent,case when JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Id'''') = ''''YourEmployees'''' And JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Questions[0].Id'''') = ''''atStart'''' Then JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Questions[0].Answer'''')  Else NUll End As YourEmployees_AtStart,Case when JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Id'''') = ''''YourEmployees'''' And JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Questions[1].Id'''') = ''''atEnd'''' Then JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Questions[1].Answer'''')  Else NUll End As YourEmployees_AtEnd,Case when JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Id'''') = ''''YourEmployees'''' And JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Questions[2].Id'''') = ''''newThisPeriod'''' Then JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[0].Questions[2].Answer'''')  Else NUll End As YourEmployees_NewThisPeriod,case When JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Id'''') = ''''YourApprentices'''' And JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Questions[0].Id'''') = ''''atStart'''' Then JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Questions[0].Answer'''')  Else NUll End As YourApprentices_AtStart,Case when JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Id'''') = ''''YourApprentices'''' And JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Questions[1].Id'''') = ''''atEnd'''' Then JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Questions[1].Answer'''')  Else NUll End As YourApprentices_AtEnd,Case when JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Id'''') = ''''YourApprentices'''' And JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Questions[2].Id'''') = ''''newThisPeriod'''' Then JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[1].Questions[2].Answer'''')  Else NUll End As YourApprentices_NewThisPeriod,Case when JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[2].Id'''') = ''''FullTimeEquivalent'''' And JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[2].Questions[0].Id'''') = ''''atStart'''' Then JSON_VALUE(ReportingData,''''$.Questions[0].SubSections[2].Questions[0].Answer'''')  Else NUll End As FullTimeEquivalent_atStart,JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[0].Questions[0].Id'''') As Questions_OutlineActions_Id,case when JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[0].Questions[0].Id'''') =''''OutlineActions'''' Then JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[0].Questions[0].Answer'''') Else NULL End As Questions_OutlineActions_Answer,JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[1].Questions[0].Id'''') As Questions_Challenges_Id,Case when JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[1].Questions[0].Id'''') =''''Challenges'''' Then JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[1].Questions[0].Answer'''') Else NULL End As Questions_Challenges_Answer,JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[2].Questions[0].Id'''') As Questions_TargetPlans_Id,Case when JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[2].Questions[0].Id'''') = ''''TargetPlans'''' Then JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[2].Questions[0].Answer'''') Else NULL End As Questions_TargetPlans_Answer,JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[3].Questions[0].Id'''') As Questions_AnythingElse_Id,Case when JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[3].Questions[0].Id'''') = ''''AnythingElse'''' Then JSON_VALUE(ReportingData,''''$.Questions[1].SubSections[3].Questions[0].Answer'''') Else NULL End As Questions_AnythingElse_Answer,JSON_VALUE(ReportingData,''''$.Submitted.SubmittedAt'''') As SubmittedAt,JSON_VALUE(ReportingData,''''$.Submitted.SubmittedName'''') As SubmittedName,JSON_VALUE(ReportingData,''''$.Submitted.SubmittedEmail'''') As SubmittedEmail from [dbo].[Report]) As Reportdata '
      ,'PublicSector_Report')

/* Employer Demand Config */
INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,ModelDataToPL,IsQueryBasedImport,SourceQuery,StagingTableName)
VALUES
   ('EmployerDemand','CourseDemand','dbo','[Id],[OrganisationName],[NumberOfApprentices],[CourseId],[CourseTitle],[CourseLevel],[CourseRoute],[DateCreated],[EmailVerified],[DateEmailVerified],[Stopped],[DateStopped],[ExpiredCourseDemandId],[EntryPoint]','[StopSharingUrl],[StartSharingUrl]','[ContactEmailAddress],[LocationName],[Lat],[Long]',0,1
      ,'select [Id],[ContactEmailAddress],[OrganisationName],[NumberOfApprentices],[CourseId],[CourseTitle],[CourseLevel],[CourseRoute],[LocationName],[Lat],[Long],[DateCreated],[EmailVerified],[DateEmailVerified],[Stopped],[DateStopped],[ExpiredCourseDemandId],[EntryPoint] FROM (SELECT [Id],[ContactEmailAddress],[OrganisationName],[NumberOfApprentices],[CourseId],[CourseTitle],[CourseLevel],[CourseRoute],[LocationName],[Lat],[Long],[DateCreated],[EmailVerified],[DateEmailVerified],[Stopped],[DateStopped],[ExpiredCourseDemandId],[EntryPoint] FROM [dbo].[CourseDemand]) a '
      ,'AED_CourseDemand')

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,PLTableName,[ModelDataToPL])
VALUES
   ('EmployerDemand','CourseDemandNotificationAudit','dbo','[Id],[CourseDemandId],[DateCreated],[NotificationType]','','','AED_CourseDemandNotificationAudit',0)
   ,('EmployerDemand','ProviderInterest','dbo','[Id],[EmployerDemandId],[Website],[DateCreated]','[Phone]','[Email],[Ukprn]','AED_ProviderInterest',0)

/* Provider Apprenticeship Service  Config */
INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,PLTableName,[ModelDataToPL],[FullCopyToPL])
VALUES
('ProviderApprenticeshipService','User','dbo','[Id],[IsDeleted],[UserType],[LastLogin]','','[UserRef],[DisplayName],[Ukprn],[Email]','PAS_User',0,1) 
  
/* E Commitments  Config */

INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,PLTableName,[ModelDataToPL],[FullCopyToPL])
VALUES
 ('AComt','Apprentice','dbo','[Id],[CreatedOn]','[FirstName],[LastName],[Email],[DateOfBirth]','','aComt_Apprentice',0,1) 
,('AComt','Apprenticeship','dbo','[Id],[ApprenticeId],[CreatedOn],[LastViewed]','','','aComt_Apprenticeship',0,1) 
,('AComt','Revision','dbo','[Id],[ApprenticeshipId],[CommitmentsApprenticeshipId],[EmployerAccountLegalEntityId],[EmployerName],[TrainingProviderId],[TrainingProviderName],[CourseName],[CourseLevel],[CourseOption],[PlannedStartDate],[PlannedEndDate],[CommitmentsApprovedOn],[TrainingProviderCorrect],[EmployerCorrect],[RolesAndResponsibilitiesCorrect],[ApprenticeshipDetailsCorrect],[HowApprenticeshipDeliveredCorrect],[ConfirmBefore],[ConfirmedOn],[CourseDuration]','','','aComt_Revision',0,1) 
,('AComt','Registration','dbo','[RegistrationId],[CommitmentsApprenticeshipId],[CommitmentsApprovedOn],[UserIdentityId],[CreatedOn],[FirstViewedOn],[SignUpReminderSentOn],[EmployerAccountLegalEntityId],[EmployerName],[TrainingProviderId],[TrainingProviderName],[CourseName],[CourseLevel],[CourseOption],[PlannedStartDate],[PlannedEndDate],[CourseDuration]','[FirstName],[LastName],[DateOfBirth],[Email]','','aComt_Registration',0,1) 
 
 /* LTM SQL query based Import */
 INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,StagingTableName,PLTableName,[ModelDataToPL],[IsQueryBasedImport],SourceQuery)
VALUES
('LevyTransfer','ApplicationEmailAddress','dbo','[Id],[ApplicationId],[EmailAddress]','','','LTM_ApplicationEmailAddress','LTM_ApplicationEmailAddress',0,1,'Select [Id],[ApplicationId],STUFF([EmailAddress],2,charindex(''''@'''',[EmailAddress])-3,REPLICATE(''''*'''',charindex(''''@'''',[EmailAddress])-3)) As [EmailAddress] From [dbo].[ApplicationEmailAddress]')

/* LTM table based Import */
INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,PLTableName,[ModelDataToPL])
VALUES
 ('LevyTransfer','Application','dbo','[Id],[EmployerAccountId],[PledgeId],[Details],[NumberOfApprentices],[StandardId],[StartDate],[Amount],[HasTrainingProvider],[Sectors],[CreatedOn],[Status],[UpdatedOn]','[PostCode],[FirstName],[LastName],[BusinessWebsite],[RowVersion]','','LTM_Application',0)
,('LevyTransfer','Pledge','dbo','[Id],[EmployerAccountId],[Amount],[RemainingAmount],[IsNamePublic],[CreatedOn],[JobRoles],[Levels],[Sectors]','[RowVersion]','','LTM_Pledge',1)
,('LevyTransfer','PledgeLocation','dbo','[Id],[PledgeId]','','[Name],[Latitude],[Longitude]','LTM_PledgeLocation',0)
,('LevyTransfer','ApplicationStatusHistory','dbo','[Id],[ApplicationId],[CreatedOn],[Status]','','','LTM_ApplicationStatusHistory',0)

/* TPR SQL query based Import */
INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,StagingTableName,PLTableName,[ModelDataToPL],[IsQueryBasedImport],SourceQuery)
VALUES
('TPR','Organisation','dbo','[TPRUniqueId],[CompaniesHouseNumber],[AORN],[EmpRef],[SchemeStartDate],[SchemeEndDate],[SchemeEndDateCodeDesc],[RestartDate],[EmployeeCountDateTaken]','','[OrganisationName],[TradeClass],[TradeClassDescription],[PostCode],[LiveEmployeeCount]','TPR_OrgDetails','TPR_OrgDetails',0,1,'SELECT TOrg.TPRUniqueId,TOrg.OrganisationName,convert(NVarchar(500),HASHBYTES(''''SHA2_512'''',LTRIM(RTRIM(CONCAT(CONVERT(NVARCHAR(512),Torg.CompanyRegNo), @SaltKey)))),2) as CompaniesHouseNumber,TOrg.TradeClass,CASE WHEN left(TOrg.TradeClass,1)=''''S'''' THEN ''''Society Registered'''' WHEN left(TOrg.TradeClass,1)=''''C'''' THEN ''''Limited Company'''' WHEN left(TOrg.TradeClass,1)=''''I'''' THEN ''''Individual Or Sole Trader'''' WHEN left(TOrg.TradeClass,1)=''''P'''' THEN ''''Public Corporation'''' WHEN left(TOrg.TradeClass,1)=''''F'''' THEN ''''Partnership'''' WHEN left(TOrg.TradeClass,1)=''''L'''' THEN ''''Local Authority'''' WHEN left(TOrg.TradeClass,1)=''''E'''' THEN ''''Close Investment Companies'''' ELSE ''''Unknown'''' END as TradeClassDescription,convert(NVarchar(500),HASHBYTES(''''SHA2_512'''',LTRIM(RTRIM(CONCAT(CONVERT(NVARCHAR(512),TOrg.AORN), @SaltKey)))),2) [Aorn],CASE WHEN CHARINDEX('''' '''',toa.Postcode)<>0 THEN SUBSTRING(TOA.PostCode,1,CHARINDEX('''' '''',Postcode)) ELSE SUBSTRING(TOA.Postcode,1,LEN(TOA.Postcode)-3) end as [PostCode],convert(NVarchar(500),HASHBYTES(''''SHA2_512'''',LTRIM(RTRIM(CONCAT(CONVERT(NVARCHAR(512),Tops.PayeScheme), @SaltKey)))),2) [EmpRef],TOPS.SchemeStartDate,TOPS.SchemeEndDate,TOPS.SchemeEndDateCodeDesc,TOPS.RestartDate,TOPS.LiveEmployeeCount,TOPS.EmployeeCountDateTaken FROM Tpr.Organisation TOrg LEFT JOIN Tpr.OrganisationAddress TOA ON Torg.TPRUniqueId=TOA.TprUniqueId LEFT JOIN Tpr.OrganisationPAYEScheme TOPS ON TOPS.TPRUniqueId=TOrg.TPRUniqueId')

/* Forecast */
INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,FullCopyToPL,ModelDataToPL,PLTableName)
VALUES 
 ('Forecast','Balance','dbo','[EmployerAccountId],[Amount],[TransferAllowance],[RemainingTransferBalance],[BalancePeriod],[ReceivedDate],[UnallocatedCompletionPayments]','','',1,0,'Fcast_Balance')
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