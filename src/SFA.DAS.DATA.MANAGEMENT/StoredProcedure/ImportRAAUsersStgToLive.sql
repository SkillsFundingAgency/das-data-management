
CREATE PROCEDURE ImportRAAUsersStgToLive
(
   @RunId int
)
AS

-- ============================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 08/04/2020
-- Description: Import RAA Users Stg Tables To Live Tables, Apply Transformations where needed
-- ============================================================================================

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
	   ,'Step-5'
	   ,'ImportRAAUsersStgToLive'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportRAAUsersStgToLive'
     AND RunId=@RunID

  /* Get RAA Users From Staging to Live Tables, Apply Transformation Rules */

   
BEGIN TRANSACTION

DELETE FROM ASData_PL.RAA_Users

INSERT INTO [ASData_PL].[RAA_Users]
           ([BinaryId]
           ,[TypeCode]
           ,[IdamUserId]
           ,[UserType]
           ,[UserName]
           ,[UserEmail]
           ,[UserCreatedTimeStamp]
		   ,UserCreatedDateTime
           ,[LastSignedInTimeStamp]
		   ,LastSignedDateTime
           ,[EmployerAccountId]
           ,[Ukprn]
           ,[RunId]
           ,[AsDm_CreatedDate]
           ,[AsDm_UpdatedDate])
 SELECT  Src.BinaryId
	          ,Src.TypeCode
	          ,Src.IdamUserId
	          ,Src.UserType
	          ,Src.UserName
	          ,Src.UserEmail
	          ,Src.UserCreatedTimeStamp
	          ,dbo.Fn_ConvertTimeStampToDateTime(UserCreatedTimeStamp)
	          ,Src.LastSignedInTimeStamp 
	          ,dbo.Fn_ConvertTimeStampToDateTime(LastSignedInTimeStamp)
			  ,REPLACE(REPLACE(REPLACE(Src.EmployerAccountId,'[',''),']',''),'"','')
	          ,Src.Ukprn
			  ,@RunId
			  ,getdate()
			  ,getdate()
	FROM Stg.RAA_Users Src

COMMIT TRANSACTION


 
 
 
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
	  ,ErrorADFTaskType
	  )
  SELECT 
        SUSER_SNAME(),
	    ERROR_NUMBER(),
	    ERROR_STATE(),
	    ERROR_SEVERITY(),
	    ERROR_LINE(),
	    'ImportRAAUsersStgToLive',
	    ERROR_MESSAGE(),
	    GETDATE(),
		@RunId as RunId,
		'ImportRAAUsersToLive'; 

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
