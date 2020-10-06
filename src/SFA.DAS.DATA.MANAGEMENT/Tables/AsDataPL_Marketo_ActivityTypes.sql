CREATE TABLE [AsData_PL].[MarketoActivityTypes]
(
  ActivityId bigint
 ,ActivityName nvarchar(255)
 ,ActivityDescription nvarchar(255)
 ,CONSTRAINT [PK_MAT_ActivityId] PRIMARY KEY CLUSTERED([ActivityId] ASC)
)
