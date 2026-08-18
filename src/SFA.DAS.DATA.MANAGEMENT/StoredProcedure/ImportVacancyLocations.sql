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
      ,d.Postcode as VacancyPostCode
	  CASE WHEN len(d.Postcode)>8 
            THEN CASE WHEN Mgmt.fn_ExtractPostCodeUKFromAddress(d.Postcode)='ZZ99 9ZZ'
                  THEN CASE WHEN Mgmt.fn_ExtractPostCodeUKFromAddress(ISNULL(d.AddressLine1,'')+','+ISNULL(d.AddressLine2,'')+','+ISNULL(d.AddressLine3,'')+','+ISNULL(d.AddressLine4,'')) ='ZZ99 9ZZ'
                        THEN d.Postcode
                  ELSE Mgmt.fn_ExtractPostCodeUKFromAddress(ISNULL(d.AddressLine1,'')+','+ISNULL(d.AddressLine2,'')+','+ISNULL(d.AddressLine3,'')+','+ISNULL(d.AddressLine4,''))
                 END
              ELSE Mgmt.fn_ExtractPostCodeUKFromAddress(d.Postcode)
			END
        ELSE EmployerPostCode
      END                                                          as VacancyPostCode
      ,d.AddressLine1 as VacancyAddressLine1
      ,d.AddressLine2 as VacancyAddressLine2
      ,d.AddressLine3 as VacancyAddressLine3
      ,d.AddressLine4 as VacancyAddressLine4
      ,COALESCE(d.AddressLine4, d.AddressLine3, d.AddressLine2) as VacancyTown
      ,V.SourceVacancyReference
      ,'RCRT' as SourceDb
FROM Stg.RCRT_Vacancy V

CROSS APPLY OPENJSON(V.EmployerLocations)
WITH
(
    AddressLine1 NVARCHAR(100) '$.addressLine1',
    AddressLine2 NVARCHAR(100) '$.addressLine2',
    AddressLine3 NVARCHAR(100) '$.addressLine3',
    AddressLine4 NVARCHAR(100) '$.addressLine4',
    Postcode     NVARCHAR(50)  '$.postcode'
) d

LEFT JOIN ASData_PL.Va_Employer E
    ON E.DasAccountId_v2 = V.AccountId
   AND E.SourceDb = 'RCRT'

LEFT JOIN ASData_PL.Va_Vacancy VV
    ON VV.VacancyReferenceNumber =
       TRY_CAST(V.SourceVacancyReference AS bigint)

WHERE ISJSON(V.EmployerLocations) = 1
  AND COALESCE(
        d.Postcode,
        d.AddressLine1,
        d.AddressLine2,
        d.AddressLine3,
        d.AddressLine4,
        'NA'
      ) <> 'NA'
)a
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
