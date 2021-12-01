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
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DataSetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
/* Marketo Metadata */
VALUES (-1,'Marketo','MarketoLeads','AsData_PL','LeadID',24,'FirstName,LastName,EmailAddress','LeadCreatedAt','','','',1,0,1),
(-1,'Marketo','MarketoLeadActivities','AsData_PL','LeadID',24,'','','LeadID','MarketoLeads','AsData_PL',1,0,1),
(-1,'Marketo','MarketoLeadPrograms','AsData_PL','LeadID',24,'FirstName,LastName,EmailAddress','','LeadID','MarketoLeads','AsData_PL',1,0,1),
(-1,'Marketo','MarketoLeadActivityLinkClicked','AsData_PL','LeadID',24,'ReferrerURL,Link,QueryParameters','','LeadID','MarketoLeads','AsData_PL',1,0,1),
(-1,'Commitment','Comt_Commitment','AsData_PL','Id',84,'','CreatedOn','','','',1,0,1),
(-1,'Commitment','Comt_Apprenticeship','AsData_PL','CommitmentId',84,'DateOfBirth,Age,ULN,StandardUId','','Id','Comt_Commitment','AsData_PL',1,0,1),
(-1,'Commitment','Comt_ApprenticeshipConfirmationStatus','AsData_PL','ApprenticeshipId',84,'','','Id','Comt_Apprenticeship','AsData_PL',1,0,1),
(-1,'Commitment','Comt_DataLockStatus','AsData_PL','ApprenticeshipId',84,'','','Id','Comt_Apprenticeship','AsData_PL',1,0,1),
(-1,'Commitment','Comt_History','AsData_PL','CommitmentId',84,'','','Id','Comt_Commitment','AsData_PL',1,0,1),
(-1,'Commitment','Comt_Providers','AsData_PL','Name',84,'Name','Created','','','',1,0,1),
(-1,'Commitment','Comt_ApprenticeshipUpdate','AsData_PL','ApprenticeshipId',84,'','CreatedOn','Id','Comt_Apprenticeship','AsData_PL',1,0,1)

/* Accounts and Users Retention Config */
INSERT INTO Mtd.DataRetentionConfig
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DataSetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
SELECT SCFI_Id,'Accounts','Acc_Account','AsData_PL','Id',84,'','CreatedDate','','','',0,1,1 FROM Mtd.sourceconfigforimport WHERE SourceDatabaseName='Accounts' and SourceTableName='Account'
INSERT INTO Mtd.DataRetentionConfig
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DataSetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
SELECT SCFI_Id,'Accounts','Acc_AccountUserRole','AsData_PL','AccountId',84,'','','Id','acc_account','AsData_PL',0,1,1  FROM Mtd.sourceconfigforimport  WHERE SourceDatabaseName='Accounts' and SourceTableName='Membership'
INSERT INTO Mtd.DataRetentionConfig
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DataSetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
SELECT SCFI_Id,'Accounts','Acc_User','AsData_PL','Id',84,'FirstName,LastName,Email','','UserId','acc_accountuserrole','AsData_PL',0,1,1  FROM Mtd.sourceconfigforimport  WHERE SourceDatabaseName='Accounts' and SourceTableName='User'
INSERT INTO Mtd.DataRetentionConfig
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DataSetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
SELECT SCFI_Id,'Users','EAU_User','AsData_PL','Id',84,'FirstName,LastName,Email','','UserRef','acc_user','AsData_PL',0,1,1  FROM Mtd.sourceconfigforimport  WHERE SourceDatabaseName='Users' and SourceTableName='User'
INSERT INTO Mtd.DataRetentionConfig
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DataSetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
SELECT SCFI_Id,'Accounts','Acc_AccountHistory','AsData_PL','AccountId',84,'PayeRef','','ID','acc_account','AsData_PL',0,1,1  FROM Mtd.sourceconfigforimport  WHERE SourceDatabaseName='Accounts' and SourceTableName='AccountHistory'
INSERT INTO Mtd.DataRetentionConfig
( SFCI_Id,DataSetName,DataSetTable,DataSetSchema,DataSetJOINColumn,RetentionPeriodInMonths,SensitiveColumns,RetentionColumn,RefColumn,RefDataSetTable,RefDataSetSchema,PreImportRetention,PostImportRetention,IsActive)
SELECT SCFI_Id,'Accounts','Acc_Paye','AsData_PL','Name',84,'Ref','','Name','acc_account','AsData_PL',0,1,1  FROM Mtd.sourceconfigforimport WHERE SourceDatabaseName='Accounts' and SourceTableName='Paye'





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