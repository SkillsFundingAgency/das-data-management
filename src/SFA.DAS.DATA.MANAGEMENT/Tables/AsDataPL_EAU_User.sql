CREATE TABLE [AsData_PL].[EAU_User]
(    
       Id nvarchar(max)
      ,IsActive bit
      ,IsLocked bit
      ,Email varchar(255) MASKED WITH (FUNCTION = 'Email()')
      ,FirstName varchar(255) MASKED WITH (FUNCTION = 'default()')
      ,LastName varchar(255) MASKED WITH (FUNCTION = 'default()')
      ,FailedLoginAttempts int 
	  ,[Asdm_UpdatedDateTime] datetime2 default getdate()
 )