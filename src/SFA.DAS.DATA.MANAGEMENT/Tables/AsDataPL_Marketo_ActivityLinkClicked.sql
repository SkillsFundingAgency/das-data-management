CREATE TABLE [AsData_PL].[MarketoLeadActivityLinkClicked]
(
	MarketoGUID nvarchar(256)
   ,LeadId bigint
   ,primaryAtttributevalueId BIGINT
   ,primaryAttributeValue nvarchar(2048)
   ,ReferrerURL nvarchar(6000)
   ,Link nvarchar(6000)
   ,QueryParameters nvarchar(6000)
   ,WebpageURL nvarchar(6000)
   ,PrimaryLink nvarchar(2048)
   ,AsDm_CreatedDate Datetime2
   ,AsDm_UpdatedDate datetime2
)
GO
CREATE NONCLUSTERED INDEX [NCI_MALC_LeadId] ON [AsData_PL].[MarketoLeadActivityLinkClicked]([LeadId] ASC)
GO
CREATE NONCLUSTERED INDEX [NCI_MALC_MarketoGUID] ON [AsData_PL].[MarketoLeadActivityLinkClicked]([MarketoGUID] ASC)
GO


