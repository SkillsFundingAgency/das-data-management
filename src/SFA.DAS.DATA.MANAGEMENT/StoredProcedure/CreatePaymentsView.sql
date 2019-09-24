CREATE PROCEDURE [dbo].[CreatePaymentsView]
(
   @RunId int
)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 15/08/2019
-- Description: Create Views for Payments that mimics RDS Payments
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
	   ,'CreatePaymentsView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreatePaymentsView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''Das_Payments'')
Drop View Data_Pub.Das_Payments
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[Das_Payments]
	AS 
  WITH Comt AS
        (SELECT ID,
                DateofBirth
           FROM Comt.Ext_Tbl_Apprenticeship)
,Transfers AS
        (SELECT DISTINCT [SenderAccountId] 
                        ,[SenderAccountName] 
                        ,[ReceiverAccountId] 
                        ,[ReceiverAccountName] 
                        ,[ApprenticeshipId]
           FROM [Fin].[Ext_Tbl_AccountTransfers])
,Payment AS
        (SELECT P.*
               ,Cast(P.CollectionPeriodYear AS varchar)+''-''+RIGHT(''0'' + RTRIM(cast(p.CollectionPeriodMonth AS varchar)), 2)+''-01'' CollectionDate 
               ,Cast(P.DeliveryPeriodYear AS varchar)+''-''+RIGHT(''0'' + RTRIM(cast(p.DeliveryPeriodMonth AS varchar)), 2)+''-01'' DeliveryDate
           FROM Fin.Ext_Tbl_Payment P) 

'
SET @VSQL3='
		SELECT	
           [P].[PaymentId]                                                    AS ID
		 , [P].[PaymentId]                                                    AS PaymentID 
         , CAST([P].[UkPrn] AS BIGINT)                                        AS UKPRN 
         , CAST([P].[Uln] AS BIGINT)                                          AS ULN 
         , [P].[AccountId]                                                    AS EmployerAccountID 
         , Acct.HashedId                                                      AS DasAccountId 
         , P.ApprenticeshipId                                                 AS CommitmentID 
         , P.DeliveryPeriodMonth                                              AS DeliveryMonth 
         , P.DeliveryPeriodYear                                               AS DeliveryPeriod 
         , P.CollectionPeriodMonth                                            AS CollectionMonth 
         , P.CollectionPeriodYear                                             AS CollectionYear 
         , [P].[EvidenceSubmittedOn]                                          AS EvidenceSubmittedOn 
         , [P].[EmployerAccountVersion]                                       AS EmployerAccountVersion 
         , [P].[ApprenticeshipVersion]                                        AS ApprenticeshipVersion 
         --, CASE
         --    WHEN  P.FundingSource=1    THEN ''Levy''
         --    WHEN  P.FundingSource=2    THEN ''CoInvestedSfa''
         --    WHEN  P.FundingSource=3    THEN ''CoInvestedEmployer''
         --    WHEN  P.FundingSource=4    THEN ''FullyFundedSfa''
         --    WHEN  P.FundingSource=5    THEN ''LevyTransfer''
         --    ELSE ''Unknown''
         --   END                                                             AS FundingSource 
		 ,COALESCE(FS.FieldDesc,''Unknown'')                                  AS FundingSource
         , CASE
             WHEN [P].[FundingSource] = 5 THEN [EAT].[SenderAccountId]
             ELSE NULL
            END                                                               AS FundingAccountId
         --, CASE
         --    WHEN P.TransactionType=1  THEN ''Learning''
         --    WHEN P.TransactionType=2  THEN ''Completion''
         --    WHEN P.TransactionType=3  THEN ''Balancing''
         --    WHEN P.TransactionType=4  THEN ''First16To18EmployerIncentive''
         --    WHEN P.TransactionType=5  THEN ''First16To18ProviderIncentive''
         --    WHEN P.TransactionType=6  THEN ''Second16To18EmployerIncentive''
         --    WHEN P.TransactionType=7  THEN ''Second16To18ProviderIncentive''
         --    WHEN P.TransactionType=8  THEN ''OnProgramme16To18FrameworkUplift''
         --    WHEN P.TransactionType=9  THEN ''Completion16To18FrameworkUplift''
         --    WHEN P.TransactionType=10 THEN ''Balancing16To18FrameworkUplift''
         --    WHEN P.TransactionType=11 THEN ''FirstDisadvantagePayment''
         --    WHEN P.TransactionType=12 THEN ''SecondDisadvantagePayment''
         --    WHEN P.TransactionType=15 THEN ''LearningSupport''
         --    WHEN P.TransactionType=16 THEN ''CareLeaverApprenticePayment''
         --    ELSE ''Unknown''
         --  END                                                              AS TransactionType 
		 , COALESCE(TT.FieldDesc,''Unknown'')                                 AS TransactionType
         , [P].[Amount]                                                       AS Amount
         , CAST(COALESCE([PM].[StandardCode], -1) AS INT)                     AS [StdCode] 
         , CAST(COALESCE([PM].[FrameworkCode], -1) AS INT)                    AS [FworkCode] 
         , CAST(COALESCE([PM].[ProgrammeType], -1) AS INT)                    AS [ProgType] 
         , CAST(COALESCE([PM].[PathwayCode], -1) AS INT)                      AS [PwayCode] 
         , CASE
             WHEN NL.AccountId IS NULL 
		     THEN ''ContractWithEmployer''
             ELSE ''ContractWithSFA''
            END                                                               AS ContractType 
         , EvidenceSubmittedOn                                                AS UpdatedDateTime 
         , CAST(EvidenceSubmittedOn AS DATE)                                  AS [UpdateDate] 
         , 1                                                                  AS [Flag_Latest] 
         , COALESCE(FP.Flag_FirstPayment, 0)                                  AS Flag_FirstPayment 
         , CASE
             WHEN C.DateOfBirth IS NULL THEN -1
             ELSE DATEDIFF(YEAR, C.DateOfBirth, p.EvidenceSubmittedOn)
            END                                                               AS PaymentAge 
         , CASE
             WHEN C.DateOfBirth IS NULL THEN ''Unknown DOB (no commitment)''
             WHEN DATEDIFF(YEAR, C.DateOfBirth, P.EvidenceSubmittedOn) BETWEEN 0 AND 18 THEN ''16-18''
             ELSE ''19+''
            END                                                               AS PaymentAgeBand 
         , CM.CalendarMonthShortNameYear                                      AS DeliveryMonthShortNameYear 
         , Acct.Name                                                          AS DASAccountName 
         , P.PeriodEnd                                                        AS CollectionPeriodName 
         , P.CollectionPeriodMonth                                            AS CollectionPeriodMonth
         , P.CollectionPeriodYear                                             AS CollectionPeriodYear
 FROM    Payment AS P 
