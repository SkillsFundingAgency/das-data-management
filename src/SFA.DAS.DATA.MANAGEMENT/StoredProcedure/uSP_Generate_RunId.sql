
CREATE PROCEDURE [dbo].[uSP_Generate_RunId]
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 29/05/2019
-- Description: Generates RunId which will be used for logging Execution
-- =========================================================================
BEGIN TRY

/* Generate Run Id by inserting startdatetime into Log_RunId */

INSERT INTO [Mgmt].[Log_RunId]
(StartDateTime)
Values(GETDATE())

RETURN (SELECT MAX(Run_Id) FROM [Mgmt].[Log_RunId])

END TRY

BEGIN CATCH

  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'dbo.uSP_Generate_RunId' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE()
		;


/* Update Log Execution Results as Fail if there is an Error*/

END CATCH
GO


