CREATE TABLE [AsData_PL].[MarketoLeads]
(
 LeadId bigint
,FirstName nvarchar(255)
,LastName nvarchar(255)
,EmailAddress nvarchar(255)
,Unsubscribed bit NULL
,UnsubscribeFeedback nvarchar(8000) NULL
,LeadCreatedAt datetime2
,LeadUpdatedAt datetime2
,EmployerHashedId  varchar(8000)
,ProviderId  varchar(8000) NULL
,AsDm_CreatedDate Datetime2
,AsDm_UpdatedDate datetime2
,IsRetentionApplied bit DEFAULT (0)
,RetentionAppliedDate  DateTime2(7)
,CONSTRAINT [PK_MLS_LeadId] PRIMARY KEY CLUSTERED([LeadId] ASC)
)
go