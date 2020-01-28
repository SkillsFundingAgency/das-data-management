CREATE PROCEDURE [dbo].[CreatePaymentsView]
(
   @RunId int
)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 15/08/2019
-- Description: Create Views for Payments that mimics RDS Payments
-- Simon Heath: 04/11/2019 Amend transfers CTE to remove names to prevent 
-- duplicates and correct names of DeliveryYear and CreateDatetime to match 
-- RDS.
--
--     Change Control
--     
--     Date				Author        Jira             Description
--
--      14/01/2020 R.Rai			ADM_982			Change Agreement Type to logic to account tables
--      28/01/2020 S Heath    ADM_990     Cast data types to match RDS
--
-- =====================================================================================================

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
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Payments'')
Drop View Data_Pub.DAS_Payments
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Payments]
	AS 
  WITH Comt AS
        (SELECT ID,
                DateofBirth
           FROM Comt.Ext_Tbl_Apprenticeship)
,Transfers AS
        (SELECT DISTINCT [SenderAccountId] 
                        --,[SenderAccountName] 
                        ,[ReceiverAccountId] 
                        --,[ReceiverAccountName] 
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
           CAST( ISNULL( 1, 1 ) AS BIGINT )                                   AS ID  -- may need to do hashbytes to cast as bigint 
	       , CAST( [P].[PaymentId] AS nvarchar(100) )                           AS PaymentID  
         , CAST([P].[UkPrn] AS BIGINT)                                        AS UKPRN 
         , CAST([P].[Uln] AS BIGINT)                                          AS ULN 
         , CAST([P].[AccountId] AS nvarchar(100) )                            AS EmployerAccountID 
         , Acct.HashedId                                                      AS DasAccountId 
         , P.ApprenticeshipId                                                 AS CommitmentID 
         , P.DeliveryPeriodMonth                                              AS DeliveryMonth 
         , P.DeliveryPeriodYear                                               AS DeliveryYear 
         , P.CollectionPeriodMonth                                            AS CollectionMonth 
         , P.CollectionPeriodYear                                             AS CollectionYear 
         , [P].[EvidenceSubmittedOn]                                          AS EvidenceSubmittedOn 
         , CAST( [P].[EmployerAccountVersion] AS nvarchar(50) )               AS EmployerAccountVersion 
         , CAST( [P].[ApprenticeshipVersion] AS nvarchar(50) )                AS ApprenticeshipVersion 
		     , CAST( COALESCE(FS.FieldDesc,''Unknown'') AS nvarchar(25) )         AS FundingSource
         , CASE
             WHEN [P].[FundingSource] = 5 THEN [EAT].[SenderAccountId]
             ELSE NULL
            END                                                               AS FundingAccountId
		     , CAST( COALESCE(TT.FieldDesc,''Unknown'') AS nvarchar(50) )         AS TransactionType
         , [P].[Amount]                                                       AS Amount
         , CAST(COALESCE([PM].[StandardCode], -1) AS INT)                     AS [StdCode] 
         , CAST(COALESCE([PM].[FrameworkCode], -1) AS INT)                    AS [FworkCode] 
         , CAST(COALESCE([PM].[ProgrammeType], -1) AS INT)                    AS [ProgType] 
         , CAST(COALESCE([PM].[PathwayCode], -1) AS INT)                      AS [PwayCode] 
         , CAST( CASE
             WHEN NL.AccountId IS NULL 
		     THEN ''ContractWithEmployer''
             ELSE ''ContractWithSFA''
            END AS nvarchar (50) )                                            AS ContractType 
         , EvidenceSubmittedOn                                                AS UpdateDateTime 
         , CAST(EvidenceSubmittedOn AS DATE)                                  AS [UpdateDate] 
         , 1                                                                  AS [Flag_Latest] 
         , COALESCE(FP.Flag_FirstPayment, 0)                                  AS Flag_FirstPayment 
         , CASE
             WHEN C.DateOfBirth IS NULL THEN -1
			 WHEN DATEPART(M,C.DateOfBirth) > DATEPART(M,P.CollectionDate) OR (DATEPART(M,C.DateOfBirth) = DATEPART(M,P.CollectionDate) AND DATEPART(DD,C.DateOfBirth) > DATEPART(DD,P.CollectionDate)) THEN DATEDIFF(YEAR,C.DateOfBirth,P.CollectionDate) -1
             ELSE DATEDIFF(YEAR, C.DateOfBirth, p.CollectionDate)
            END                                                               AS PaymentAge 
         , CASE
             WHEN C.DateOfBirth IS NULL THEN ''Unknown DOB (no commitment)''
             WHEN CASE WHEN C.DateOfBirth IS NULL THEN -1
                        WHEN DATEPART(M,C.DateOfBirth) > DATEPART(M,P.CollectionDate) OR (DATEPART(M,C.DateOfBirth) = DATEPART(M,P.CollectionDate) AND DATEPART(DD,C.DateOfBirth) > DATEPART(DD,P.CollectionDate)) THEN DATEDIFF(YEAR,C.DateOfBirth,P.CollectionDate) -1
                      ELSE DATEDIFF(YEAR,C.DateOfBirth, P.CollectionDate)
                   END BETWEEN 0 AND 18 THEN ''16-18''
             ELSE ''19+''
            END                                                               AS PaymentAgeBand 
		 , CM.CalendarMonthShortNameYear                                      AS DeliveryMonthShortNameYear 
         , Acct.Name                                                          AS DASAccountName 
         , CAST( P.PeriodEnd AS nvarchar(20) )                                AS CollectionPeriodName 
         , CAST( RIGHT(rtrim(P.CollectionPeriodId),3) AS nvarchar(10) )       AS CollectionPeriodMonth
         , CAST( LEFT(ltrim(P.CollectionPeriodId),4) AS nvarchar(10) )        AS CollectionPeriodYear
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
          ON CM.CalendarMonthNumber = P.DeliveryPeriodMonth 
         AND CM.CalendarYear = P.DeliveryPeriodYear 		
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
              
		      SELECT a.ID as AccountID,
			         a.ApprenticeshipEmployerType As IsLevy
			  FROM [acct].[Ext_Tbl_Account] a
			      JOIN [acct].[Ext_Tbl_AccountLegalEntity] b
			  ON a.id = b.AccountID
			  WHERE a.ApprenticeshipEmployerType = 0
			  AND SignedAgreementID is not null
			  AND SignedAgreementVersion = 1
		

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


		  

