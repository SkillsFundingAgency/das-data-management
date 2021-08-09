CREATE TABLE [AsData_PL].[MarketoLeads]
(
 LeadId bigint
,FirstName nvarchar(255)
,LastName nvarchar(255)
,EmailAddress nvarchar(255)
,LeadCreatedAt datetime2
,LeadUpdatedAt datetime2
,EmployerHashedId  nvarchar(100)
,ProviderId  bigint NULL
,IsRetentionApplied bit
,RetentionAppliedDate  DateTime2(7)
,AsDm_CreatedDate Datetime2
,AsDm_UpdatedDate datetime2
,CONSTRAINT [PK_MLS_LeadId] PRIMARY KEY CLUSTERED([LeadId] ASC)
)
go