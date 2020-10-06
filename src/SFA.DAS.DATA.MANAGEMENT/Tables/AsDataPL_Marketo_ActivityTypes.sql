CREATE TABLE [AsData_PL].[MarketoActivityTypes]
(
  ActivityTypeId bigint
 ,ActivityTypeName nvarchar(255)
 ,ActivityTypeDescription nvarchar(255)
 ,CONSTRAINT [PK_MAT_ActivityId] PRIMARY KEY CLUSTERED([ActivityTypeId] ASC)
)
