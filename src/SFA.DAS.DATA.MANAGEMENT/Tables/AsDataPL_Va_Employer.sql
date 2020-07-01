CREATE TABLE [AsData_PL].[Va_Employer]
(
	   [EmployerId] BIGINT IDENTITY(1,1) Primary Key
      ,[SourceEmployerId_v1] INT
	  ,[DasAccountId_v2] varchar(8)
      ,[LocalAuthorityId] int
      ,[OwnerOrgnistaion_v1] varchar(255)
	  ,[EdsUrn_v1] int
	  ,[EmployerStatusTypeId_v1] Int
	  ,[EmployerStatusTypeDesc_v1] varchar(100)
	  ,[SourceDb] varchar(100)
)
