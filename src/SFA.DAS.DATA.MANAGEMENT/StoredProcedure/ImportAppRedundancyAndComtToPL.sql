CREATE PROCEDURE [dbo].[ImportAppRedundancyAndComtToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/09/2020
-- Description: Import, Transform and Load Apprenticeship Redundancy and Commitments Presentation Layer Table
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
	   ,'ImportAppRedundancyAndComtToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportAppRedundancyAndComtToPL'
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
      ,[Age]
	  ,[Ethnicity]
	  ,[EthnicitySubgroup]
	  ,[EthnicityText]
	  ,[Gender]
	  ,[GenderText]
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
	  ,CASE WHEN [AR].[DateOfBirth] IS NULL	THEN - 1
		    WHEN DATEPART([M], [AR].[DateOfBirth]) > DATEPART([M], getdate())
			  OR DATEPART([M], [AR].[DateOfBirth]) = DATEPART([M], getdate())
			 AND DATEPART([DD],[AR].[DateOfBirth]) > DATEPART([DD], getdate())
			THEN DATEDIFF(YEAR,[AR].[DateOfBirth], getdate()) - 1
		    ELSE DATEDIFF(YEAR,[AR].[DateOfBirth], getdate())
		END                                 as Age
	  ,AR.[Ethnicity]
	  ,AR.[EthnicitySubgroup]
	  ,AR.[EthnicityText]
	  ,AR.[Gender]
	  ,AR.[GenderText]
  FROM (SELECT *, row_number() over(partition by DateOfBirth,Email order by ID) RN
          FROM Stg.AR_Apprentice) AR
  LEFT
  JOIN Stg.Comt_Apprenticeship CA
    ON CA.FirstName=AR.FirstName
   AND CA.LastName=AR.LastName
   AND CONVERT(DATE,CA.DateOfBirth)=CONVERT(DATE,substring(AR.DateOfBirth,1,10))
 WHERE AR.RN=1
 '

 EXEC SP_EXECUTESQL @VSQL1

 /* Drop Staging Table as it's no longer required */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'AR_Apprentice' AND TABLE_SCHEMA=N'Stg') 
DROP TABLE [Stg].AR_Apprentice

/* Import Apprenticeship Redundancy Employer Data */


DELETE FROM ASData_PL.AR_Employer  

DECLARE @VSQL2 NVARCHAR(MAX)

SET @VSQL2='

INSERT INTO ASData_PL.AR_Employer
(
      [RedundancyEmployerId]
	  ,[OrganisationName] 
      ,[Email] 
	  ,[ContactableForFeedback] 
	  ,[Locations] 
	  ,[Sectors] 
	  ,[ApprenticeshipMoreDetails] 
      ,[CreatedOn] 
	  ,[ContactFirstName] 
      ,[ContactLastName] 
	  )
SELECT AE.[Id]
	  ,AE.[OrganisationName] 
      ,AE.[Email] 
	  ,AE.[ContactableForFeedback] 
	  ,AE.[Locations] 
	  ,AE.[Sectors] 
	  ,AE.[ApprenticeshipMoreDetails] 
      ,AE.[CreatedOn] 
	  ,AE.[ContactFirstName] 
      ,AE.[ContactLastName] 
  FROM Stg.AR_Employer AE
 '

 EXEC SP_EXECUTESQL @VSQL2

  /* Drop Staging Table as it's no longer required */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'AR_Employer' AND TABLE_SCHEMA=N'Stg') 
DROP TABLE [Stg].AR_Employer

 /* Import Commitments Apprenticeship to PL */

 DELETE FROM [ASData_PL].[Comt_Apprenticeship]

 DECLARE @VSQL3 NVARCHAR(MAX)

SET @VSQL3='
 
INSERT INTO [ASData_PL].[Comt_Apprenticeship]
           ([Id]
           ,[CommitmentId]
           ,[ULN]
           ,[TrainingType]
           ,[TrainingCode]
           ,[TrainingName]
           ,[TrainingCourseVersion]
           ,[TrainingCourseVersionConfirmed]
           ,[TrainingCourseOption]
           ,[StandardUId]
           ,[Cost]
           ,[StartDate]
           ,[EndDate]
           ,[AgreementStatus]
           ,[PaymentStatus]
           ,[DateOfBirth]
           ,[CreatedOn]
           ,[AgreedOn]
           ,[PaymentOrder]
           ,[StopDate]
           ,[PauseDate]
           ,[HasHadDataLockSuccess]
           ,[PendingUpdateOriginator]
           ,[EPAOrgId]
           ,[CloneOf]
           ,[ReservationId]
           ,[IsApproved]
           ,[CompletionDate]
           ,[ContinuationOfId]
           ,[MadeRedundant]
           ,[OriginalStartDate]
           ,[Age]
           ,[DeliveryModel]
           )
 SELECT    [Id]
           ,[CommitmentId]
           ,[ULN]
           ,[TrainingType]
           ,[TrainingCode]
           ,[TrainingName]
           ,[TrainingCourseVersion]
           ,[TrainingCourseVersionConfirmed]
           ,[TrainingCourseOption]
           ,[StandardUId]
           ,[Cost]
           ,[StartDate]
           ,[EndDate]
           ,[AgreementStatus]
           ,[PaymentStatus]
           ,[DateOfBirth]
           ,[CreatedOn]
           ,[AgreedOn]
           ,[PaymentOrder]
           ,[StopDate]
           ,[PauseDate]
           ,[HasHadDataLockSuccess]
           ,[PendingUpdateOriginator]
           ,[EPAOrgId]
           ,[CloneOf]
           ,[ReservationId]
           ,[IsApproved]
           ,[CompletionDate]
           ,[ContinuationOfId]
           ,[MadeRedundant]
           ,[OriginalStartDate]
           ,DATEDIFF(hour,DateOfBirth,GETDATE())/8766 as Age
           ,[DeliveryModel]
    FROM Stg.Comt_Apprenticeship
'

EXEC SP_EXECUTESQL @VSQL3

  /* Drop Staging Table as it's no longer required */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_Apprenticeship' AND TABLE_SCHEMA=N'Stg') 
DROP TABLE [Stg].Comt_Apprenticeship


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

	/* Drop Staging Table even if it fails */

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'Comt_Apprenticeship' AND TABLE_SCHEMA=N'Stg') 
    DROP TABLE [Stg].Comt_Apprenticeship

	
     /* Drop Staging Table even if it fails */

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = N'AR_Apprentice' AND TABLE_SCHEMA=N'Stg') 
     DROP TABLE [Stg].AR_Apprentice

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
	    'ImportAppRedundancyAndComtToPL',
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
