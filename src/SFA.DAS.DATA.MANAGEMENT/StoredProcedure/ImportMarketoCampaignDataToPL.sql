CREATE PROCEDURE [dbo].[ImportMarketoDataToPL]
(
   @RunId int
)
AS

-- ==================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 05/10/2020
-- Description: Import Marketo Campaign Data To Presentation Layer
-- ==================================================================

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
	   ,'Step-6'
	   ,'ImportMarketoData'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportMarketoDataToPL'
     AND RunId=@RunID

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

/* Delta Code */

/* Delta Update MarketoLeads */

 MERGE AsData_PL.MarketoLeads as Target
 USING Stg.MarketoLeads as Source
    ON Target.LeadId=Source.LeadId
  WHEN MATCHED AND ( Target.FirstName<>Source.FirstName
                  OR Target.LastName<>Source.LastName
				  OR Target.EmailAddress<>Source.EmailAddress
				  )
  THEN UPDATE SET Target.FirstName=Source.FirstName
                 ,Target.LastName=Source.LastName
				 ,Target.EmailAddress=Source.EmailAddress
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (FirstName,LastName,EmailAddress) 
       VALUES (Source.FirstName,Source.LastName,Source.EmailAddress);

/* Delta Update Marketo Activities */
 

  MERGE AsData_PL.MarketoLeadActivities as Target
 USING Stg.MarketoLeadActivities as Source
    ON Target.MarketoGUID=Source.MarketoGUID
  WHEN MATCHED AND ( Target.LeadId<>Source.LeadId
                  OR Target.ActivityTypeId<>Source.ActivityTypeId
				  OR Target.CampaignId<>Source.CampaignId
				  )
  THEN UPDATE SET Target.LeadId=Source.Leadd
                 ,Target.CampaignId=Source.CampaignId
				 ,Target.ActivityTypeId=Source.ActivityTypeId
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (MarketoGUID,LeadId,ActivityDate,ActivityTypeId,CampaignId) 
       VALUES (Source.MarketoGUID,Source.LeadId,Source.ActivityDate,Source.ActivityTypeId,Source.CampaignId);


	   
/* Delta Update Marketo LeadPrograms */

 MERGE AsData_PL.MarketoLeadPrograms as Target
 USING Stg.MarketoLeadPrograms as Source
    ON Target.LeadProgramID=Source.ID
  WHEN MATCHED AND ( Target.FirstName<>Source.FirstName
                  OR Target.LastName<>Source.LastName
				  OR Target.EmailAddress<>Source.Email
				  OR Target.ProgramId<>Source.ProgramId
				  OR Target.ProgramName<>Source.Program
				  OR Target.Status<>Source.Status
				  OR Target.ProgramTypeId<>Source.ProgramTypeId
				  OR Target.LeadId<>Source.LeadId
				  OR Target.StatusId<>Source.StatusId
				  )
  THEN UPDATE SET Target.FirstName=Source.FirstName
                 ,Target.LastName=Source.LastName
				 ,Target.EmailAddress=Source.Email
				 ,Target.ProgramId=Source.ProgramId
				 ,Target.ProgramName=Source.Program
				 ,Target.Status=Source.Status
				 ,Target.ProgramTypeId=Source.ProgramTypeId
				 ,Target.LeadId=Source.LeadId
				 ,Target.StatusId=Source.StatusId
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (FirstName,LastName,EmailAddress,MemberDate,ProgramId,ProgramName,ProgramTypeId,LeadId,Status,StatusId) 
       VALUES (Source.FirstName,Source.LastName,Source.Email,Source.MemberDate,Source.ProgramId,Source.Program,Source.ProgramTypeId,Source.LeadId,Source.Status,Source.StatusId);

	   
/* Full Refresh Marketo Activity Type Ids */





COMMIT TRANSACTION
END
 


 /* Update Log Execution Results as Success if the query ran succesfully*/

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
	    'ImportMarketoDataToPL',
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
