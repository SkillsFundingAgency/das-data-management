CREATE TABLE [AsData_PL].[MarketoActivityTypes]
(
  ActivityTypeId bigint
 ,ActivityTypeName nvarchar(255)
 ,ActivityTypeDescription nvarchar(255)
 ,AsDm_CreatedDate Datetime2
 ,AsDm_UpdatedDate datetime2
 ,CONSTRAINT [PK_MAT_ActivityId] PRIMARY KEY CLUSTERED([ActivityTypeId] ASC)
)
