CREATE TABLE [AsData_PL].[MarketoLeadActivities]
(
	MarketoGUID nvarchar(256)
   ,LeadId bigint
   ,ActivityDate datetime2
   ,ActivityTypeId bigint
   ,CampaignId bigint
   ,AsDm_CreatedDate Datetime2
   ,AsDm_UpdatedDate datetime2
   ,IsRetentionApplied bit DEFAULT (0)
   ,RetentionAppliedDate  DateTime2(7)
)
GO
CREATE NONCLUSTERED INDEX [NCI_MA_LeadId] ON [AsData_PL].[MarketoLeadActivities]([LeadId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MA_ActivityTypeId] ON [AsData_PL].[MarketoLeadActivities](ActivityTypeId ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MA_CampaignId] ON [AsData_PL].[MarketoLeadActivities](CampaignId ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MA_MarketoGUID] ON [AsData_PL].[MarketoLeadActivities](MarketoGUID ASC)
GO

