CREATE PROCEDURE [dbo].[CreateNonLevyView]
(
   @RunId int
)
AS
-- =========================================================================
-- Author:      Rob Tanner
-- Create Date: 24/09/2019
-- Description: Create View for NonLevy
-- =========================================================================

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
	   ,'Step-4'
	   ,'CreateNonLevyView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateNonLevyView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''Das_NonLevy'')
Drop View Data_Pub.Das_NonLevy
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[Das_NonLevy]
	AS

WITH NonLevyPayments
AS
(SELECT *
   FROM Fin.Ext_Tbl_Payment P
  WHERE ApprenticeshipId in 
             (SELECT a.Id as ApprenticeshipId
                FROM Comt.Ext_Tbl_Apprenticeship a
                join comt.Ext_Tbl_Commitment c
                  on a.CommitmentId=c.Id
               INNER
                join Resv.Ext_Tbl_AccountLegalEntity AEL
                  ON AEL.AccountId=c.EmployerAccountId
                 AND AEL.AgreementType=1
                 AND AEL.IsLevy=0) 
)

SELECT 
       A.accountlegalentityid										AS AccountLegalEntityId 
      ,L.NAME														AS AccountLegalEntityName
      ,L.created													AS AccountLegalEntityCreatedDate 
      ,COALESCE(R.modifieddate, ''9999-12-31'')                     AS AccountModifiedDate 
      ,CASE 
         WHEN A.templateid = ''1'' THEN ''LevyAgreementV1'' 
         WHEN A.templateid = ''2'' THEN ''LevyAgreementV2'' 
         WHEN A.templateid = ''3'' THEN ''NonLevyAgreementV1'' 
         ELSE ''Other'' 
       END															AS AgreementTemplateId 
      ,CASE 
         WHEN A.statusid = ''1'' THEN ''Pending'' 
         WHEN A.statusid = ''2'' THEN ''Signed'' 
         WHEN A.statusid = ''3'' THEN ''Expired'' 
         WHEN A.statusid = ''4'' THEN ''Superceded'' 
         ELSE ''InvalidEvent'' 
       END															AS AgreementStatusId 
      ,COALESCE(A.signeddate, ''9999-12-31'')                       AS AgreementSignedDate 
      ,COALESCE(F.accountid, -99999)								AS UserAccountId 
      ,CASE 
         WHEN F.islevyaccount = ''1'' THEN ''Yes'' 
         WHEN F.islevyaccount = ''0'' THEN ''No'' 
         ELSE ''NA'' 
       END															AS LevyAccount 
      ,COALESCE(F.createddate, ''9999-12-31'')						AS CreatedDate 
      ,COALESCE(F.startdate, ''9999-12-31'')						AS StartDate 
      ,COALESCE(F.expirydate, ''9999-12-31'')						AS ReservationExpiryDate 
      ,CASE 
         WHEN F.status = ''1'' THEN ''Commitment'' 
         WHEN F.status = ''0'' THEN ''Reservation'' 
         ELSE ''NA'' 
       END															AS ReservationStatus 
      ,COALESCE(F.courseid, ''-99999'')								AS ReservationCourseId 
      ,COALESCE(T.title, ''NA'')									AS ReservationCourseTitle 
      ,COALESCE(T.level, -9)										AS ReservationLevel 
      ,COALESCE(CONVERT(VARCHAR(255), F.id), ''NA'')				AS ReservationId 
      ,COALESCE(P.commitmentid, -1)									AS CommitmentId 
      ,COALESCE(P.createdon, ''9999-12-31'')						AS CommitmentCreatedOn 
      ,COALESCE(P.startdate, ''9999-12-31'')						AS CommitmentStartDate 
      ,COALESCE(P.trainingtype, -99999)								AS CommitmentTrainingType 
      ,COALESCE(P.trainingname, ''NA'')								AS CommitmentTrainingName 
      ,COALESCE(P.trainingcode, ''-99999'')								AS CommitmentTrainingCode 
      ,COALESCE(P.isapproved, -99999)								AS CommitmentIsApproved 
      ,COALESCE(P.agreedon, ''9999-12-31'')							AS ApprovalAgreedOn 
      ,COALESCE(C.providerid, -1)									AS ProviderId
      ,COALESCE(C.providername, ''NA'')								AS ApprovalProviderName 
      ,COALESCE(CONVERT(VARCHAR(255),NLP.PaymentId),''NA'')			AS PaymentId
      ,COALESCE(NLP.EvidenceSubmittedOn,''9999-12-31'')				AS EvidenceSubmittedOn
      ,COALESCE(NLP.CollectionPeriodYear, 0000)					AS CollectionPeriodYear
      ,COALESCE(NLP.CollectionPeriodMonth, -1)					AS CollectionPeriodMonth
      ,COALESCE(NLP.DeliveryPeriodYear, 0000)					AS DeliveryPeriodYear
      ,COALESCE(NLP.DeliveryPeriodMonth, -1)						AS DeliveryPeriodMonth
      ,COALESCE(NLP.Amount,0)										AS PaidAmount
FROM   acct.ext_tbl_account R 
       LEFT JOIN acct.ext_tbl_accountlegalentity L 
              ON L.accountid = R.id 
       LEFT JOIN acct.ext_tbl_employeragreement A 
              ON A.accountlegalentityid = L.id 
       LEFT JOIN resv.ext_tbl_reservation F 
              ON F.accountlegalentityid = L.id 
       LEFT JOIN resv.ext_tbl_course T 
              ON T.courseid = F.courseid 
       LEFT JOIN comt.ext_tbl_apprenticeship P 
              ON P.reservationid = F.id 
       LEFT JOIN comt.ext_tbl_commitment C 
              ON C.id = P.commitmentid 
       LEFT JOIN Resv.Ext_Tbl_AccountLegalEntity ALE
              ON ALE.AccountId=R.Id
       LEFT JOIN NonLevyPayments NLP
              ON NLP.ApprenticeshipId=P.Id
WHERE  ALE.AgreementType=1
       AND ALE.IsLevy=0
       AND L.id <> ''33275'' 
       AND L.id <> ''33278'' 
       AND L.id <> ''33301''
'

EXEC SP_EXECUTESQL @VSQL1
EXEC (@VSQL2)

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
	    'CreateNonLevyView',
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


		  

