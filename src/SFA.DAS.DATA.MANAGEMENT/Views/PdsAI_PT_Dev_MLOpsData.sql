﻿CREATE VIEW [Pds_AI].[Dev_MLOpsData]
AS
SELECT 
    12345 AS ApprenticeshipId,
    67890 AS CommitmentId,
    1 AS Id,
    GETDATE() AS CreatedOn,
    'ABC123' AS ULN,
    'STD001' AS StandardUid,
    '2023-01-01' AS StartDate,
    '2023-12-31' AS EndDate,
    '2023-06-30' AS StopDate,
    '2023-01-15' AS LearnStartDate,
    '2023-11-15' AS PlannedEndDate,
    '2023-12-01' AS LearnActEndDate,
    98765 AS UKPRN,
    'L1SOA' AS DelLoc_Pst_Lower_Layer_SOA,
    2 AS CompletionStatus,
    0 AS IsTransfer,
    789 AS StandardCode,
    1 AS Level,
    1.5 AS SectorSubjectAreaTier1,
    2.3 AS SectorSubjectAreaTier2,
    'SectorDesc1' AS SectorSubjectAreaTier1_Desc,
    'SectorDesc2' AS SectorSubjectAreaTier2_Desc,
    456 AS LARSCODE,
    0 AS FLAG_AGGREGATED_LOWRATING,
    15000.00 AS weighted_average_annual_minwage,
    25000.00 AS weighted_average_annual_maxwage,
    112233 AS ProviderUkprn,
    1234 AS EmployerAccountId,
    'TypeA' AS [Employer type],
    500 AS [Employer sector estimate],
    'Medium' AS Employee_size_estimate,
    GETDATE() AS CURR_STAMP,
    DATEADD(DAY, -1, GETDATE()) AS YESTERDAY,
    DATEADD(DAY, -7, GETDATE()) AS LASTWEEK,
    GETDATE() AS CreatedRecordDate
UNION ALL
SELECT 
    54321 AS ApprenticeshipId,
    98765 AS CommitmentId,
    2 AS Id,
    GETDATE() AS CreatedOn,
    'XYZ789' AS ULN,
    'STD002' AS StandardUid,
    '2024-01-01' AS StartDate,
    '2024-12-31' AS EndDate,
    '2024-06-30' AS StopDate,
    '2024-01-15' AS LearnStartDate,
    '2024-11-15' AS PlannedEndDate,
    '2024-12-01' AS LearnActEndDate,
    54321 AS UKPRN,
    'L2SOA' AS DelLoc_Pst_Lower_Layer_SOA,
    1 AS CompletionStatus,
    1 AS IsTransfer,
    456 AS StandardCode,
    2 AS Level,
    1.8 AS SectorSubjectAreaTier1,
    3.1 AS SectorSubjectAreaTier2,
    'SectorDesc3' AS SectorSubjectAreaTier1_Desc,
    'SectorDesc4' AS SectorSubjectAreaTier2_Desc,
    789 AS LARSCode,
    1 AS FLAG_AGGREGATED_LOWRATING,
    16000.00 AS weighted_average_annual_minwage,
    26000.00 AS weighted_average_annual_maxwage,
    445566 AS ProviderUkprn,
    5678 AS EmployerAccountId,
    'TypeB' AS Employer_type,
    600 AS Employer_sector_estimate,
    'Large' AS Employee_size_estimate,
    GETDATE() AS CURR_STAMP,
    DATEADD(DAY, -1, GETDATE()) AS YESTERDAY,
    DATEADD(DAY, -7, GETDATE()) AS LASTWEEK,
    GETDATE() AS CreatedRecordDate;