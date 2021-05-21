CREATE PROCEDURE [dbo].[SaltKeyLogging]
(
   @RunId int,
   @SourceType Varchar(50)
)
AS
-- ===========================================================================
-- Author:      Sarma EVani
-- Create Date: 27/07/2020
-- Description: SaltKey Logging
-- ===========================================================================
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
		   ,'Step-4'
		   ,'SaltKeyLogging'
		   ,getdate()
		   ,0

		SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		WHERE StoredProcedureName='SaltKeyLogging'
		AND RunId=@RunID
		
		Declare @SaltKeyID BigInt = replace(replace(replace(replace(convert(Nvarchar(25), current_timestamp, 121),'-',''),':',''),'.',''),' ','')				
		insert into Mgmt.SaltKeyLog(SaltKeyID,SourceType) Values (@SaltKeyID,@SourceType)

		-- DELETE FROM AsData_PL.SaltKeyLog Where SourceType = @SourceType and SaltKeyID != @SaltKeyID    -- Remove Delete as would need history
							
		 UPDATE Mgmt.Log_Execution_Results
		   SET Execution_Status=1
			  ,EndDateTime=getdate()
			  ,FullJobStatus='Pending'
		 WHERE LogId=@LogID
		   AND RunId=@RunId

 
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
			'SaltKeyLogging',
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