'
SET @VSQL4=
'  LEFT JOIN  Transfers EAT 
          ON P.ApprenticeshipId = EAT.ApprenticeshipId 
   LEFT JOIN  Fin.Ext_Tbl_PaymentMetaData PM 
          ON P.PaymentMetaDataId = PM.Id 		
   LEFT JOIN
              (
                SELECT
                   [P].[AccountId] AccountId,
                   P.ApprenticeshipId ApprenticeshipId,
                   MIN(CollectionDate) MinCollectionPeriod,
                   MIN(DeliveryDate) MinDeliveryPeriod,
                   1 AS Flag_FirstPayment 
                  FROM Payment AS P 
                 GROUP BY
                    P.AccountId,
                    P.ApprenticeshipId
              )   FP 
          ON FP.AccountId = P.AccountId 
         AND FP.ApprenticeshipId = P.ApprenticeshipId 
         AND FP.MinCollectionPeriod = P.CollectionDate 
         AND FP.MinDeliveryPeriod = P.DeliveryDate 		
   LEFT JOIN  Comt C 
          ON [c].id = [p].[ApprenticeshipId] 
  INNER JOIN  dbo.DASCalendarMonth CM 
          ON CM.CalendarMonthNumber = P.DeliveryMonth 
         AND CM.CalendarYear = P.DeliveryYear 		
   LEFT JOIN
             (
              SELECT NAME
			        ,ID
					,HashedId 
                FROM [Acct].Ext_Tbl_Account
             ) Acct 
          ON Acct.Id = [P].AccountId 
   LEFT JOIN
             (
              SELECT AccountId,
                     IsLevy 
                FROM Resv.Ext_Tbl_AccountLegalEntity 
               WHERE IsLevy = 0 
                 AND AgreementType = 1 
                 AND AgreementSigned = 1
             ) NL 
          ON NL.AccountId = P.AccountId
   LEFT JOIN 
            (
			 SELECT FieldValue
			       ,FieldDesc
			   FROM dbo.ReferenceData TM
			  WHERE TM.FieldName=''TransactionType''
			    and TM.Category=''Payments'') TT
		  ON TT.FieldValue=P.TransactionType
    LEFT JOIN 
            (
			 SELECT FieldValue
			       ,FieldDesc
			   FROM dbo.ReferenceData TM
			  WHERE TM.FieldName=''FundingSource''
			    and TM.Category=''Payments'') FS
		  ON FS.FieldValue=P.TransactionType
'

EXEC SP_EXECUTESQL @VSQL1
EXEC (@VSQL2+@VSQL3+@VSQL4)

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
	    'CreatePaymentsView',
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


		  

