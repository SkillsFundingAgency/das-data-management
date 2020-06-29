CREATE TABLE [AsData_PL].[Va_Employer]
(
	   [EmployerId] int
      ,[EdsUrn] int
      ,[FullName] nvarchar(255)
      ,[TradingName] nvarchar(255)
      ,[CountyId] int
      ,[PostCode] nvarchar(8)
      ,[LocalAuthorityId] int
      ,[OwnerOrgnistaion] varchar(255)
	  ,[EmployerStatusTypeId] Int
	  ,[EmployerStatusTypeDesc] varchar(100)
      ,[TotalVacanciesPosted] int
      ,[BeingSupportedBy] nvarchar(50)
      ,[LockedForSupportUntil] datetime
	  ,Foreign Key (CountyId) References [AsData_PL].[Va1_County](CountyId)
	  ,Foreign Key (LocalAuthorityId) References [AsData_PL].[Va1_LocalAuthority](LocalAuthorityId)
)
