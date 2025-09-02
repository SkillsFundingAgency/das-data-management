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

DELETE FROM ASData_PL.Va_VacancyLocations

/* Load RAAv1 */

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
		  CASE WHEN len(EmployerPostCode)>8 
		        THEN CASE WHEN Mgmt.fn_ExtractPostCodeUKFromAddress(EmployerPostCode)='ZZ99 9ZZ'
				          THEN CASE WHEN Mgmt.fn_ExtractPostCodeUKFromAddress(ISNULL(EmployerAddressLine1,'')+','+ISNULL(EmployerAddressLine2,'')+','+ISNULL(EmployerAddressLine3,'')+','+ISNULL(EmployerAddressLine4,'')) ='ZZ99 9ZZ'
						            THEN EmployerPostCode
									ELSE Mgmt.fn_ExtractPostCodeUKFromAddress(ISNULL(EmployerAddressLine1,'')+','+ISNULL(EmployerAddressLine2,'')+','+ISNULL(EmployerAddressLine3,'')+','+ISNULL(EmployerAddressLine4,''))
							   END
						  ELSE Mgmt.fn_ExtractPostCodeUKFromAddress(EmployerPostCode)
					  END
				ELSE EmployerPostCode
			END                                                          as VacancyPostCode
          ,EmployerAddressLine1                                    as VacancyAddressLine1
          ,EmployerAddressLine2                                    as VacancyAddressLine2
          ,EmployerAddressLine3                                    as VacancyAddressLine3
          ,EmployerAddressLine4                                    as VacancyAddressLine4
          ,COALESCE(EmployerAddressLine4,EmployerAddressLine3,EmployerAddressLine2) as VacancyTown
          ,E.EmployerId                                            as EmployerId
          ,V.VacancyId                                             as VacancyId
          ,EL.SourseSK                                                as SourceVacancyLocationsId
          ,'RAAv2'                                                    as SourceDb
	 FROM Stg.[RAA_EmployerLocations] EL
	  LEFT
	  JOIN ASData_PL.Va_Employer E
	    ON E.DasAccountId_v2=EL.EmployerAccountId
	   and E.SourceDb='RAAv2'

	  LEFT JOIN [ASData_PL].[Va_Vacancy] V ON EL.BinaryId=V.VacancyGuid
	  and V.SourceDb='RAAv2'
	 

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
,'RAAv2'                                                    as SourceDb

from ASData_PL.Va_Vacancy where SourceDb='RAAv2'
 AND COALESCE( VacancyPostCode
,VacancyAddressLine1
,VacancyAddressLine2
,VacancyAddressLine3
,VacancyAddressLine4
,VacancyTown,'NA')<>'NA'

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