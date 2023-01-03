CREATE TABLE [ASData_PL].[Appfb_Attribute]
(
	[AttributeId] [int] NULL,
	[AttributeName] [nvarchar](100) NULL,
	[AsDm_UpdatedDateTime] datetime2 default getdate(),
	[Category] [nvarchar](100) NULL,
	[AttributeType] [nvarchar](100) NULL,
	[Ordering] [int] NULL
)