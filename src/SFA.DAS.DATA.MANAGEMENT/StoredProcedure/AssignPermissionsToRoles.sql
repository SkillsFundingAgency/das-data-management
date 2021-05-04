CREATE PROCEDURE [dbo].[AssignPermissionsToRoles]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 26/04/2021
-- Description: Assign Permissions To Roles
-- =========================================================================
*/

BEGIN TRY


DECLARE @LogID int

/* Start Logging Execution */

  INSERT INTO Mgmt.Log_Execution_Results
	  (
	    RunId
	   ,StepNo
	   ,StoredProcedureName
	   ,StartDateTime
	   ,Execution_Status
	  )
  SELECT 
        @RunId
	   ,'Step-3'
	   ,'AssignPermissionsToRoles'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='AssignPermissionsToRoles'
     AND RunId=@RunID

BEGIN TRANSACTION

DECLARE @RoleName varchar(25)
DECLARE @VSQL NVARCHAR(MAX)
DECLARE @ObjectName varchar(255)
DECLARE @ObjectType varchar(10)
DECLARE @SchemaName varchar(25)
DECLARE @IsSchemaLevelAccess bit
DECLARE @PermissionType varchar(25)

/* Revoke Existing Permissions on a Role before Re-assigning */

IF OBJECT_ID('tempdb..#tRandP') IS NOT NULL
DROP TABLE #tRandP   

CREATE TABLE #tRandP (RoleName varchar(25),PermissionType varchar(50),ObjectType varchar(50),SchemaName varchar(25), ObjectName varchar(256))

INSERT INTO #tRandP
(RoleName,PermissionType,ObjectType,SchemaName,ObjectName)
SELECT DISTINCT rp.name,
                pm.permission_name,
				ObjectType = CASE
                               WHEN obj.type_desc IS NULL
                                     OR obj.type_desc = 'SYSTEM_TABLE' THEN
                               pm.class_desc
                               ELSE obj.type_desc
                             END,
                s.Name as SchemaName,
                [ObjectName] = Isnull(ss.name, Object_name(pm.major_id))
FROM   sys.database_principals rp
       INNER JOIN sys.database_permissions pm
               ON pm.grantee_principal_id = rp.principal_id
       LEFT JOIN sys.schemas ss
              ON pm.major_id = ss.schema_id
       LEFT JOIN sys.all_objects obj
              ON pm.[major_id] = obj.[object_id]
       LEFT JOIN sys.schemas s
              ON s.schema_id = obj.schema_id
WHERE  rp.type_desc = 'DATABASE_ROLE'
       AND pm.class_desc <> 'DATABASE'
	   and  rp.name<>'public'

/* Revoke Permissions on Each Role before Re-assign */

DECLARE Permissions_Cursor CURSOR FOR
SELECT distinct ObjectName, ObjectType, RoleName, SchemaName, PermissionType
FROM #tRandP

OPEN Permissions_Cursor;
FETCH NEXT FROM Permissions_Cursor INTO @ObjectName,@ObjectType,@RoleName, @SchemaName ,@PermissionType;

WHILE @@FETCH_STATUS = 0
   BEGIN
   IF @ObjectType='SCHEMA'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME='''+@ObjectName+''')
                BEGIN
                REVOKE '+@PermissionType+' ON SCHEMA :: '+@ObjectName+ ' TO '+@RoleName+'
				END
				'
   EXEC sp_executesql @VSQL
   END
   IF @ObjectType='VIEW'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='''+@ObjectName+''' AND TABLE_SCHEMA = '''+@SchemaName+''')
                BEGIN
                REVOKE '+@PermissionType+' ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC sp_executesql @VSQL
   End
   IF @ObjectType='USER_TABLE'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='''+@ObjectName+''' AND TABLE_SCHEMA = '''+@SchemaName+''')
                BEGIN
                REVOKE '+@PermissionType+' ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC sp_executesql @VSQL
   End
   IF @SchemaName='sys' and @ObjectType<>'SCHEMA'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from sys.all_objects where name ='''+@ObjectName+''')
                BEGIN
                REVOKE '+@PermissionType+' ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC sp_executesql @VSQL
   End

   FETCH NEXT FROM Permissions_Cursor INTO @ObjectName,@ObjectType,@RoleName, @SchemaName,@PermissionType;
   END;
