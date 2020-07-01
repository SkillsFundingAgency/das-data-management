CREATE TABLE [AsData_PL].[Va_Provider]
(
	[ProviderID] int PRIMARY KEY 
      ,[UPIN_v1] int
      ,[UKPRN] int
      ,[FullName] nvarchar(255)
      ,[TradingName] nvarchar(255)
      ,[IsContracted_v1] bit
      ,[ContractedFrom_v1] datetime
      ,[ContractedTo_v1] datetime
	  ,[ProviderStatusTypeID] INT
	  ,[ProviderStatusTypeDesc] varchar(100)
      ,[IsNASProvider_v1] bit
      ,[ProviderToUseFAA_v1] int
)
