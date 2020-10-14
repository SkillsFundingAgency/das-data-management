CREATE TABLE [Mtd].[MarketoFilterConfigForPrograms]
(
	MFCP_Id INT identity(1,1) NOT NULL
   ,StartDateFilter nvarchar(100)
   ,EndDateFilter nvarchar(100)	
   ,ImportStatus bit default(0)
   ,ImportDate DateTime2
)
