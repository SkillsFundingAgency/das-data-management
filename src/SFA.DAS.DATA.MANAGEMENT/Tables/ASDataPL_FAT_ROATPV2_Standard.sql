CREATE TABLE [ASData_PL].[FAT_ROATPV2_Standard]
(
      [StandardUId]             varchar(20)         NOT NULL,
      [LarsCode]                int                 NULL,
      [IfateReferenceNumber]    varchar(10)         NULL,
      [Level]                   int                 NULL,
      [Title]                   varchar(1000)       NULL,
      [Version]                 varchar(10)         NULL,
      [ApprovalBody]            varchar(1000)       NULL,
      [SectorSubjectArea]       varchar(1000)       NULL,
      [SectorSubjectAreaTier1]  int                 NULL,
      [AsDm_UpdatedDateTime] [datetime2](7)		DEFAULT (getdate())
)
