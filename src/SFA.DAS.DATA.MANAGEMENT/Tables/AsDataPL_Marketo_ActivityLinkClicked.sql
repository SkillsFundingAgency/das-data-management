CREATE TABLE [AsData_PL].[MarketoLeadActivityLinkClicked]
(
	MarketoGUID nvarchar(256)
   ,LeadId bigint
   ,primaryAtttributevalueId BIGINT
   ,primaryAttributeValue nvarchar(2048)
   ,ReferrerURL nvarchar(max)
   ,Link nvarchar(max)
   ,QueryParameters nvarchar(max)
   ,WebpageURL nvarchar(4000)
   ,PrimaryLink nvarchar(4000)
   ,IsRetentionApplied bit
   ,RetentionAppliedDate  DateTime2(7)
   ,AsDm_CreatedDate Datetime2
   ,AsDm_UpdatedDate datetime2
)
GO
CREATE NONCLUSTERED INDEX [NCI_MALC_LeadId] ON [AsData_PL].[MarketoLeadActivityLinkClicked]([LeadId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MALC_MarketoGUID] ON [AsData_PL].[MarketoLeadActivityLinkClicked]([MarketoGUID] ASC)
GO


