CREATE TABLE [AsData_PL].[MarketoPrograms]
(
	ProgramId Bigint 
   ,ProgramName nvarchar(max)
   ,ProgramDescription nvarchar(max)
   ,CreatedAt datetime2
   ,UpdatedAt datetime2
   ,ProgramType nvarchar(max)
   ,Channel nvarchar(max)
   ,LeadProgramImportStatus BIT DEFAULT(0)
   ,LeadProgramImportDate DateTime2
   ,CampaignDate varchar(20)
   ,CampaignName varchar(256)
   ,CampaignCategory varchar(256)
   ,CampaignWeekName varchar(100)
   ,TargetAudience Varchar(100)
   ,AsDm_CreatedDate Datetime2
   ,AsDm_UpdatedDate datetime2
 ,CONSTRAINT [PK_MP_ProgramId] PRIMARY KEY CLUSTERED([ProgramId] ASC)
)
