CREATE PROCEDURE [dbo].[InsertLogMarketoDates]
(
   @LogId BIGINT
  ,@StartDate DATETIME2
  ,@EndDate DATETIME2
)
AS

BEGIN TRY

    SET NOCOUNT ON

  INSERT INTO Mgmt.Log_Marketo_Dates
	  (
	   LogId
	  ,StartDate
	  ,EndDate	 
	  )
  SELECT       
	    @LogId
	   ,@StartDate 
	   ,@EndDate ; 

   END TRY
BEGIN CATCH

SELECT  SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    ERROR_MESSAGE()
END CATCH