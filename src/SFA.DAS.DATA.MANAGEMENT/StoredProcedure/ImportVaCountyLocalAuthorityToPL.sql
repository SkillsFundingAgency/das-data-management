CREATE PROCEDURE [dbo].[ImportVaCountyLocalAuthorityToPL]
(
   @RunId int
)
AS
-- ======================================================================================================================
-- Author:      Narashim Reddy
-- Create Date: 10/11/2022
-- Description: Import County LocalAuthority
-- ======================================================================================================================

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
	   ,'ImportVaCountyLocalAuthorityToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVaCountyLocalAuthorityToPL'
     AND RunId=@RunID


BEGIN TRANSACTION

-- /* Import LocalAuthority to PL */

-- DELETE FROM [ASData_PL].[Va_LocalAuthority]
 
-- INSERT INTO [ASData_PL].[Va_LocalAuthority]
--            ([LocalAuthorityId]
-- 		  ,[CodeName]
-- 		  ,[ShortName]
-- 		  ,[FullName]
-- 		  ,[CountyId]
-- 		   )
-- SELECT    [LocalAuthorityId]
-- 		  ,[CodeName]
-- 		  ,[ShortName]
-- 		  ,[FullName]
-- 		  ,[CountyId]
-- FROM Stg.Avms_LocalAuthority

-- /* Import County to PL */

-- DELETE FROM [ASData_PL].[Va_County]

-- INSERT INTO [ASData_PL].[Va_County]
--            ([CountyId]
--            ,[CodeName]
--            ,[ShortName]
--            ,[FullName]
-- 		   )
-- SELECT [CountyId]
--            ,[CodeName]
--            ,[ShortName]
--            ,[FullName]
-- FROM Stg.Avms_County
  

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
	    'ImportVaCountyLocalAuthorityToPL',
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