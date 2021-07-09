CREATE TABLE [Stg].[SpendControl_v2]
(
 EmployerAccountId bigint NULL
,DasAccountId nvarchar(100) NULL
,DasAccountName nvarchar(100) NULL
,AccountCreatedDate datetime NULL
,AccountModifiedDate datetime NULL
,AccountApprenticeshipEmployerType int NULL
,DasLegalEntityId bigint NULL
,LegalEntityName nvarchar(100) NULL
,AccountLegalEntityCreatedDate datetime NULL
,AccountSignedAgreementVersion int NULL
,AccountLegalEntityIsDeleted varchar(3) NOT NULL
,AccountLegalEntityDeletedDate datetime NULL
,EmployerSignedAgreementId bigint NULL
,AgreementSignedDate datetime NULL
,AgreementSignedByUserId bigint NULL
,ReservationId varchar(255) NULL
,ReservationIsLevyAccount varchar(3) NOT NULL
,ReservationCreatedDate datetime NULL
,ReservationStartDate datetime NULL
,ReservationExpiryDate datetime NULL
,ReservationStatus varchar(12) NOT NULL
,ReservationCourseId varchar(20) NULL
,CourseTitle varchar(500) NULL
,CourseLevel int NULL
,ApprenticeshipCommitmentId bigint NULL
,ApprenticeshipId bigint NULL
,ApprenticeshipCreatedOn datetime NULL
,ApprenticeshipStartDate datetime NULL
,ApprenticeshipTrainingType int NULL
,ApprenticeshipTrainingName nvarchar(126) NULL
,ApprenticeshipTrainingCode nvarchar(20) NULL
,ApprenticeshipIsApproved int NULL
,ApprenticeshipAgreedOn datetime NULL
,ApprenticeshipAgreedCost decimal(18,0) NULL
,ReservationByEmployerOrProvider int NULL
,CommitmentProviderId bigint NULL
,CommitmentProviderName nvarchar(100) NULL
,CommitmentAgeAtStart int NULL
,CommitmentAgeAtStartBand varchar(5) NOT NULL
,ApprenticeshipAgreementStatus varchar(255) NULL
,ApprenticeshipPaymentStatus varchar(50) NULL
,ApprenticeshipEmployerTypeOnApproval int NULL
,CommitmentTransferSenderId bigint NULL
,PaymentId varchar(255) NULL
,PaymentPeriodEnd varchar(25) NULL
,PaymentFundingSource varchar(255) NULL
,PaymentTransactionType varchar(255) NULL
,PaymentApprenticeshipId bigint NULL
,PaymentAmount decimal(15,5) NULL
)
