CREATE PROCEDURE [dbo].[ImportFaaFeedbackToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 01/10/2020
-- Description: Import Faa Feedback to PL on demand - static otherwise
-- ==========================================================================================================

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
	   ,'Step-6'
	   ,'ImportFaaFeedbackToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportFaaFeedbackToPL'
     AND RunId=@RunID

/* Import Vacancy Feedback to PL */

BEGIN TRANSACTION

-- TRUNCATE TABLE ASData_PL.Va_FaaFeedback

-- INSERT INTO ASData_PL.Va_FaaFeedback
-- (      CreatedDateTime 
--       ,UserId  
-- 	  ,TypeCode
--       ,Enquiry 
-- 	  ,Feedback
-- 	  ,SourceFeedbackId 
--       ,SourceDb 
-- )
-- SELECT dbo.Fn_ConvertTimeStampToDateTime(DateCreatedTimeStamp)      as DateCreatedTimeStamp
-- 	  ,UserId                                                       as UserId
-- 	  ,TypeCode                                                     as TypeCode
-- 	  ,Enquiry                                                      as Enquiry
-- 	  ,Details                                                      as Feedback
-- 	  ,BinaryId                                                     as SourceFeedbackId
-- 	  ,'FAA'                                                           as SourceDb
--   FROM Stg.FAA_Feedback 

  

COMMIT TRANSACTION



UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Finish'
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
	    'ImportFaaFeedbackToPL',
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
