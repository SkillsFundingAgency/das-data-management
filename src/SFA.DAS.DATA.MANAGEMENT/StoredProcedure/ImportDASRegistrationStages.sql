CREATE PROCEDURE [dbo].[ImportDASRegistrationStages]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Harish N
-- Create Date: 10/07/2025
-- Description: Import DAS_RegistrationStages
-- ==========================================================================================================

BEGIN TRY

DECLARE @LogID int
DEClARE @quote varchar(5) = ''''

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
	   ,'ImportDASRegistrationStages'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportDASRegistrationStages'
     AND RunId=@RunID

BEGIN TRANSACTION

TRUNCATE TABLE ASData_PL.DAS_RegistrationStages;

 WITH cte_Paye AS
 (
     SELECT
         AccountId,
         COUNT(DISTINCT PayeRef) AS PayeAdded
     FROM ASData_PL.Acc_AccountHistory
     GROUP BY AccountId
 ),
 cte_Providers AS
 (
     SELECT
         AccountId,
         COUNT(ProviderUkprn) AS Providers
     FROM ASData_PL.PREL_AccountProviders
     GROUP BY AccountId
 ),
 cte_Agreement AS
 (
     SELECT
         a.Id AS AccountId,
         ale.SignedAgreementId,
         ea.Acknowledged
     FROM ASData_PL.Acc_Account a
     INNER JOIN ASData_PL.Acc_AccountLegalEntity ale
         ON ale.AccountId = a.Id
     INNER JOIN ASData_PL.Acc_EmployerAgreement ea
         ON ea.AccountLegalEntityId = ale.Id
 ),
 cte_Stages AS
 (
     SELECT
         a.Id AS EmployerAccountId,
         a.Name AS EmployerName,
         u.Email AS UserEmail,

         CASE WHEN u.Email IS NOT NULL THEN 'true' ELSE 'false' END AS Stage1a,
         CASE WHEN aur.Role IS NOT NULL THEN 'true' ELSE 'false' END AS Stage1b,
         CASE WHEN paye.PayeAdded IS NOT NULL THEN 'true' ELSE 'false' END AS Stage2,

         CASE
             WHEN a.NameConfirmed = 1
                  AND a.ApprenticeshipEmployerType <> 2
                  AND a.Name <> 'MY ACCOUNT'
             THEN 'true'
             ELSE 'false'
         END AS Stage3,

         CASE
             WHEN ag.SignedAgreementId IS NOT NULL
             THEN 'true'
             ELSE 'false'
         END AS Stage4a,

         CASE
             WHEN ag.Acknowledged = 1
                  AND ag.SignedAgreementId IS NULL
             THEN 'true'
             ELSE 'false'
         END AS Stage4b,

         CASE
             WHEN a.AddTrainingProviderAcknowledged = 1 THEN 'true'
             WHEN prov.AccountId IS NULL THEN 'false'
             ELSE 'true'
         END AS Stage5
     FROM ASData_PL.Acc_User u
     LEFT JOIN ASData_PL.Acc_AccountUserRole aur
         ON u.Id = aur.UserId
     LEFT JOIN ASData_PL.Acc_Account a
         ON aur.AccountId = a.Id
     LEFT JOIN cte_Paye paye
         ON a.Id = paye.AccountId
     LEFT JOIN cte_Providers prov
         ON a.Id = prov.AccountId
     LEFT JOIN cte_Agreement ag
         ON a.Id = ag.AccountId
     WHERE a.Name <> 'MY ACCOUNT'
        OR a.Name IS NULL
 )

 INSERT INTO ASData_PL.DAS_RegistrationStages
 (
     UserEmail,
     AccountCount,
     EmployerAccountId,
     EmployerName,
     Stage1a,
     Stage1b,
     Stage2,
     Stage3,
     Stage4a,
     Stage4b,
     Stage5
 )
 SELECT
     UserEmail,
     COUNT(DISTINCT EmployerAccountId) AS AccountCount,

     CASE
         WHEN COUNT(DISTINCT EmployerAccountId) = 1
         THEN MAX(EmployerAccountId)
         ELSE NULL
     END AS EmployerAccountId,

     MAX(EmployerName) AS EmployerName,

     CASE WHEN MIN(Stage1a) = MAX(Stage1a) THEN MIN(Stage1a) ELSE '' END AS Stage1a,
     CASE WHEN MIN(Stage1b) = MAX(Stage1b) THEN MIN(Stage1b) ELSE '' END AS Stage1b,
     CASE WHEN MIN(Stage2)  = MAX(Stage2)  THEN MIN(Stage2)  ELSE '' END AS Stage2,
     CASE WHEN MIN(Stage3)  = MAX(Stage3)  THEN MIN(Stage3)  ELSE '' END AS Stage3,
     CASE WHEN MIN(Stage4a) = MAX(Stage4a) THEN MIN(Stage4a) ELSE '' END AS Stage4a,
     CASE WHEN MIN(Stage4b) = MAX(Stage4b) THEN MIN(Stage4b) ELSE '' END AS Stage4b,
     CASE WHEN MIN(Stage5)  = MAX(Stage5)  THEN MIN(Stage5)  ELSE '' END AS Stage5
 FROM cte_Stages
 GROUP BY UserEmail;


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
	    'ImportDASRegistrationStages',
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
