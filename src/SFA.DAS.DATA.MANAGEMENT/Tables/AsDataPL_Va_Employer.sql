CREATE TABLE [AsData_PL].[Va_Employer]
(
	   [EmployerId] int Primary Key
      ,[EdsUrn_V1] int
	  ,EmployerAccountId_V2 varchar(100)
	  ,LegalEntityId_V2 INT
      ,[FullName] nvarchar(255)
      ,[TradingName] nvarchar(255)
      ,[CountyId] int
      ,[PostCode] nvarchar(8)
      ,[LocalAuthorityId] int
      ,[OwnerOrgnistaion] varchar(255)
	  ,[EmployerStatusTypeId_V1] Int
	  ,[EmployerStatusTypeDesc_V1] varchar(100)
)
