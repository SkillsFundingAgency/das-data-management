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
    ON Target.ProgramId=TRY_CONVERT(BIGINT,CASE WHEN Source.Id='NULL' THEN NULL ELSE Source.Id END)
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
				  , Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (ProgramId
              ,ProgramName
			  ,ProgramDescription
			  ,CreatedAt
			  ,UpdatedAt
			  ,ProgramType
			  ,Channel
			  ,AsDm_CreatedDate
			  ,AsDm_UpdatedDate
			  ) 
       VALUES (TRY_CONVERT(BIGINT,CASE WHEN Source.Id='NULL' THEN NULL ELSE Source.Id END)
	          ,CASE WHEN Source.name='null' THEN NULL ELSE Source.name END
			  ,CASE WHEN Source.Description='NULL' THEN NULL ELSE Source.Description END
			  ,TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.CreatedAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.CreatedAt END,'9999-12-31'),104)
			  ,TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.UpdatedAt='NULL' THEN NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.UpdatedAt END,'9999-12-31'),104)
			  ,CASE WHEN Source.Type='null' THEN NULL ELSE Source.Type END,CASE WHEN Source.Channel='null' THEN NULL ELSE Source.Channel END
			  ,getdate()
			  ,getdate()
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
				 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT (ActivityTypeId
              ,ActivityTypeName
			  ,ActivityTypeDescription
			  ,AsDm_CreatedDate
			  ,AsDm_UpdatedDate
			  )
	   VALUES
	          (Source.Id
	          ,CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
	          ,CASE WHEN Source.description='NULL' THEN NULL ELSE Source.description END
			  ,getdate()
			  ,getdate()
			  );

/* Delta Update MarketoSmartCampaigns */

			  MERGE AsData_PL.MarketoSmartCampaigns as Target
 USING Stg.MarketoSmartCampaigns as Source
    ON Target.SmartCampaignId=TRY_CONVERT(bigint,Source.id)
  WHEN MATCHED AND ( ISNULL(Target.SmartCampaignName,'NA')<>ISNULL(CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END,'NA')
                  OR ISNULL(Target.SmartCampaignType,'NA')<>ISNULL(CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END,'NA')
				  OR ISNULL(Target.SmartCampaignDesc,'NA')<>ISNULL(CASE WHEN Source.description='NULL' THEN NULL ELSE Source.description END,'NA')
				  OR ISNULL(Target.ParentProgramId,-1)<>TRY_CONVERT(BIGINT,ISNULL(Source.parentprogramId,-1))
				  OR ISNULL(Target.WorkspaceName,'NA')<>ISNULL(CASE WHEN Source.workspace='NULL' THEN NULL ELSE Source.workspace END,'NA')
				  OR ISNULL(Target.createdAt,'9999-12-31')<>TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,'9999-12-31'),104)
				  OR ISNULL(Target.updatedAt,'9999-12-31')<>TRY_CONVERT(datetime2,ISNULL(CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.UpdatedAt LIKE '%+%' THEN SUBSTRING(Source.UpdatedAt,1,CHARINDEX('+',Source.UpdatedAt)-1) ELSE Source.updatedAt END,'9999-12-31'),104)
				  OR ISNULL(Target.IsActive,'NA')<>ISNULL(CASE WHEN Source.IsActive='NULL' THEN NULL ELSE Source.IsActive END,'NA')
				  OR ISNULL(Target.Status,'NA')<>ISNULL(CASE WHEN Source.Status='NULL' THEN NULL ELSE Source.Status END,'NA')
				  OR ISNULL(Target.SmartListId,'-1')<>TRY_CONVERT(BIGINT,ISNULL(CASE WHEN Source.SmartListId='NULL' THEN NULL ELSE Source.SmartListId END,'-1'))
				  )
  THEN UPDATE SET Target.SmartCampaignName=CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
                 ,Target.SmartCampaignType=CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END
				 ,Target.SmartCampaignDesc=CASE WHEN Source.description='NULL' THEN NULL ELSE Source.description END
				 ,Target.ParentProgramId=TRY_CONVERT(BIGINT,ISNULL(Source.parentprogramId,-1))
				 ,Target.WorkspaceName=CASE WHEN Source.workspace='NULL' THEN NULL ELSE Source.workspace END
				 ,Target.createdAt=TRY_CONVERT(datetime2,CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,104)
				 ,Target.updatedAt=TRY_CONVERT(datetime2,CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.updatedAt LIKE '%+%' THEN SUBSTRING(Source.updatedAt,1,CHARINDEX('+',Source.updatedAt)-1) ELSE Source.updatedAt END,104)
				 ,Target.IsActive=CASE WHEN Source.IsActive='NULL' THEN NULL ELSE Source.IsActive END
				 ,Target.Status=CASE WHEN Source.Status='NULL' THEN NULL ELSE Source.Status END
				 ,Target.SmartListId=TRY_CONVERT(bigint,CASE WHEN Source.SmartListId='NULL' THEN NULL ELSE Source.SmartListId END)
				 ,Target.AsDm_UpdatedDate=getdate()
  WHEN NOT MATCHED BY TARGET 
  THEN INSERT ([SmartCampaignId]
              ,[SmartCampaignName]
              ,[SmartCampaignType]
			  ,[SmartCampaignDesc]
			  ,[ParentProgramId]
			  ,[WorkspaceName]
			  ,[CreatedAt]
			  ,[UpdatedAt]
              ,[Isactive]
			  ,[Status]
			  ,[SmartListId]
			  ,AsDm_CreatedDate
			  ,AsDm_UpdatedDate) 
       VALUES (   TRY_CONVERT(BIGINT,CASE WHEN Source.id='NULL' THEN NULL ELSE Source.id END)
	             ,CASE WHEN Source.name='NULL' THEN NULL ELSE Source.name END
                 ,CASE WHEN Source.type='NULL' THEN NULL ELSE Source.type END
				 ,CASE WHEN Source.description='NULL' THEN NULL ELSE Source.description END
				 ,TRY_CONVERT(bigint,ISNULL(Source.parentprogramId,-1))
				 ,CASE WHEN Source.workspace='NULL' THEN NULL ELSE Source.workspace END
				 ,TRY_CONVERT(datetime2,CASE WHEN Source.createdAt='NULL' THEN NULL WHEN Source.CreatedAt LIKE '%+%' THEN SUBSTRING(Source.CreatedAt,1,CHARINDEX('+',Source.CreatedAt)-1) ELSE Source.createdAt END,104)
				 ,TRY_CONVERT(datetime2,CASE WHEN Source.updatedAt='NULL' THEN NULL WHEN Source.updatedAt LIKE '%+%' THEN SUBSTRING(Source.updatedAt,1,CHARINDEX('+',Source.updatedAt)-1) ELSE Source.updatedAt END,104)
				 ,CASE WHEN Source.IsActive='NULL' THEN NULL ELSE Source.IsActive END
				 ,CASE WHEN Source.Status='NULL' THEN NULL ELSE Source.Status END
				 ,TRY_CONVERT(bigint,CASE WHEN Source.SmartListId='NULL' THEN NULL ELSE Source.SmartListId END)
				 ,getdate()
			     ,getdate()
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
