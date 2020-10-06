CREATE TABLE [AsData_PL].[MarketoLeadActivities]
(
	MarketoGUID nvarchar(256)
   ,LeadId bigint
   ,ActivityDate datetime2
   ,ActivityTypeId bigint
   ,CampaignId bigint
)
GO
CREATE NONCLUSTERED INDEX [NCI_MA_LeadId] ON [AsData_PL].[MarketoLeadActivities]([LeadId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MA_ActivityTypeId] ON [AsData_PL].[MarketoLeadActivities](ActivityTypeId ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MA_CampaignId] ON [AsData_PL].[MarketoLeadActivities](CampaignId ASC)
GO

