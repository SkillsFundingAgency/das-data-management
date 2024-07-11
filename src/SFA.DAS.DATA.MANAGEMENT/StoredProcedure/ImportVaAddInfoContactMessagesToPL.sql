CREATE PROCEDURE [dbo].[ImportVaAddInfoContactMessagesToPL]
(
   @RunId int
)
AS

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

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
	   ,'ImportVaAddInfoContactMessagesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoContactMessagesToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_ContactMessages

INSERT INTO ASData_PL.Va_ContactMessages
(      CreatedDateTime 
      ,UpdatedDateTime 
      ,UserId  
      ,Enquiry 
	  ,SourceContactMessagesId 
      ,SourceDb 
	  ,Candidate_ID
      ,Status
      ,ContactMethod
      ,PreferenceID

)
SELECT dbo.Fn_ConvertTimeStampToDateTime(CM.DateCreatedTimeStamp)      as DateCreatedTimeStamp
	  ,dbo.Fn_ConvertTimeStampToDateTime(CM.DateUpdatedTimeStamp)      as DateUpdatedTimeStamp
	  ,CM.UserId                                                       as UserId
	  ,CM.Enquiry                                                      as Enquiry
	  ,CM.BinaryId                                                     as SourceContactMessageId
	  ,'RAAv2'                                                         as SourceDb
	  ,NULL                                                            as Candidate_ID
	  ,NULL                                                            as Status
	  ,NULL                                                            as ContactMethod
	  ,NULL                                                            as PreferenceID
FROM Stg.FAA_ContactMessages CM
UNION
SELECT Cp.CreatedOn    as DateCreatedTimeStamp
	  ,Cp.UpdatedOn    as DateUpdatedTimeStamp
	  ,'N/A'                                                as UserId
	  ,'N/A'                                                as Enquiry
	  ,'N/A'                                                as SourceContactMessageId
	  ,'FAAV2'                                              as SourceDb
	  ,CAST(cp.CandidateID AS UNIQUEIDENTIFIER)             as Candidate_id
	  ,cp.Status											as status
	  ,cp.ContactMethod										as ContactMethod
	  ,cp.PreferenceID										as PreferenceID
FROM Stg.FAAV2_CandidatePreferences cp
INNER JOIN  stg.FAAV2_Candidate c ON C.Id= cp.CandidateID


COMMIT TRANSACTION

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
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
	    'ImportVaAddInfoContactMessagesToPL',
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
