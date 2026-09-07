CREATE TABLE [ASData_PL].[FAT_ROATPV2_ProviderCourseType]
(
    [Id] int NOT NULL,
    [Ukprn] int NOT NULL,
    [CourseType] nvarchar(50) NOT NULL,
    [AsDm_UpdatedDateTime] [datetime2](7) DEFAULT (getdate())
)
