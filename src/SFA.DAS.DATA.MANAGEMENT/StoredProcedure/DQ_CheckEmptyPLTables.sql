﻿CREATE PROCEDURE [dbo].[DQ_CheckEmptyPLTables]
(
   @RunId int
)
AS
BEGIN TRY
/*Check to makr sure there are no empty AsDataPL tables*/
Declare @EmptyTables VARCHAR(max);
Declare @Status BIT = 0;

WITH CTE as
(
select sch.name + '.' + tab.name as [table]
   from sys.tables tab
        inner join sys.partitions part
            on tab.object_id = part.object_id
		inner join sys.schemas sch
			on sch.schema_id = tab.schema_id
where part.index_id IN (1, 0) -- 0 - table without PK, 1 table with PK
and sch.name = 'AsData_PL'
and not exists 
(
select * from Mgmt.DQ_TablesToExclude Exclude where Exclude.SchemaName = Sch.name and Exclude.TableName = tab.name
)
group by sch.name + '.' + tab.name
having sum(part.rows) = 0
)
select @EmptyTables = STRING_AGG([table], ', ') from CTE;

SELECT @Status = CASE WHEN @EmptyTables IS NULL THEN 1 ELSE 0 END;

EXEC [dbo].[LogDQCheckStatus] @RunId, 'CheckEmptyPLTables', @Status, @EmptyTables;

END TRY
BEGIN CATCH    

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
	    'DQ_CheckEmptyPLTables',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  END CATCH

GO