CREATE TABLE [AsData_PL].[EAU_User]
(    
       Id nvarchar(256)
      ,IsActive bit
      ,IsLocked bit
      ,Email varchar(255) 
      ,FirstName varchar(255) 
      ,LastName varchar(255) 
      ,FailedLoginAttempts int 
      ,IsSuspended bit not null
      ,[IsRetentionApplied] bit DEFAULT (0)
      ,[RetentionAppliedDate]  DateTime2(7)
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
      ,CONSTRAINT PK_EAU_User_Id PRIMARY KEY CLUSTERED (Id)
 )