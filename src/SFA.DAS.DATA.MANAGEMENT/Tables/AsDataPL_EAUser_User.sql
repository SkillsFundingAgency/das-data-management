CREATE TABLE [AsData_PL].[EAUser_User]
(    
       Id nvarchar(max)
      ,IsActive bit
      ,IsLocked bit
      ,Email varchar(255)
      ,FirstName varchar(255)
      ,LastName varchar(255)
      ,FailedLoginAttempts int 
	  ,UpdatedDate datetime2 default getdate()
 )