CLOSE Permissions_Cursor;
DEALLOCATE Permissions_Cursor;




/* Create Role If not Already Exists */

DECLARE Roles_Cursor CURSOR FOR
SELECT distinct RoleName
FROM Mtd.RolesAndPermissions;

OPEN Roles_Cursor;
FETCH NEXT FROM Roles_Cursor INTO @RoleName;

WHILE @@FETCH_STATUS = 0
   BEGIN
   SET @VSQL='
      IF DATABASE_PRINCIPAL_ID('''+@RoleName+''') IS NULL
      BEGIN
	   CREATE ROLE ['+@RoleName+']
      END'
	EXEC sp_executesql @VSQL
   FETCH NEXT FROM Roles_Cursor INTO @RoleName;
   END;
CLOSE Roles_Cursor;
DEALLOCATE Roles_Cursor;


/* Assign Permissions to Each Role */

DECLARE Permissions_Cursor CURSOR FOR
SELECT distinct ObjectName, ObjectType, RoleName, SchemaName, IsSchemaLevelAccess, PermissionType
FROM Mtd.RolesAndPermissions
WHERE IsEnabled=1;

OPEN Permissions_Cursor;
FETCH NEXT FROM Permissions_Cursor INTO @ObjectName,@ObjectType,@RoleName, @SchemaName,@IsSchemaLevelAccess,@PermissionType;

WHILE @@FETCH_STATUS = 0
   BEGIN
   IF @IsSchemaLevelAccess=1
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME='''+@SchemaName+''')
                BEGIN
                GRANT '+@PermissionType+' ON SCHEMA :: '+@SchemaName+ ' TO '+@RoleName+'
				END
				'
   EXEC sp_executesql @VSQL
   END
   IF @IsSchemaLevelAccess=0 AND @ObjectType='View'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='''+@ObjectName+''' AND TABLE_SCHEMA = '''+@SchemaName+''')
                BEGIN
                GRANT '+@PermissionType+' ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC sp_executesql @VSQL
   End
   IF @IsSchemaLevelAccess=0 AND @ObjectType='Table'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='''+@ObjectName+''' AND TABLE_SCHEMA = '''+@SchemaName+''')
                BEGIN
                GRANT '+@PermissionType+' ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC sp_executesql @VSQL
   End
   IF @SchemaName='sys'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from sys.all_objects where name ='''+@ObjectName+''')
                BEGIN
                GRANT '+@PermissionType+' ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC sp_executesql @VSQL
   End
   FETCH NEXT FROM Permissions_Cursor INTO @ObjectName,@ObjectType,@RoleName, @SchemaName,@IsSchemaLevelAccess,@PermissionType;
   END;
CLOSE Permissions_Cursor;
DEALLOCATE Permissions_Cursor;




COMMIT TRANSACTION


UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunId=@RunId

 
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION;

    DECLARE @ErrorId int

  INSERT INTO Mgmt.Log_Error_Details
	  (UserName
	  ,ErrorNumber
	  ,ErrorState
	  ,ErrorSeverity
	  ,ErrorLine
	  ,ErrorProcedure
	  ,ErrorMessage
	  ,ErrorDateTime
	  ,RunId
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'AssignPermissionsToRoles',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  SELECT @ErrorId=MAX(ErrorId) FROM Mgmt.Log_Error_Details

/* Update Log Execution Results as Fail if there is an Error*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=0
      ,EndDateTime=getdate()
	  ,ErrorId=@ErrorId
 WHERE LogId=@LogID
   AND RunID=@RunId

  END CATCH

GO