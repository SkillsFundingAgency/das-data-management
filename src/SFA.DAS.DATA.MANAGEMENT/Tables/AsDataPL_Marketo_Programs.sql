CREATE TABLE [AsData_PL].[MarketoPrograms]
(
	ProgramId Bigint 
   ,ProgramName nvarchar(max)
   ,ProgramDescription nvarchar(max)
   ,CreatedAt datetime2
   ,UpdatedAt datetime2
   ,ProgramType nvarchar(max)
   ,Channel nvarchar(max)
 ,CONSTRAINT [PK_MP_ProgramId] PRIMARY KEY CLUSTERED([ProgramId] ASC)
)
