CREATE PROCEDURE [dbo].[ImportMarketoBulkExtractTablesToPL]
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
	   ,'ImportMarketoBulkExtractTablesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportMarketoBulkExtractTablesToPL'
     AND RunId=@RunID

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

/* Delta Code */

/* Delta Update MarketoLeads */

MERGE AsData_PL.MarketoLeads as Target
 USING Stg.MarketoLeads as Source
    ON Target.LeadId=TRY_CONVERT(bigint,Source.LeadId)
  WHEN MATCHED AND ( ISNULL(Target.FirstName,'NA')<>ISNULL(CASE WHEN Source.FirstName='NULL' THEN NULL ELSE Source.FirstName END,'NA')
                  OR ISNULL(Target.LastName,'NA')<>ISNULL(CASE WHEN Source.LastName='NULL' THEN NULL ELSE Source.LastName END,'NA')
				  OR ISNULL(Target.EmailAddress,'NA')<>ISNULL(CASE WHEN Source.EmailAddress='NULL' THEN NULL ELSE Source.EmailAddress END,'NA')
				  )
  THEN UPDATE SET Target.FirstName=CASE WHEN Source.FirstName='NULL' THEN NULL ELSE Source.FirstName END
                 ,Target.LastName=CASE WHEN Source.LastName='NULL' THEN NULL ELSE Source.LastName END
				 ,Target.EmailAddress=CASE WHEN Source.EmailAddress='NULL' THEN NULL ELSE Source.EmailAddress END
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (LeadId
              ,FirstName
			  ,LastName
			  ,EmailAddress) 
       VALUES (TRY_CONVERT(bigint,LeadId)
	          ,CASE WHEN Source.FirstName='NULL' THEN NULL ELSE Source.FirstName END
			  ,CASE WHEN Source.LastName='NULL' THEN NULL ELSE Source.LastName END
			  ,CASE WHEN Source.EmailAddress='NULL' THEN NULL ELSE Source.EmailAddress END);

/* Delta Update MarketoLeadActivities */

	   MERGE AsData_PL.MarketoLeadActivities as Target
 USING Stg.MarketoLeadActivities as Source
    ON Target.MarketoGUID=Source.MarketoGUID
  WHEN MATCHED AND ( ISNULL(Target.LeadId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.LeadId='NULL' THEN NULL ELSE Source.LeadId END,'-1'))
                  OR ISNULL(Target.ActivityTypeId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.ActivityTypeId='NULL' THEN NULL ELSE Source.ActivityTypeId END,'-1'))
				  OR ISNULL(Target.CampaignId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.CampaignId='NULL' THEN NULL ELSE Source.CampaignId END,'-1'))
				  )
  THEN UPDATE SET Target.LeadId=TRY_CONVERT(bigint,CASE WHEN Source.LeadId='NULL' THEN NULL ELSE Source.LeadId END)
                 ,Target.CampaignId=TRY_CONVERT(bigint,CASE WHEN Source.CampaignId='NULL' THEN NULL ELSE Source.CampaignId END)
				 ,Target.ActivityTypeId=TRY_CONVERT(bigint,CASE WHEN Source.ActivityTypeId='NULL' THEN NULL ELSE Source.ActivityTypeId END)
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (MarketoGUID
              ,LeadId
			  ,ActivityDate
			  ,ActivityTypeId
			  ,CampaignId) 
       VALUES (Source.MarketoGUID
	          ,TRY_CONVERT(bigint,CASE WHEN Source.LeadId='NULL' THEN NULL ELSE Source.LeadId END)
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.ActivityDate='NULL' THEN NULL WHEN Source.ActivityDate LIKE '%+%' THEN SUBSTRING(Source.ActivityDate,1,CHARINDEX('+',Source.ActivityDate)-1) ELSE Source.ActivityDate END,104)
			  ,CONVERT(bigint,CASE WHEN Source.ActivityTypeId='NULL' THEN NULL ELSE Source.ActivityTypeId END)
			  ,CONVERT(bigint,CASE WHEN Source.CampaignId='NULL' THEN NULL ELSE Source.CampaignId END));


