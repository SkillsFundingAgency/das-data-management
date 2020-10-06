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
 ,CONSTRAINT [PK_MP_ProgramId] PRIMARY KEY CLUSTERED([ProgramId] ASC)
)
