CREATE TABLE [AsData_PL].[Va_Provider_Rcrt]
(
	[ProviderID] BIGINT IDENTITY(1,1) PRIMARY KEY 
      ,[UPIN_v1] int
	  ,[SourceProviderID_v1] INT
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
	  ,[SourceDb] Varchar(100)
	  ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
	)
