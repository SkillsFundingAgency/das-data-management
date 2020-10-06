CREATE PROCEDURE [dbo].[ImportAppRedundancyToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/09/2020
-- Description: Import, Transform and Load Apprenticeship Redundancy Presentation Layer Table
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
	   ,'ImportAppRedundancyToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportAppRedundancyToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM ASData_PL.AR_Apprentice  

DECLARE @VSQL1 NVARCHAR(MAX)

SET @VSQL1='

INSERT INTO ASData_PL.AR_Apprentice
(
       [ApprenticeId]
      ,[ApprenticeshipId]
      ,[UpdatesWanted]
      ,[ContactableForFeedback]
      ,[PreviousTraining]
      ,[Employer]
      ,[TrainingProvider]
      ,[LeftOnApprenticeshipMonths]
      ,[LeftOnApprenticeshipYears]
      ,[Sectors]
      ,[CreatedOn]
      ,[FirstName]
      ,[LastName]
      ,[Email]
      ,[DateOfBirth]
	  )
SELECT AR.[Id]  
	  ,CA.[Id] 
      ,AR.[UpdatesWanted] 
      ,AR.[ContactableForFeedback] 
      ,AR.[PreviousTraining] 
      ,AR.[Employer] 
      ,AR.[TrainingProvider] 
      ,AR.[LeftOnApprenticeshipMonths] 
      ,AR.[LeftOnApprenticeshipYears] 
      ,AR.[Sectors] 
      ,AR.[CreatedOn]
	  ,AR.[FirstName]
      ,AR.[LastName] 
	  ,AR.[Email] 
      ,AR.[DateOfBirth] 
  FROM (SELECT *, row_number() over(partition by DateOfBirth,Email order by ID) RN
          FROM Stg.AR_Apprentice) AR
  LEFT
  JOIN ASData_PL.Comt_Apprenticeship CA
    ON CA.FirstName=AR.FirstName
   AND CA.LastName=AR.LastName
   AND CONVERT(DATE,CA.DateOfBirth)=CONVERT(DATE,substring(AR.DateOfBirth,1,10))
 WHERE AR.RN=1
 '

 EXEC SP_EXECUTESQL @VSQL1

 /* Drop Staging Table as it's no longer required */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'AR_Apprentice' AND TABLE_SCHEMA=N'Stg') 
DROP TABLE [Stg].AR_Apprentice



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
	    'ImportAppRedundancyToPL',
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
