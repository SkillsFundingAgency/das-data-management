CREATE PROCEDURE [dbo].[ImportVaAddInfoSavedSearchesToPL]
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
	   ,'ImportVaAddInfoSavedSearchesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaAddInfoSavedSearchesToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_SavedSearches

INSERT INTO ASData_PL.Va_SavedSearches
(      CandidateId 
      ,CreatedDateTime 
      ,UpdatedDateTime 
	  ,SearchLocation 
	  ,KeyWords 
	  ,WithInDistance 
	  ,ApprenticeshipLevel 
      ,SourceSavedSearchesId 
	  ,SourceDb
)


SELECT vc.CandidateId                                                  as CandidateId
	  ,dbo.Fn_ConvertTimeStampToDateTime(fSS.DateCreatedTimeStamp)      as DateCreatedTimeStamp
	  ,dbo.Fn_ConvertTimeStampToDateTime(fss.DateUpdatedTimeStamp)      as DateUpdatedTimeStamp
	  ,fss.[Location]
	  ,LEFT(fss.Keywords,256) as Keywords
	  ,fss.WithInDistance
	  ,fss.ApprenticeshipLevel
	  ,Fss.BinaryId                                                     as SourceApprenticeshipId
	  ,'RAAv2'                                                         as SourceDb
  FROM Stg.FAA_SavedSearches FSS
  LEFT
  JOIN ASData_PL.Va_Candidate VC
    ON FSS.CandidateId=vc.CandidateGuid
    
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
	    'ImportVaAddInfoSavedSearchesToPL',
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
