CREATE PROCEDURE [dbo].[ImportVacancyLocationsToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Harish N
-- Create Date: 10/07/2025
-- Description: Import VacancyLocations from das
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
	   ,'ImportVacancyLocationsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacancyLocationsToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.Va_VacancyLocations

/* Load RCRT */

INSERT INTO [ASData_PL].[Va_VacancyLocations]
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


select 
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
from (

SELECT  
		  VV.VacancyId
      ,E.EmployerId
      ,EPA.Postcode as VacancyPostCode
      ,EPA.AddressLine1 as VacancyAddressLine1
      ,EPA.AddressLine2 as VacancyAddressLine2
      ,EPA.AddressLine3 as VacancyAddressLine3
      ,EPA.AddressLine4 as VacancyAddressLine4
      ,COALESCE(EPA.AddressLine4,EPA.AddressLine3,EPA.AddressLine2) as VacancyTown
      ,CAST(EPA.Id as varchar(256)) as SourceVacancyLocationsId
      ,'RCRT'                                                    as SourceDb
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
	  JOIN ASData_PL.Va_Vacancy VV
	    ON VV.VacancyReferenceNumber=TRY_CAST(V.VacancyReference as bigint)
	 WHERE COALESCE(EPA.Postcode
	               ,EPA.AddressLine1
	               ,EPA.AddressLine2
	               ,EPA.AddressLine3
	               ,EPA.AddressLine4
	               ,'NA')<>'NA'

Union


select 

VacancyPostCode
,VacancyAddressLine1
,VacancyAddressLine2
,VacancyAddressLine3
,VacancyAddressLine4
,VacancyTown
,EmployerId
,VacancyId
,SourceVacancyId as SourceVacancyLocationsId
,'RCRT'                                                    as SourceDb

from (
        SELECT DISTINCT
               V.VacancyId
              ,E.EmployerId
              ,EPA.Postcode as VacancyPostCode
              ,EPA.AddressLine1 as VacancyAddressLine1
              ,EPA.AddressLine2 as VacancyAddressLine2
              ,EPA.AddressLine3 as VacancyAddressLine3
              ,EPA.AddressLine4 as VacancyAddressLine4
              ,COALESCE(EPA.AddressLine4,EPA.AddressLine3,EPA.AddressLine2) as VacancyTown
              ,CAST(EPA.Id as varchar(256)) as SourceVacancyId
              ,'RCRT' as SourceDb
          FROM (
                SELECT DISTINCT
                       VacancyReference
                      ,AccountId
                      ,AccountLegalEntityId
                  FROM Stg.RCRT_Vacancy
               ) VR
          LEFT
          JOIN Stg.RCRT_EmployerProfileAddress EPA
            ON EPA.AccountLegalEntityId=VR.AccountLegalEntityId
          LEFT
          JOIN ASData_PL.Va_Employer_Rcrt E
            ON E.DasAccountId_v2=VR.AccountId
           AND E.SourceDb='RCRT'
          LEFT
          JOIN ASData_PL.Va_Vacancy V
            ON V.VacancyReferenceNumber=TRY_CAST(VR.VacancyReference as bigint)
         WHERE COALESCE(EPA.Postcode
                       ,EPA.AddressLine1
                       ,EPA.AddressLine2
                       ,EPA.AddressLine3
                       ,EPA.AddressLine4
                       ,'NA')<>'NA'
       ) a

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
	    'ImportVacancyLocationsToPL',
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
