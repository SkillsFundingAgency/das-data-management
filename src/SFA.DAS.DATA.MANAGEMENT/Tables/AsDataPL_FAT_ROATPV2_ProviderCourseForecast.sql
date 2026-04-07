CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderCourseForecast]
(
    [Id] bigint NOT NULL,
    [UkPrn] [int] NOT NULL,
    [LarsCode] [varchar](1000) NULL,
    [TimePeriod] [varchar](1000) NULL,
    [Quarter] [Int] NULL,
    [EstimatedLearners] [INT] NULL,
    [Created] [datetime2](7) NULL,
    [Updated] [datetime2](7) NULL,
    [AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())
)
