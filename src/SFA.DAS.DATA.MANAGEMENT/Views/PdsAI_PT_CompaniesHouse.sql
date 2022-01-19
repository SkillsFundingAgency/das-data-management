CREATE VIEW [Pds_AI].[PT_I]
	AS 
	SELECT [CompanyNumber]  AS I1
      ,[CompanyCategory]    As I2
      ,[CompanyStatus]      As I3
      ,[SICCodeSicText_1]   As I4   
  FROM [ASData_PL].[Cmphs_CompaniesHouseData]

