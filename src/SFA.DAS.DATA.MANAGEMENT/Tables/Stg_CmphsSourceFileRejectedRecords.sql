CREATE TABLE [Stg].[Cmphs_SourceFileRejectedRecords]
(
	SFRId BIGINT IDENTITY(1,1) NOT NULL 
   ,ErrorDateTime [datetime2](7) NULL
   ,ErrorName varchar(100)
   ,ErrorRecord nvarchar(max)
   ,ErrorMessage varchar(max)
   ,RunId bigint
   ,SrcFileName varchar(256)
)

