CREATE PROCEDURE [dbo].[PopulateMetadataDataRetention]
(
   @RunId int
)
AS
/* =================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 06/07/2021
-- Description: Populate Metadata Table with Data Retention Config for each dataset 
-- =================================================================================
*/

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
	   ,'PopulateMetadataDataRetenction'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='PopulateMetadataDataRetention'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM Mtd.DataRetentionConfig

INSERT INTO Mtd.DataRetentionConfig
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DatasetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
/* Marketo Metadata */
VALUES (-1,'Marketo','MarketoLeads','AsData_PL','LeadID',24,'FirstName,LastName,EmailAddress','LeadCreatedAt','','','',1,0,1),
(-1,'Marketo','MarketoLeadActivities','AsData_PL','LeadID',24,'','','LeadID','MarketoLeads','AsData_PL',1,0,1),
(-1,'Marketo','MarketoLeadPrograms','AsData_PL','LeadID',24,'FirstName,LastName,EmailAddress','','LeadID','MarketoLeads','AsData_PL',1,0,1),
(-1,'Marketo','MarketoLeadActivityLinkClicked','AsData_PL','LeadID',24,'ReferrerURL,Link,QueryParameters','','LeadID','MarketoLeads','AsData_PL',1,0,1),
(-1,'Commitment','Comt_Commitment','AsData_PL','Id',24,'','CreatedOn','','','',1,0,1),
(-1,'Commitment','Comt_Apprenticeship','AsData_PL','CommitmentId',24,'DateOfBirth,Age','','Id','Comt_Commitment','AsData_PL',1,0,1),
(-1,'Commitment','Comt_ApprenticeshipConfirmationStatus','AsData_PL','ApprenticeshipId',24,'','','Id','Comt_Apprenticeship','AsData_PL',1,0,1),
(-1,'Commitment','Comt_DataLockStatus','AsData_PL','ApprenticeshipId',24,'','','Id','Comt_Apprenticeship','AsData_PL',1,0,1),
(-1,'Commitment','Comt_History','AsData_PL','CommitmentId',24,'','','Id','Comt_Commitment','AsData_PL',1,0,1),
(-1,'Commitment','Comt_Providers','AsData_PL','UKPRN',24,'Name','Created','','','',1,0,1)

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
	    'PopulateMetadataDataRetention',
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