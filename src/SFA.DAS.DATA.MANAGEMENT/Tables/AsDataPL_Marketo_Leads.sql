﻿CREATE TABLE [AsData_PL].[MarketoLeads]
(
 LeadId bigint
,FirstName nvarchar(255)
,LastName nvarchar(255)
,EmailAddress nvarchar(255)
,LeadCreatedAt datetime2
,LeadUpdatedAt datetime2
,EmployerHashedId  nvarchar(3000)
,ProviderId  nvarchar(3000) NULL
,AsDm_CreatedDate Datetime2
,AsDm_UpdatedDate datetime2
,IsRetentionApplied bit DEFAULT (0)
,RetentionAppliedDate  DateTime2(7)
,CONSTRAINT [PK_MLS_LeadId] PRIMARY KEY CLUSTERED([LeadId] ASC)
)
go