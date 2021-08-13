CREATE TABLE [AsData_PL].[MarketoLeadPrograms]
(
 LeadProgramId bigint
,FirstName nvarchar(255)
,LastName nvarchar(255)
,EmailAddress nvarchar(255)
,MemberDate datetime2
,ProgramId bigint
,ProgramName nvarchar(255)
,ProgramTypeId bigint
,LeadId bigint
,Status nvarchar(255)
,StatusId nvarchar(255)
,LeadProgramCreatedAt datetime2
,LeadProgramUpdatedAt datetime2
,AsDm_CreatedDate Datetime2
,AsDm_UpdatedDate datetime2
,IsRetentionApplied bit DEFAULT (0)
,RetentionAppliedDate  DateTime2(7)
)
go
CREATE NONCLUSTERED INDEX [NCI_MLP_LeadId] ON [AsData_PL].[MarketoLeadPrograms]([LeadId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MLP_ProgramId] ON [AsData_PL].[MarketoLeadPrograms]([ProgramId] ASC)
GO