CREATE TABLE [AsData_PL].[MarketoPrograms]
(
	ProgramId Bigint 
   ,ProgramName nvarchar(max)
   ,ProgramDescription nvarchar(max)
   ,CreatedAt datetime2
   ,UpdatedAt datetime2
   ,ProgramType nvarchar(max)
   ,Channel nvarchar(max)
   ,EmailType varchar(10)
   ,EmailTypeDescription nvarchar(max)
   ,AudienceType varchar(10)
   ,AudienceTypeDescription nvarchar(max)   
   ,LeadProgramImportStatus BIT DEFAULT(0)
   ,LeadProgramImportDate DateTime2
   ,CampaignDate varchar(20)
   ,CampaignName varchar(256)
   ,CampaignCategory varchar(256)
   ,Additional_Information varchar(100)
   ,High_Level_Campaign Varchar(100)
   ,IsDeletedAtSource BIT DEFAULT(0)
   ,AsDm_CreatedDate Datetime2
   ,AsDm_UpdatedDate datetime2
 ,CONSTRAINT [PK_MP_ProgramId] PRIMARY KEY CLUSTERED([ProgramId] ASC)
)
