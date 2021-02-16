CREATE TABLE [AsData_PL].[MarketoLeadActivityLinkClicked]
(
	MarketoGUID nvarchar(256)
   ,LeadId bigint
   ,primaryAtttributevalueId BIGINT
   ,primaryAttributeValue nvarchar(1024)
   ,ReferrerURL nvarchar(1024)
   ,Link nvarchar(1024)
   ,QueryParameters nvarchar(1024)
   ,WebpageURL nvarchar(1024)
   ,PrimaryLink nvarchar(1024)
   ,AsDm_CreatedDate Datetime2
   ,AsDm_UpdatedDate datetime2
)
GO
CREATE NONCLUSTERED INDEX [NCI_MALC_LeadId] ON [AsData_PL].[MarketoLeadActivityLinkClicked]([LeadId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MALC_MarketoGUID] ON [AsData_PL].[MarketoLeadActivityLinkClicked]([MarketoGUID] ASC)
GO


