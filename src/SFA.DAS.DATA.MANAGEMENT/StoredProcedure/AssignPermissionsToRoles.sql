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

/* Create Role If not Already Exists */
DECLARE @RoleName varchar(25)
DECLARE @VSQL NVARCHAR(MAX)
DECLARE @ObjectName varchar(255)
DECLARE @ObjectType varchar(10)
DECLARE @SchemaName varchar(25)
DECLARE @IsSchemaLevelAccess bit

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
	EXEC @VSQL
   FETCH NEXT FROM Roles_Cursor INTO @RoleName;
   END;
CLOSE Roles_Cursor;
DEALLOCATE Roles_Cursor;


/* Assign Permissions to Each Role */

DECLARE Permissions_Cursor CURSOR FOR
SELECT distinct ObjectName, ObjectType, RoleName, SchemaName, IsSchemaLevelAccess
FROM Mtd.RolesAndPermissions
WHERE IsEnabled=1;

OPEN Permissions_Cursor;
FETCH NEXT FROM Permissions_Cursor INTO @ObjectName,@ObjectType,@RoleName, @SchemaName,@IsSchemaLevelAccess;

WHILE @@FETCH_STATUS = 0
   BEGIN
   IF @IsSchemaLevelAccess=1
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME='''+@SchemaName+''')
                BEGIN
                GRANT SELECT ON SCHEMA :: '+@SchemaName+ ' TO '+@RoleName+'
				END
				'
   EXEC @VSQL
   END
   IF @IsSchemaLevelAccess=0 AND @ObjectType='View'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME='''+@ObjectName+''' AND TABLE_SCHEMA = '''+@SchemaName+''')
                BEGIN
                GRANT SELECT ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC @VSQL
   End
   IF @IsSchemaLevelAccess=0 AND @ObjectType='Table'
   BEGIN
   SET @VSQL='  IF EXISTS(SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME='''+@ObjectName+''' AND TABLE_SCHEMA = '''+@SchemaName+''')
                BEGIN
                GRANT SELECT ON '+@schemaname+'.'+@ObjectName+' To '+@RoleName+'
			    END
			 '
   EXEC @VSQL
   End
   FETCH NEXT FROM Permissions_Cursor INTO @ObjectName,@ObjectType,@RoleName, @SchemaName,@IsSchemaLevelAccess;
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