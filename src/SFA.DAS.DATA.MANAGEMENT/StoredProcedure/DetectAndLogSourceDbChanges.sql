CREATE PROCEDURE [dbo].[DetectAndLogSourceDbChanges]
(@SourceDatabaseName varchar(256),@SourceTableName varchar(256),@SourceSchemaName varchar(256),@Cols varchar(max))
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/06/2020
-- Description: Detect And Log Source Db Changes
-- ==================================================

BEGIN 

    SET NOCOUNT ON



/* Check and Log if there are Any new Columns that don't exist in DataMart and are not part of Include
or Exclude List Config*/

INSERT INTO dbo.SourceDbChanges
 (SourceDatabaseName,SourceTableName,SourceSchemaName,ChangesDetected)
SELECT  
 ''+@SourceDatabaseName+''
 ,''+@SourceTableName+''
 ,''+@SourceSchemaName+''
 ,'Field '+LTRIM(RTRIM(ConfigList))+' Removed'
FROM
(SELECT VALUE as ConfigList
   FROM Mtd.SourceConfigForImport SCFI
  CROSS APPLY string_split(ColumnNamesToInclude,',')
  WHERE SourceDatabaseName=''+@SourceDatabaseName+''
    AND SourceTableName=''+@SourceTableName+''
	AND SourceSchemaName=''+@SourceSchemaName+''
    AND NULLIF(ColumnNamesToInclude,'') is NOT NULL
  UNION
  SELECT VALUE as ConfigList
   FROM Mtd.SourceConfigForImport SCFI
  CROSS APPLY string_split(ColumnNamesToMask,',')
  WHERE SourceDatabaseName=''+@SourceDatabaseName+''
    AND SourceTableName=''+@SourceTableName+''
	AND SourceSchemaName=''+@SourceSchemaName+''
    AND NULLIF(ColumnNamesToMask,'') is NOT NULL
	) AS SourceConfigInDM
  WHERE not exists (select LTRIM(RTRIM(value)) as ExistingList
                      from STRING_SPLIT(@cols, ',') Cols 
				     where LTRIM(RTRIM(SourceConfigInDM.ConfigList))=LTRIM(RTRIM(Cols.value)))
and NULLIF(ConfigList,'') is NOT NULL 
					 
/* Check and Log if there are Deleted Columns that exist in DataMart as part of Include List Config*/


 INSERT INTO dbo.SourceDbChanges
 (SourceDatabaseName,SourceTableName,SourceSchemaName,ChangesDetected)
 SELECT  ''+@SourceDatabaseName+''
        ,''+@SourceTableName+''
		,''+@SourceSchemaName+''
        ,'Field '+LTRIM(RTRIM(value))+' Added' as ExistingList
   FROM STRING_SPLIT(@cols, ',') Cols 
  WHERE NOT EXISTS
        (SELECT 1
		   FROM 
		     (SELECT VALUE as ConfigList
                FROM Mtd.SourceConfigForImport SCFI
               CROSS APPLY string_split(ColumnNamesToInclude,',')
			   WHERE SourceDatabaseName=''+@SourceDatabaseName+''
                 AND SourceTableName=''+@SourceTableName+''
	             AND SourceSchemaName=''+@SourceSchemaName+''
                 AND NULLIF(ColumnNamesToInclude,'') is NOT NULL
               UNION
              SELECT VALUE as ConfigList
                FROM Mtd.SourceConfigForImport SCFI
               CROSS APPLY string_split(ColumnNamesToExclude,',')
			   WHERE SourceDatabaseName=''+@SourceDatabaseName+''
                 AND SourceTableName=''+@SourceTableName+''
	             AND SourceSchemaName=''+@SourceSchemaName+''
                 AND NULLIF(ColumnNamesToExclude,'') is NOT NULL
			   UNION
			  SELECT VALUE as ConfigList
                FROM Mtd.SourceConfigForImport SCFI
               CROSS APPLY string_split(ColumnNamesToMask,',')
               WHERE SourceDatabaseName=''+@SourceDatabaseName+''
                 AND SourceTableName=''+@SourceTableName+''
	            AND SourceSchemaName=''+@SourceSchemaName+''
                AND NULLIF(ColumnNamesToMask,'') is NOT NULL
                ) AS SourceConfigInDM
               WHERE LTRIM(RTRIM(SourceConfigInDM.ConfigList))=LTRIM(RTRIM(Value))
			)
and NULLIF(value,'') is NOT NULL 

 
     
 




 END 
 GO
