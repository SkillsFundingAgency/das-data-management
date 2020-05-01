CREATE PROCEDURE [dbo].[CreateSpendControlView]
(
   @RunId int
)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 05/04/2020
-- Description: Spend Control for Levy and Non-Levy Created after 2019
-- =========================================================================

/*
Change Control
     
     Date				Author        Jira             Description

  	 01/05/2020			R.Rai        ADM-1471          Remove fields from Commitments

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
	   ,'Step-4'
	   ,'CreateSpendControlView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateSpendControlView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_SpendControl'')
Drop View ASData_PL.DAS_SpendControl
'
SET @VSQL2='
CREATE VIEW [ASData_PL].[DAS_SpendControl]
	AS
SELECT 
 COALESCE(Account.EmployerAccountId, -1)                                     AS EmployerAccountId
,COALESCE(Account.DasAccountId, ''XXXXXX'')                                  AS DasAccountId
,COALESCE(Account.DasAccountName, ''NA'')                                    AS DasAccountName
,COALESCE(Account.AccountCreatedDate,''999-12-31'')                          AS AccountCreatedDate
,COALESCE(Account.AccountModifiedDate,''9999-12-31'')                        AS AccountModifiedDate
,COALESCE(Account.ApprenticeshipEmployerType,-1)                             AS AccountApprenticeshipEmployerType
,COALESCE(Account.DasLegalEntityId,''-1'')                                   AS DasLegalEntityId
,COALESCE(Account.LegalEntityName,''NA'')                                    AS LegalEntityName
,COALESCE(Account.LegalEntityCreatedDate, ''9999-12-31'')                    AS AccountLegalEntityCreatedDate   
,COALESCE(Account.AccountSignedAgreementVersion,-1)                          AS AccountSignedAgreementVersion
,CASE WHEN Account.AccountLegalEntityDeleted IS NULL
      THEN ''No''
	  ELSE ''Yes''
  END                                                                        AS AccountLegalEntityIsDeleted
,COALESCE(Account.AccountLegalEntityDeleted,''9999-12-31'')                  AS AccountLegalEntityDeletedDate
,COALESCE(Account.EmployerSignedAgreementId,-1)                              AS EmployerSignedAgreementId
,COALESCE(Account.AgreementSignedDate,''9999-12-31'')                        AS AgreementSignedDate
,COALESCE(Account.AgreementSignedByUserId,-1)                                AS AgreementSignedByUserId
,COALESCE(CONVERT(VARCHAR(255), Reservation.Id), ''NA'')                     AS ReservationId                              
,CASE 
WHEN Reservation.IslevyAccount = ''1'' THEN ''Yes'' 
WHEN Reservation.IslevyAccount = ''0'' THEN ''No''
ELSE ''NA''
END                                                                          AS ReservationIsLevyAccount 
,COALESCE(Reservation.CreatedDate, ''9999-12-31'')                           AS ReservationCreatedDate 
,COALESCE(Reservation.StartDate, ''9999-12-31'')                             AS ReservationStartDate 
,COALESCE(Reservation.ExpiryDate, ''9999-12-31'')                            AS ReservationExpiryDate 
,CASE 
WHEN Reservation.Status = ''0'' THEN ''Pending''
WHEN Reservation.Status = ''1'' THEN ''Confirmed''
WHEN Reservation.Status = ''2'' THEN ''Completed''
WHEN Reservation.Status = ''3'' THEN ''Deleted''
WHEN Reservation.Status = ''4'' THEN ''Unrestricted''
ELSE ''NA''
END                                                                          AS ReservationStatus 
,COALESCE(Reservation.Courseid, ''NA'')                                      AS ReservationCourseId 
,COALESCE(Course.Title, ''NA'')                                              AS CourseTitle 
,COALESCE(Course.Level, -1)                                                  AS CourseLevel 
,COALESCE(Apprenticeship.Commitmentid, -1)                                   AS ApprenticeshipCommitmentId
,COALESCE(Apprenticeship.Id, -1)                                             AS ApprenticeshipId 
,COALESCE(Apprenticeship.CreatedOn, ''9999-12-31'')                          AS ApprenticeshipCreatedOn 
,COALESCE(Apprenticeship.StartDate, ''9999-12-31'')                          AS ApprenticeshipStartDate 
,COALESCE(Apprenticeship.TrainingType, -1)                                   AS ApprenticeshipTrainingType 
,COALESCE(Apprenticeship.TrainingName, ''NA'')                               AS ApprenticeshipTrainingName 
,COALESCE(Apprenticeship.TrainingCode, ''NA'')                               AS ApprenticeshipTrainingCode 
,COALESCE(Apprenticeship.IsApproved, -1)                                     AS ApprenticeshipIsApproved 
,COALESCE(Apprenticeship.AgreedOn, ''9999-12-31'')                           AS ApprenticeshipAgreedOn 
,Apprenticeship.Cost                                                         AS ApprenticeshipAgreedCost
,COALESCE(Reservation.ProviderId, -1)                                        AS ReservationByEmployerOrProvider
,COALESCE(Commitment.ProviderId, -1)                                         AS CommitmentProviderId

-- ,COALESCE(Commitment.ProviderName, ''NA'')                                AS CommitmentProviderName
 ,COALESCE(TP.Name, ''NA'')                                                  AS CommitmentProviderName


,CASE WHEN [Apprenticeship].[DateOfBirth] IS NULL	THEN - 1
		      WHEN DATEPART([M], [Apprenticeship].[DateOfBirth]) > DATEPART([M], [Apprenticeship].[StartDate])
			    OR DATEPART([M], [Apprenticeship].[DateOfBirth]) = DATEPART([M], [Apprenticeship].[StartDate])
			   AND DATEPART([DD], [Apprenticeship].[DateOfBirth]) > DATEPART([DD], [Apprenticeship].[StartDate])
			  THEN DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate]) - 1
		      ELSE DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate])
		END                                                            AS [CommitmentAgeAtStart]
, ISNULL(CAST((CASE 
		              WHEN [Apprenticeship].[DateOfBirth] IS NULL THEN ''NA''
					  WHEN CASE 
				           WHEN DATEPART([M], [Apprenticeship].[DateOfBirth]) > DATEPART([M], [Apprenticeship].[StartDate])
					         OR (DATEPART([M], [Apprenticeship].[DateOfBirth]) = DATEPART([M], [Apprenticeship].[StartDate])
					        AND DATEPART([DD], [Apprenticeship].[DateOfBirth]) > DATEPART([DD], [Apprenticeship].[StartDate]))
					       THEN DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate]) - 1
				           ELSE DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate])
				            END BETWEEN 0  AND 18 
					  THEN ''16-18''
		              ELSE ''19+''
		              END) as Varchar(5)),''NA'')                      AS [CommitmentAgeAtStartBand]
                           
,COALESCE(RD.FieldDesc,''NA'')                                               AS ApprenticeshipAgreementStatus
,CAST(CASE WHEN Apprenticeship.PaymentStatus=''0'' THEN ''PendingApproval''
	               WHEN Apprenticeship.PaymentStatus=''1'' THEN ''Active''
			       WHEN Apprenticeship.PaymentStatus=''2'' THEN ''Paused''
			       WHEN Apprenticeship.PaymentStatus=''3'' THEN ''Withdrawn''
			       WHEN Apprenticeship.PaymentStatus=''4'' THEN ''Completed''
			       WHEN Apprenticeship.PaymentStatus=''5'' THEN ''Deleted''
			       ELSE ''Unknown''
		       END AS Varchar(50))                                           AS ApprenticeshipPaymentStatus
,COALESCE(Commitment.ApprenticeshipEmployerTypeOnApproval,-1)                AS ApprenticeshipEmployerTypeOnApproval
,COALESCE(Commitment.TransferSenderId,-1)                                    AS CommitmentTransferSenderId
,COALESCE(CONVERT(VARCHAR(255), Payment.PaymentId), ''NA'')                  AS PaymentId
,COALESCE(Payment.PeriodEnd, ''NA'')                                         AS PaymentPeriodEnd
,COALESCE(RDFS.FieldDesc, ''NA'')                                            AS PaymentFundingSource
,COALESCE(RDTT.FieldDesc, ''NA'')                                            AS PaymentTransactionType
,COALESCE(Payment.ApprenticeshipId, -1)                                      AS PaymentApprenticeshipId
,Payment.Amount                                                              AS PaymentAmount

FROM (SELECT *
        FROM Resv.Ext_Tbl_Reservation
	   WHERE YEAR(CreatedDate) > = 2020
       --AND IsLevyAccount = 0
		 ) Reservation
LEFT 
JOIN (select Acct.Id as EmployerAccountId
            ,Acct.HashedId as DasAccountId
	        ,ALE.Id as DasLegalEntityId
	        ,ALE.Created as LegalEntityCreatedDate
	        ,Acct.Name as DasAccountName
	        ,Ale.Name as LegalEntityName
			,Acct.CreatedDate as AccountCreatedDate
			,Acct.ModifiedDate as AccountModifiedDate
			,Acct.ApprenticeshipEmployerType as ApprenticeshipEmployerType
			,ALE.SignedAgreementVersion as AccountSignedAgreementVersion
			,ALE.Deleted as AccountLegalEntityDeleted
			,EA.SignedById as AgreementSignedByUserId
			,EA.Id as EmployerSignedAgreementId
			,EA.SignedDate as AgreementSignedDate
        FROM Acct.Ext_Tbl_Account Acct
        JOIN Acct.Ext_Tbl_AccountLegalEntity ALE
          ON Acct.Id=ale.AccountId
		LEFT
		JOIN Acct.Ext_Tbl_EmployerAgreement EA
		  ON EA.Id=ALE.SignedAgreementId) Account
  ON Account.EmployerAccountId=Reservation.AccountId
 AND Account.DasLegalEntityId=Reservation.AccountLegalEntityId
LEFT 
JOIN Resv.Ext_Tbl_Course Course 
  ON Course.CourseId = Reservation.CourseId 
LEFT 
JOIN Comt.Ext_Tbl_Apprenticeship Apprenticeship
  ON Apprenticeship.ReservationId = Reservation.Id
LEFT 
JOIN Fin.Ext_Tbl_Payment Payment
  ON Payment.ApprenticeshipId = Apprenticeship.Id 
LEFT 
JOIN Comt.Ext_Tbl_Commitment Commitment
  ON Commitment.Id = Apprenticeship.CommitmentId
LEFT 
JOIN dbo.ReferenceData RDFS
  ON RDFS.Category=''Payments''
 AND RDFS.FieldName=''FundingSource''
 AND RDFS.FieldValue=Payment.FundingSource
LEFT 
JOIN dbo.ReferenceData RDTT
  ON RDTT.Category=''Payments''
 AND RDTT.FieldName=''TransactionType''
 AND RDTT.FieldValue=Payment.TransactionType
 LEFT 
 JOIN dbo.ReferenceData RD
   ON RD.Category=''Commitments''
  AND RD.FieldName=''Approvals''
  AND RD.FieldValue=Commitment.Approvals

  LEFT
   JOIN [comt].[ext_tbl_providers] TP
 ON  Commitment.ProviderId = TP.UKPRN


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
	    'CreateSpendControlView',
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


		  

