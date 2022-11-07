﻿CREATE PROCEDURE [dbo].[PopulatePipelineController]
(
   @RunId int
)
AS

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
	   ,'Step-3'
	   ,'PopulatePipelineController'
	   ,getdate()
	   ,0

SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
WHERE StoredProcedureName='PopulatePipelineController'
    AND RunId=@RunID

DELETE FROM [Mgmt].[Pipeline]

INSERT INTO [Mgmt].[Pipeline]
           ([PipelineId],[PipelineName])
     VALUES	
(1	,'Master-ImportAccUsersComtFinResvToDataMart')
,(2	,'ImportUsersToDM')
,(3	,'ImportAccountsToDM')
,(4	,'ImportCommitmentToDM')
,(5	,'ImportFinanceToDM')
,(6	,'ImportReservationToDM')
,(7	,'ImportAppRedundancyToDM')
,(8	,'ImportFAT2CRSDeliveryToDM')
,(9	,'ImportFAT2CRSToDM')
,(10,'ImportApplyToDM')
,(11,'ImportAssessorToDM')
,(12,'ImportPublicSectorToDM')
,(13,'ImportEmpDemandToDM')
,(14,'ImportPasToDM')
,(15,'ImportAppacToDM')
,(16,'ImportECommitmentToDM')
,(17,'ImportLTMToDM')
,(18,'ImportAppfbToDM')
,(19,'ImportRofjaaToDM')


DELETE FROM [Mgmt].[Config_PipelineController]

INSERT INTO [Mgmt].[Config_PipelineController]
([MasterPipelineId],[ChildPipelineId],[IsEnabled],[ExecutionOrder])
VALUES
(1	,2	,1	,2)
,(1	,3	,1	,3)
,(1	,4	,1	,4)
,(1	,5	,1	,5)
,(1	,6	,1	,6)
,(1	,7	,1	,7)
,(1	,8	,1	,8)
,(1	,9	,1	,9)
,(1	,10	,1	,10)
,(1	,11	,1	,11)
,(1	,12	,1	,12)
,(1	,13	,1	,13)
,(1	,14	,1	,14)
,(1	,15	,1	,15)
,(1	,16	,1	,16)
,(1	,17	,1	,17)
,(1	,18	,1	,18)
,(1	,19	,1	,19)

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
	    'PopulatePipelineController',
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