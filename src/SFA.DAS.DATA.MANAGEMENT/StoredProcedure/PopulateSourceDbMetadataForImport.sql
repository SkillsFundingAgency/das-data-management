CREATE PROCEDURE [dbo].[PopulateSourceDbMetadataForImport]
(
   @RunId int
)
AS
/* =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 28/05/2020
-- Description: Populate Metadata Table with Source Config for Import 
-- =========================================================================

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
	   ,'PopulateSourceDbMetadataForImport'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='PopulateSourceDbMetadataForImport'
     AND RunId=@RunID



INSERT INTO Mtd.SourceConfigForImport
(SourceDatabaseName,SourceTableName,ColumnNamesToInclude,ColumnNamesToExclude)

/* AVMSPlus Metadata */

Values
('AVMSPlus'
,'Candidate'
,'dbo'
,'[CandidateId],[PersonId],[CandidateStatusTypeId],[CountyId],[Postcode],[LocalAuthorityId],[VoucherReferenceNumber],[UniqueLearnerNumber],[UlnStatusId],[Gender],[ApplicationLimitEnforced],[LastAccessedDate],[ReceivePushedContent],[ReferralAgent],[DisableAlerts],[DoBFailureCount],[ForgottenUsernameRequested],[ForgottenPasswordRequested],[TextFailureCount],[EmailFailureCount],[LastAccessedManageApplications],[ReferralPoints],[BeingSupportedBy],[LockedForSupportUntil],[AllowMarketingMessages],[ReminderMessageSent],[CandidateGuid],[DateofBirth]'
,'[AddressLine1],[AddressLine2],[AddressLine3],[AddressLine4],[AddressLine5],[Town],[Longitude],[Latitude],[GeocodeEasting],[GeocodeNorthing],[NiReference],[EthnicOrigin],[EthnicOriginOther],[AdditionalEmail],[Disability],[DisabilityOther],[HealthProblems],[UnconfirmedEmailAddress],[MobileNumberUnconfirmed],[NewVacancyAlertEmail],[NewVacancyAlertSMS]'
)





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
	    'PopulateSourceDbMetadataForImport',
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


		  

