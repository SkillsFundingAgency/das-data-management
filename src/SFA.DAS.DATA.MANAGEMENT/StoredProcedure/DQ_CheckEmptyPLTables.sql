CREATE PROCEDURE [dbo].[DQ_CheckEmptyPLTables]
(
   @RunId int
)
AS

BEGIN TRY

Declare @EmptyTables VARCHAR(max)

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
group by sch.name + '.' + tab.name
having sum(part.rows) = 0
)
select STRING_AGG([table], ', ') from CTE


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