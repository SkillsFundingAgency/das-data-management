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
 ('EmpInc','Accounts','dbo','[Id],[AccountLegalEntityId],[LegalEntityId],[HasSignedIncentivesTerms],[VrfVendorId],[VrfCaseId],[VrfCaseStatus],[VrfCaseStatusLastUpdatedDateTime]','[LegalEntityName]','',1)
,('EmpInc','IncentiveApplication','dbo','[Id],[AccountId],[AccountLegalEntityId],[DateCreated],[Status],[DateSubmitted]','[SubmittedByEmail],[SubmittedByName]','',0)
,('EmpInc','IncentiveApplicationApprenticeship','dbo','[Id],[IncentiveApplicationId],[ApprenticeshipId],[PlannedStartDate],[ApprenticeshipEmployerTypeOnApproval],[TotalIncentiveAmount],[EarningsCalculated]','[FirstName],[LastName],[DateOfBirth],[ULN]','[UKPRN]',0)
,('EmpInc','ApprenticeshipIncentive','incentives','[Id],[AccountId],[ApprenticeshipId],[EmployerType],[IncentiveApplicationApprenticeshipId],[AccountLegalEntityId],[RefreshedLearnerForEarnings],[HasPossibleChangeOfCircumstances],[PausePayments],[StartDate]','[FirstName],[LastName],[DateOfBirth],[ULN],[PlannedStartDate]','[UKPRN]',0)
,('EmpInc','PendingPayment','incentives','[Id],[AccountId],[ApprenticeshipIncentiveId],[DueDate],[Amount],[CalculatedDate],[PaymentMadeDate],[PeriodNumber],[PaymentYear],[AccountLegalEntityId],[EarningType],[ClawedBack]','','',0)
,('EmpInc','CollectionCalendar','incentives','[Id],[PeriodNumber],[CalendarMonth],[CalendarYear],[EIScheduledOpenDateUTC],[CensusDate],[AcademicYear],[Active]','','',0)
,('EmpInc','ApprenticeshipDaysInLearning','incentives','[LearnerId],[NumberOfDaysInLearning],[CollectionPeriodNumber],[CollectionPeriodYear],[CreatedDate],[UpdatedDate]','','',0)
,('EmpInc','Learner','incentives','[Id],[ApprenticeshipIncentiveId],[ApprenticeshipId],[SubmissionFound],[SubmissionDate],[LearningFound],[HasDataLock],[StartDate],[InLearning],[CreatedDate],[UpdatedDate]','','[Ukprn]',0)
,('EmpInc','LearningPeriod','incentives','[LearnerId],[StartDate],[EndDate],[CreatedDate]','','',0)
,('EmpInc','PendingPaymentValidationResult','incentives','[Id],[PendingPaymentId],[Step],[Result],[PeriodNumber],[PaymentYear],[CreatedDateUTC]','','',0)
,('EmpInc','Payment','incentives','[Id],[ApprenticeshipIncentiveId],[PendingPaymentId],[AccountId],[AccountLegalEntityId],[CalculatedDate],[PaidDate],[SubNominalCode],[PaymentPeriod],[PaymentYear],[Amount]','','',0)
,('EmpInc','IncentiveApplicationStatusAudit','dbo','[Id],[IncentiveApplicationApprenticeshipId],[Process],[ServiceRequestTaskId],[ServiceRequestCreatedDate],[CreatedDateTime]','','[ServiceRequestDecisionReference]',0)
,('EmpInc','ClawbackPayment','incentives','[Id],[ApprenticeshipIncentiveId],[PendingPaymentId],[AccountId],[AccountLegalEntityId],[Amount],[DateClawbackCreated],[DateClawbackSent],[CollectionPeriod],[CollectionPeriodYear],[SubNominalCode],[PaymentId]','','',0)

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
,('Commitments','Providers','dbo','[Created],[Updated]','','[Ukprn],[Name]','Comt_Providers',1)
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


