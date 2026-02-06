CREATE TABLE [AsData_PL].[Va_Employer_Rcrt]
(
	   [EmployerId] BIGINT IDENTITY(1,1) Primary Key
	  ,[FullName] Varchar(256)
      ,[TradingName] Varchar(256)
      ,[SourceEmployerId_v1] INT
	  ,[DasAccountId_v2] BIGINT
      ,[LocalAuthorityId] int
      ,[OwnerOrgnistaion_v1] varchar(255)
	  ,[EdsUrn_v1] int
	  ,[EmployerStatusTypeId_v1] Int
	  ,[EmployerStatusTypeDesc_v1] varchar(100)
	  ,[SourceDb] varchar(100)
	  ,[AsDm_UpdatedDateTime]  [datetime2](7)						DEFAULT (getdate())
)
