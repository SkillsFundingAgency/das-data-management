CREATE TABLE [AsData_PL].[Acc_User]
(    
       Id             BigInt Not Null
      ,UserRef        UniqueIdentifier not null
      ,Email          nvarchar(255) 
      ,FirstName      nvarchar(255) 
      ,LastName       nvarchar(255) 
      ,CorrelationId  nvarchar(255) 
      ,[IsRetentionApplied] bit DEFAULT (0)
      ,[RetentionAppliedDate]  DateTime2(7)
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
 )