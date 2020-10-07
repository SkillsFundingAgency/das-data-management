CREATE PROCEDURE [dbo].[ImportMarketoReferenceTablesToPL]
(
   @RunId int
)
AS

-- ========================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 05/10/2020
-- Description: Import Marketo Campaign Data Reference Tables To Presentation Layer
-- ========================================================================================

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
	   ,'ImportMarketoReferenceTablesToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportMarketoReferenceTablesToPL'
     AND RunId=@RunID

IF @@TRANCOUNT=0
BEGIN
BEGIN TRANSACTION

/* Delta Code */

/* Delta Update MarketoPrograms */

 MERGE AsData_PL.MarketoPrograms as Target
 USING Stg.MarketoPrograms as Source
    ON Target.ProgramId=Source.Id
  WHEN MATCHED AND ( ISNULL(Target.ProgramName,'NA')<>ISNULL(CASE WHEN Source.name='null' THEN NULL ELSE Source.name END,'NA')
                  OR ISNULL(Target.ProgramDescription,'NA')<>ISNULL(CASE WHEN Source.Description='NULL' THEN NULL ELSE Source.Description END,'NA')
				  OR ISNULL(Target.CreatedAt,'9999-12-31') <> TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.CreatedAt='NULL' THEN NULL
				                                                           WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1)
				                                                           ELSE Source.CreatedAt END,'9999-12-31'),104)
				  OR ISNULL(Target.UpdatedAt,'9999-12-31') <> TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.UpdatedAt='NULL' THEN NULL 
				                                                           WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1)
				                                                           ELSE Source.UpdatedAt END,'9999-12-31'),104)
				  OR Target.ProgramType <> ISNULL(CASE WHEN Source.Type='null' THEN NULL ELSE Source.Type END,'NA')
				  OR Target.Channel <> ISNULL(CASE WHEN Source.Channel='null' THEN NULL ELSE Source.Channel END,'NA')
				  )
  THEN UPDATE SET   Target.ProgramName=CASE WHEN Source.name='null' THEN NULL ELSE Source.name END
                  , Target.ProgramDescription=CASE WHEN Source.Description='NULL' THEN NULL ELSE Source.Description END
				  , Target.CreatedAt = TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.CreatedAt='NULL' THEN NULL
				                                                         WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1)
																		 ELSE Source.CreatedAt END,'9999-12-31'),104)
				  , Target.UpdatedAt = TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.UpdatedAt='NULL' THEN NULL 
				                                                         WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1)
				                                                         ELSE Source.UpdatedAt END,'9999-12-31'),104)
				  , Target.ProgramType = CASE WHEN Source.Type='null' THEN NULL ELSE Source.Type END
				  , Target.Channel = CASE WHEN Source.Channel='null' THEN NULL ELSE Source.Channel END
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (ProgramId
              ,ProgramName
			  ,ProgramDescription
			  ,CreatedAt
			  ,UpdatedAt
			  ,ProgramType
			  ,Channel
			  ) 
       VALUES (Source.id
	          ,CASE WHEN Source.name='null' THEN NULL ELSE Source.name END
			  ,CASE WHEN Source.Description='NULL' THEN NULL ELSE Source.Description END
			  ,TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.CreatedAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.CreatedAt END,'9999-12-31'),104)
			  ,TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.UpdatedAt='NULL' THEN NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.UpdatedAt END,'9999-12-31'),104)
			  ,CASE WHEN Source.Type='null' THEN NULL ELSE Source.Type END,CASE WHEN Source.Channel='null' THEN NULL ELSE Source.Channel END
			  );

/* Delta Update MarketoCampaigns */

			  MERGE AsData_PL.MarketoCampaigns as Target
 USING Stg.MarketoCampaigns as Source
    ON Target.CampaignId=TRY_CONVERT(bigint,Source.Id)
  WHEN MATCHED AND ( ISNULL(Target.CampaignName,'NA')<>ISNULL(CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END,'NA')
                  OR ISNULL(Target.CampaignType,'NA')<>ISNULL(CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END,'NA')
				  OR ISNULL(Target.ProgramName,'NA')<>ISNULL(CASE WHEN Source.programName='NULL' THEN NULL ELSE Source.programName END,'NA')
				  OR ISNULL(Target.ProgramId,-1)<>ISNULL(Source.programId,-1)
				  OR ISNULL(Target.WorkspaceName,'NA')<>ISNULL(CASE WHEN Source.WorkspaceName='NULL' THEN NULL ELSE Source.WorkspaceName END,'NA')
				  OR ISNULL(Target.createdAt,'9999-12-31')<>TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,'9999-12-31'),104)
				  OR ISNULL(Target.updatedAt,'9999-12-31')<>TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.updatedAt END,'9999-12-31'),104)
				  OR ISNULL(Target.Active,0)<>ISNULL(Source.Active,0)
				  )
  THEN UPDATE SET Target.CampaignName=CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
                 ,Target.CampaignType=CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END
				 ,Target.ProgramName=CASE WHEN Source.programName='NULL' THEN NULL ELSE Source.programName END
				 ,Target.ProgramId=ISNULL(Source.programId,-1)
				 ,Target.WorkspaceName=CASE WHEN Source.WorkspaceName='NULL' THEN NULL ELSE Source.WorkspaceName END
				 ,Target.createdAt=TRY_CONVERT(datetime2,CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,104)
				 ,Target.updatedAt=TRY_CONVERT(datetime2,CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.updatedAt LIKE '%+%' THEN SUBSTRING(Source.updatedAt,1,CHARINDEX('+',Source.updatedAt)-1) ELSE Source.updatedAt END,104)
				 ,Target.Active=Source.Active
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT ([CampaignId]
              ,[CampaignName]
              ,[CampaignType]
              ,[ProgramName]
              ,[ProgramId]
              ,[WorkspaceName]
              ,[createdAt]
              ,[updatedAt]
              ,[active]) 
       VALUES (   Source.Id
	             ,CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
                 ,CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END
				 ,CASE WHEN Source.programName='NULL' THEN NULL ELSE Source.programName END
				 ,ISNULL(Source.programId,-1)
				 ,CASE WHEN Source.WorkspaceName='NULL' THEN NULL ELSE Source.WorkspaceName END
				 ,TRY_CONVERT(datetime2,CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,104)
				 ,TRY_CONVERT(datetime2,CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.updatedAt LIKE '%+%' THEN SUBSTRING(Source.updatedAt,1,CHARINDEX('+',Source.updatedAt)-1) ELSE Source.updatedAt END,104)
				 ,Source.Active
				 );

/* Delta Update MarketoActivityTypes */

MERGE AsData_PL.MarketoActivityTypes as Target
 USING Stg.MarketoActivityTypes as Source
    ON Target.ActivityTypeId=Source.Id
  WHEN MATCHED AND ( ISNULL(Target.ActivityTypeName,'NA')<>ISNULL(CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END,'NA')
                  OR ISNULL(Target.ActivityTypeDescription,'NA')<>ISNULL(CASE WHEN Source.description='NULL' THEN NULL ELSE Source.description END,'NA')
				   )
  THEN UPDATE SET Target.ActivityTypeName=CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
                 ,Target.ActivityTypeDescription=CASE WHEN Source.description='NULL' THEN NULL ELSE Source.description END
				
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (ActivityTypeId
              ,ActivityTypeName
			  ,ActivityTypeDescription
			  )
	   VALUES
	          (Source.Id
	          ,CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
	          ,CASE WHEN Source.description='NULL' THEN NULL ELSE Source.description END
	          );





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
	    'ImportMarketoReferenceTablesToPL',
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
