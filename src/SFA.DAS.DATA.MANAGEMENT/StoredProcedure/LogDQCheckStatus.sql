CREATE PROCEDURE [dbo].[LogDQCheckStatus]
(
   @RunId BIGINT,
   @DQCheckName VARCHAR(250),
   @DQCheckStatus BIT,
   @DQErrorDetails VARCHAR(MAX)
)
AS
BEGIN TRY

INSERT INTO [Mgmt].[DQ_Checks]
(
RunId,
DQCheckName,
DQCheckStatus,
DQErrorDetails
)
SELECT
@RunId,
@DQCheckName,
@DQCheckStatus,
@DQErrorDetails
END TRY

BEGIN CATCH

  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'LogDQCheckStatus' AS ErrorProcedure,
	    ERROR_MESSAGE(),
	    GETDATE()
		;

END CATCH
GO