/* CRS Delivery Import Configurations */
INSERT INTO Mtd.SourceConfigForImport (SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,FullCopyToPL,ModelDataToPL,PLTableName)
VALUES
('CRSDelivery','NationalAchievementRate','dbo','[Id],[Age],[SectorSubjectArea],[ApprenticeshipLevel],[OverallCohort],[OverallAchievementRate]','','[UkPrn]',1,0,'FAT2_NationalAchievementRate'),
('CRSDelivery','NationalAchievementRateOverall','dbo','[Id],[Age],[SectorSubjectArea],[ApprenticeshipLevel],[OverallCohort],[OverallAchievementRate]','','',1,0,'FAT2_NationalAchievementRateOverall'),
('CRSDelivery','Provider','dbo','[Id],[TradingName],[EmployerSatisfaction],[LearnerSatisfaction]','[Phone],[Website],[MarketingInfo]','[UkPrn],[Name],[Email]',1,1,'Provider'),
('CRSDelivery','ProviderRegistration','dbo','[UkPrn],[StatusDate],[StatusId],[ProviderTypeId],[OrganisationTypeId],[FeedbackTotal],[Postcode],[Lat],[Long]','[Address1],[Address2],[Address3],[Address4],[Town]','[LegalName]',1,0,'FAT2_ProviderRegistration'),
('CRSDelivery','ProviderRegistrationFeedbackAttribute','dbo','[AttributeName],[Weakness],[Strength]','','[UkPrn]',1,0,'FAT2_ProviderRegistrationFeedbackAttribute'),
('CRSDelivery','ProviderRegistrationFeedbackRating','dbo','[FeedbackName],[FeedbackCount]','','[UkPrn]',1,0,'FAT2_ProviderRegistrationFeedbackRating'),
('CRSDelivery','ProviderStandard','dbo','[StandardId],[StandardInfoUrl]','[Phone],[ContactUrl]','[UkPrn],[Email]',1,0,'FAT2_ProviderStandard'),
('CRSDelivery','ProviderStandardLocation','dbo','[StandardId],[LocationId],[DeliveryModes],[Radius],[National]','','[UkPrn]',1,0,'FAT2_ProviderStandardLocation'),
('CRSDelivery','StandardLocation','dbo','[LocationId],[Postcode]','[Phone],[Address1],[Address2],[Town],[County],[Lat],[Long]','[Name],[Email],[Website]',1,0,'FAT2_StandardLocation')


/* CRS Import Configurations */
INSERT INTO Mtd.SourceConfigForImport (SourceDatabaseName,SourceTableName,SourceSchemaName,ColumnNamesToInclude,ColumnNamesToExclude,ColumnNamesToMask,FullCopyToPL,ModelDataToPL,PLTableName)
VALUES
('CRS','ApprenticeshipFunding','dbo','[Id],[StandardUId],[EffectiveFrom],[EffectiveTo],[MaxEmployerLevyCap],[Duration]','','',1,0,'FAT2_ApprenticeshipFunding'),
('CRS','Framework','dbo','[Id],[ProgType],[FrameworkCode],[PathwayCode],[Level],[TypicalLengthFrom],[TypicalLengthTo],[TypicalLengthUnit],[Duration],[CurrentFundingCap],[MaxFunding],[Ssa1],[Ssa2],[EffectiveFrom],[EffectiveTo],[IsActiveFramework],[ProgrammeType],[HasSubGroups],[ExtendedTitle]','','[Title],[FrameworkName],[PathwayName]',1,1,'FAT2_Framework'),
('CRS','FrameworkFundingPeriod','dbo','[Id],[FrameworkId],[EffectiveFrom],[EffectiveTo],[FundingCap]','','',1,0,'FAT2_FrameworkFundingPeriod'),
('CRS','LarsStandard','dbo','[LarsCode],[Version],[EffectiveFrom],[EffectiveTo],[LastDateStarts],[SectorSubjectAreaTier2],[OtherBodyApprovalRequired]','','',1,0,'FAT2_LarsStandard'),
('CRS','Sector','dbo','[Id],[Route]','','',1,1,'FAT2_StandardSector'),
('CRS','SectorSubjectAreaTier2','dbo','[SectorSubjectAreaTier2],[SectorSubjectAreaTier2Desc],[EffectiveFrom],[EffectiveTo]','','[Name]',1,0,'FAT2_SectorSubjectAreaTier2'),
('CRS','Standard','dbo','[StandardUId],[IfateReferenceNumber],[LarsCode],[Status],[EarliestStartDate],[LatestStartDate],[LatestEndDate],[Level],[TypicalDuration],[MaxFunding],[IntegratedDegree],[OverviewOfRole],[RouteCode],[RouteId],[AssessmentPlanUrl],[ApprovedForDelivery],[Keywords],[TypicalJobTitles],[StandardPageUrl],[Version],[RegulatedBody],[Skills],[Knowledge],[Behaviours],[Duties],[CoreAndOptions],[IntegratedApprenticeship],[Options]','','[Title],[TrailBlazerContact],[EqaProviderName],[EqaProviderContactName],[EqaProviderContactEmail],[EqaProviderWebLink]',1,1,'FAT2_StandardSector')



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