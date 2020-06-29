CREATE TABLE [AsData_PL].[Va_Provider]
(
	[ProviderID] int PRIMARY KEY 
      ,[UPIN] int
      ,[UKPRN] int
      ,[FullName] nvarchar(255)
      ,[TradingName] nvarchar(255)
      ,[IsContracted] bit
      ,[ContractedFrom] datetime
      ,[ContractedTo] datetime
	  ,[ProviderStatusTypeID] INT
	  ,[ProviderStatusTypeDesc] varchar(100)
      ,[IsNASProvider] bit
      ,[OriginalUPIN] int
      ,[ProviderToUseFAA] int
)