/* Delta Update MarketoLeadPrograms */

	    MERGE AsData_PL.MarketoLeadPrograms as Target
 USING Stg.MarketoLeadPrograms as Source
    ON Target.LeadProgramID=TRY_CONVERT(bigint,Source.ID)
  WHEN MATCHED AND ( ISNULL(Target.FirstName,'NA')<>ISNULL(CASE WHEN Source.FirstName='null' then NULL ELSE Source.FirstName END,'NA')
                  OR ISNULL(Target.LastName,'NA')<>ISNULL(CASE WHEN Source.LastName='null' then NULL ELSE Source.LastName END,'NA')
				  OR ISNULL(Target.EmailAddress,'NA')<>ISNULL(CASE WHEN Source.Email='null' then NULL ELSE Source.Email END,'NA')
				  OR ISNULL(Target.ProgramId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.ProgramId='null' then NULL ELSE Source.ProgramId END,'-1'))
				  OR ISNULL(Target.ProgramName,'NA')<>ISNULL(CASE WHEN Source.Program='null' then NULL ELSE Source.Program END,'NA')
				  OR ISNULL(Target.Status,'NA')<>ISNULL(CASE WHEN Source.Status='null' then NULL ELSE Source.Status END,'NA')
				  OR ISNULL(Target.ProgramTypeId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.ProgramTypeId='null' then NULL ELSE Source.ProgramTypeId END,'-1'))
				  OR ISNULL(Target.LeadId,-1)<>TRY_CONVERT(bigint,ISNULL(CASE WHEN Source.LeadId='null' then NULL ELSE Source.LeadId END,'-1'))
				  OR ISNULL(Target.StatusId,'NA')<>ISNULL(CASE WHEN Source.StatusId='null' then NULL ELSE Source.StatusId END,'NA')
				  )
  THEN UPDATE SET Target.FirstName=CASE WHEN Source.FirstName='null' then NULL ELSE Source.FirstName END
                 ,Target.LastName=CASE WHEN Source.LastName='null' then NULL ELSE Source.LastName END
				 ,Target.EmailAddress=CASE WHEN Source.Email='null' then NULL ELSE Source.Email END
				 ,Target.ProgramId=TRY_CONVERT(bigint,CASE WHEN Source.ProgramId='null' then NULL ELSE Source.ProgramId END)
				 ,Target.ProgramName=CASE WHEN Source.Program='null' then NULL ELSE Source.Program END
				 ,Target.Status=CASE WHEN Source.Status='null' then NULL ELSE Source.Status END
				 ,Target.ProgramTypeId=TRY_CONVERT(bigint,CASE WHEN Source.ProgramTypeId='null' then NULL ELSE Source.ProgramTypeId END)
				 ,Target.LeadId=TRY_CONVERT(bigint,CASE WHEN Source.LeadId='null' then NULL ELSE Source.LeadId END)
				 ,Target.StatusId=CASE WHEN Source.StatusId='null' then NULL ELSE Source.StatusId END
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (LeadProgramId,FirstName,LastName,EmailAddress,MemberDate,ProgramId,ProgramName,ProgramTypeId,LeadId,Status,StatusId) 
       VALUES (TRY_CONVERT(bigint,Source.ID)
	          ,CASE WHEN Source.FirstName='null' then NULL ELSE Source.FirstName END
	          ,CASE WHEN Source.LastName='null' then NULL ELSE Source.LastName END
			  ,CASE WHEN Source.Email='null' then NULL ELSE Source.Email END
			  ,TRY_CONVERT(datetime2,CASE WHEN Source.MemberDate='null' then NULL WHEN Source.MemberDate LIKE '%+%' THEN SUBSTRING(Source.MemberDate,1,CHARINDEX('+',Source.MemberDate)-1) ELSE Source.MemberDate END,104)
			  ,TRY_CONVERT(bigint,CASE WHEN Source.ProgramId='null' then NULL ELSE Source.ProgramId END)
			  ,CASE WHEN Source.Program='null' then NULL ELSE Source.Program END
			  ,TRY_CONVERT(bigint,CASE WHEN Source.ProgramTypeId='null' then NULL ELSE Source.ProgramTypeId END)
			  ,TRY_CONVERT(bigint,CASE WHEN Source.LeadId='null' then NULL ELSE Source.LeadId END)
			  ,CASE WHEN Source.Status='null' then NULL ELSE Source.Status END
			  ,CASE WHEN Source.StatusId='null' then NULL ELSE Source.StatusId END);


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
	    'ImportMarketoBulkExtractTablesToPL',
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
