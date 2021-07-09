CREATE TABLE [Stg].[SpendControl_v2]
(
 EmployerAccountId bigint NULL
,DasAccountId nvarchar NULL
,DasAccountName nvarchar NULL
,AccountCreatedDate datetime NULL
,AccountModifiedDate datetime NULL
,AccountApprenticeshipEmployerType int NULL
,DasLegalEntityId bigint NULL
,LegalEntityName nvarchar NULL
,AccountLegalEntityCreatedDate datetime NULL
,AccountSignedAgreementVersion int NULL
,AccountLegalEntityIsDeleted varchar NOT NULL
,AccountLegalEntityDeletedDate datetime NULL
,EmployerSignedAgreementId bigint NULL
,AgreementSignedDate datetime NULL
,AgreementSignedByUserId bigint NULL
,ReservationId varchar NULL
,ReservationIsLevyAccount varchar NOT NULL
,ReservationCreatedDate datetime NULL
,ReservationStartDate datetime NULL
,ReservationExpiryDate datetime NULL
,ReservationStatus varchar NOT NULL
,ReservationCourseId varchar NULL
,CourseTitle varchar NULL
,CourseLevel int NULL
,ApprenticeshipCommitmentId bigint NULL
,ApprenticeshipId bigint NULL
,ApprenticeshipCreatedOn datetime NULL
,ApprenticeshipStartDate datetime NULL
,ApprenticeshipTrainingType int NULL
,ApprenticeshipTrainingName nvarchar NULL
,ApprenticeshipTrainingCode nvarchar NULL
,ApprenticeshipIsApproved int NULL
,ApprenticeshipAgreedOn datetime NULL
,ApprenticeshipAgreedCost decimal NULL
,ReservationByEmployerOrProvider int NULL
,CommitmentProviderId bigint NULL
,CommitmentProviderName nvarchar NULL
,CommitmentAgeAtStart int NULL
,CommitmentAgeAtStartBand varchar NOT NULL
,ApprenticeshipAgreementStatus varchar NULL
,ApprenticeshipPaymentStatus varchar NULL
,ApprenticeshipEmployerTypeOnApproval int NULL
,CommitmentTransferSenderId bigint NULL
,PaymentId varchar NULL
,PaymentPeriodEnd varchar NULL
,PaymentFundingSource varchar NULL
,PaymentTransactionType varchar NULL
,PaymentApprenticeshipId bigint NULL
,PaymentAmount decimal NULL
)
