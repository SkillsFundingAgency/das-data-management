CREATE TABLE [AsData_PL].[Acc_User]
(    
       Id             BigInt Not Null
      ,UserRef        UniqueIdentifier not null
      ,Email          nvarchar(255) MASKED WITH (FUNCTION = 'Email()')
      ,FirstName      nvarchar(255) MASKED WITH (FUNCTION = 'default()')
      ,LastName       nvarchar(255) MASKED WITH (FUNCTION = 'default()')
      ,CorrelationId  nvarchar(255) 
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
 )