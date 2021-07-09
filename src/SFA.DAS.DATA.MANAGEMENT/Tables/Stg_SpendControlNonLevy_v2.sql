CREATE TABLE [Stg].[SpendControlNonLevy_v2]
(
 EmployerAccountId bigint NULL
,DasAccountId nvarchar NULL
,DasAccountName nvarchar NULL
,LegalEntityName nvarchar NULL
,AccountLegalEntityCreatedDate datetime NULL
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
,ApprenticeshipAgreementStatus varchar NULL
,ApprenticeshipPaymentStatus varchar NULL
,PaymentId varchar NULL
,PaymentPeriodEnd varchar NULL
,PaymentFundingSource varchar NULL
,PaymentTransactionType varchar NULL
,PaymentApprenticeshipId bigint NULL
,PaymentAmount decimal NULL
)


