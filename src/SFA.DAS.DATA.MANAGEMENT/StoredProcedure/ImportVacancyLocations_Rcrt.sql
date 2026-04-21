<<<<<<< ASINTEL--5273
CREATE PROCEDURE [dbo].[ImportVacancyLocationsToPL_Rcrt]
=======
﻿CREATE PROCEDURE [dbo].[ImportVacancyLocationsToPL_Rcrt]
>>>>>>> master
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Harish N
-- Create Date: 10/07/2025
-- Description: Import VacancyLocations from RCRT
-- ==========================================================================================================

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
	   ,'ImportVacancyLocationsToPL_Rcrt'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacancyLocationsToPL_Rcrt'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_VacancyLocations_Rcrt

INSERT INTO [ASData_PL].[Va_VacancyLocations_Rcrt]
           (
[VacancyId]
,[EmployerId]
,[VacancyPostcode]
,[VacancyAddressLine1]
,[VacancyAddressLine2] 
,[VacancyAddressLine3] 
,[VacancyAddressLine4] 
,[VacancyTown] 
,[SourceVacancyLocationsId] 
,[SourceDb]

        )
SELECT
       VV.VacancyId
      ,E.EmployerId
      ,EPA.Postcode
      ,EPA.AddressLine1
      ,EPA.AddressLine2
      ,EPA.AddressLine3
      ,EPA.AddressLine4
      ,COALESCE(EPA.AddressLine4,EPA.AddressLine3,EPA.AddressLine2)
      ,CAST(EPA.Id as varchar(256))
      ,'RCRT'
  FROM (
        SELECT DISTINCT
               VacancyReference
              ,AccountId
              ,AccountLegalEntityId
          FROM Stg.RCRT_Vacancy
       ) V
  LEFT
  JOIN Stg.RCRT_EmployerProfileAddress EPA
    ON EPA.AccountLegalEntityId=V.AccountLegalEntityId
  LEFT
  JOIN ASData_PL.Va_Employer_Rcrt E
    ON E.DasAccountId_v2=V.AccountId
   AND E.SourceDb='RCRT'
  LEFT
<<<<<<< ASINTEL--5273
  JOIN ASData_PL.Va_Vacancy VV
=======
  JOIN ASData_PL.Va_Vacancy_Rcrt VV
>>>>>>> master
    ON VV.VacancyReferenceNumber=TRY_CAST(V.VacancyReference as bigint)
 WHERE COALESCE(EPA.Postcode
               ,EPA.AddressLine1
               ,EPA.AddressLine2
               ,EPA.AddressLine3
               ,EPA.AddressLine4
               ,'NA')<>'NA'

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
	    'ImportVacancyLocationsToPL_Rcrt',
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

<<<<<<< ASINTEL--5273
GO
=======
GO
>>>>>>> master
