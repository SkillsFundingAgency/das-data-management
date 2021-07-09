CREATE TABLE [Stg].[SpendControlNonLevy_v2]
(
 EmployerAccountId bigint NULL
,DasAccountId nvarchar(100) NULL
,DasAccountName nvarchar(100) NULL
,LegalEntityName nvarchar(100) NULL
,AccountLegalEntityCreatedDate datetime NULL
,ReservationId varchar(255) NULL
,ReservationIsLevyAccount varchar(3) NOT NULL
,ReservationCreatedDate datetime NULL
,ReservationStartDate datetime NULL
,ReservationExpiryDate datetime NULL
,ReservationStatus varchar(9) NOT NULL
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
,ApprenticeshipAgreementStatus varchar(255) NULL
,ApprenticeshipPaymentStatus varchar(50) NULL
,PaymentId varchar(255) NULL
,PaymentPeriodEnd varchar(25) NULL
,PaymentFundingSource varchar(255) NULL
,PaymentTransactionType varchar(255) NULL
,PaymentApprenticeshipId bigint NULL
,PaymentAmount decimal(15,5) NULL
)


