CREATE TABLE [ASData_PL].[Appfb_ProviderAttribute]
(
	[ApprenticeFeedbackResultId] [uniqueidentifier] NULL,
	[AttributeId] [int] NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	[AttributeValue] [int] NULL
)