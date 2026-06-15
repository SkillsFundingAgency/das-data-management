CREATE TABLE [ASData_PL].[FAT_ROATPV2_Standard]
(
	  [StandardUId]             varchar(20)         NOT NULL,
      [LarsCode]                nvarchar(10)        NULL,
      [IfateReferenceNumber]    varchar(10)         NULL,
      [Level]                   int                 NULL,
      [Title]                   varchar(1000)       NULL,
      [ApprovalBody]            varchar(1000)       NULL,
      [IsRegulatedForProvider]  bit                 NULL,
      [Duration]                int                 NULL,
      [DurationUnits]           varchar(6)          NULL,
      [Route]                   varchar(500)        NULL,
      [ApprenticeshipType]      varchar(50)         NULL,
      [CourseType]              nvarchar(50)        NULL,
      [IsActiveAvailable]       bit                 NULL,
      [SectorSubjectArea]       varchar(1000)       NULL,
      [SectorSubjectAreaTier1]  int                 NULL,
      [AsDm_UpdatedDateTime] [datetime2](7)		DEFAULT (getdate())
)
