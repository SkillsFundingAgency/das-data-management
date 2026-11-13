CREATE TABLE [AsData_PL].[RiskAssessmentTool_Incentive_PAYE]
(    
    -- PAYE Variables
    EmpRef varchar(256) NULL,
    LiveEmployeeCount INT NULL,
    SchemeStartDate DATE NULL,
    AccountId BIGINT NULL,
    PayeRef varchar(256) NULL,
    RemovedDate datetime NULL,
-- Incentive Variables
    IncentiveApplicationApprenticeshipId_RecordId UNIQUEIDENTIFIER NULL,
    IncentiveApplicationId UNIQUEIDENTIFIER NULL,
    ApprenticeshipId BIGINT NULL,
    EmploymentStartDate datetime2(7) NULL,

    IncentiveApplicationId_RecordId UNIQUEIDENTIFIER NULL,
    DateSubmitted DATETIME2 NULL,

    ApprenticeshipIncentiveId_RecordId UNIQUEIDENTIFIER NULL,
    IncentiveApplicationApprenticeshipId UNIQUEIDENTIFIER NULL,

    ApprenticeshipIncentiveId UNIQUEIDENTIFIER NULL,
    PaidDate [datetime2](7) NULL,

    HasHadDataLockSuccess BIT NULL,
    [Asdm_UpdatedDateTime] datetime2 default getdate()
 )