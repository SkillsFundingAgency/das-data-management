CREATE PROCEDURE [dbo].[GenerateKeys] 
(@RunId bigint,@Key varbinary(4096) OUTPUT)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 27/07/2020
-- Description: Generates Random Keys
-- =========================================================================
BEGIN TRY


DECLARE @SQLCode Nvarchar(255)

SELECT @SQLCode='SELECT @Key= '+SQLCode From Stg.SQLCode Where [Type]='CRG'

EXEC SP_EXECUTESQL @SQLCode, N'@Key Varbinary(4096) OUTPUT',@Key=@Key OUTPUT


RETURN (@Key)

END TRY

BEGIN CATCH

  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'GenerateKeys' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE()
		;


/* Update Log Execution Results as Fail if there is an Error*/

END CATCH
GO


