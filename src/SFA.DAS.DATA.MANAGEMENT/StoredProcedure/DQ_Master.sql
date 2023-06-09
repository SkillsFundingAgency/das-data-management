CREATE PROCEDURE [dbo].[DQ_Master]
(
   @RunId int
)
AS
BEGIN TRY
/* Master DQ Proc used to orchestrate individual DQ Checks 
Finally looks for the number of failed DQ Checks and returns the value*/
EXEC dbo.DQ_CheckEmptyPLTables @RunId;
EXEC dbo.DQ_CheckSaltKeyMatch @RunId;
EXEC [dbo].[DQ_CheckDateBasedMarketoImportStatus] @RunId;

Select Count(*) as FailCount FROm mgmt.DQ_Checks where RunId = @RunId and DQCheckStatus = 0;

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
	    'DQ_Master',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId; 

  END CATCH

GO