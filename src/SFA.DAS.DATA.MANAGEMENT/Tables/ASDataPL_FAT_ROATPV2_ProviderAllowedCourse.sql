CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderAllowedCourse]
(
    [Id] int NOT NULL,
    [Ukprn] int NOT NULL,
    [LarsCode] varchar(20) NOT NULL,
    [AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())
)
