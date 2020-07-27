CREATE PROCEDURE [dbo].[LoadCandidateConfig]
(
   @RunId int
)
AS

-- =======================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 27/07/2020
-- Description: Load Candidate Config for Import
-- =======================================================

BEGIN TRY

    SET NOCOUNT ON

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
	   ,'Step-3'
	   ,'LoadCandidateConfig'
	   ,getdate()
	   ,0

   SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='LoadCandidateConfig'
     AND RunId=@RunID


IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION
DELETE FROM dbo.CandidateConfig


/* RAAv2 */

INSERT INTO Stg.CandidateConfig
(SourceDb,Category,ShortCode)
VALUES
('RAAv1','Ethnicity',0),
('RAAv1','Ethnicity',1),
('RAAv1','Ethnicity',2),
('RAAv1','Ethnicity',3),
('RAAv1','Ethnicity',4),
('RAAv1','Ethnicity',5),
('RAAv1','Ethnicity',6),
('RAAv1','Ethnicity',7),
('RAAv1','Ethnicity',8),
('RAAv1','Ethnicity',9),
('RAAv1','Ethnicity',10),
('RAAv1','Ethnicity',11),
('RAAv1','Ethnicity',12),
('RAAv1','Ethnicity',13),
('RAAv1','Ethnicity',14),
('RAAv1','Ethnicity',15),
('RAAv1','Ethnicity',16),
('RAAv1','Ethnicity',17),
('RAAv1','Ethnicity',18),
('RAAv1','Ethnicity',19),
('RAAv1','Ethnicity',20),
('RAAv1','Ethnicity',21)





COMMIT TRANSACTION
END

/* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
	    'LoadCandidateConfig',
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
