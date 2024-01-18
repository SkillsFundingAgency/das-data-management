CREATE TABLE [ASData_PL].[LTM_Audit]
(	
   ID bigint
  ,EntityType nvarchar(256)
  ,EntityId bigint
  ,UserId nvarchar(256)
  ,UserAction nvarchar(256)
  ,AuditDate datetime2
  ,CorrelationId UNIQUEIDENTIFIER
 
  ,[AsDm_UpdatedDateTime] datetime2 default getdate()
) ON [PRIMARY]
