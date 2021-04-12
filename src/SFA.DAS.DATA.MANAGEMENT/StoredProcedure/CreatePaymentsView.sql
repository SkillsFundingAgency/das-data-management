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
--     Date				Author        Jira        Description
--
--      14/01/2020 R.Rai        ADM_982	    Change Agreement Type to logic to account tables
--      28/01/2020 S Heath      ADM_990     Cast data types to match RDS
--      29/01/2020 H Uddaraju   ADM_1022    Fix Join Condition for Funding Source 
--      06/05/2020 S Heath      ADM_1312    Change source data to use StgPmnts.Payment
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
-- CTEs
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Payments]
	AS 
WITH cte_Payment AS
( -- rework data from new payments staging table to match data sourced from external table
SELECT
      P.Id
    , P.EventId AS PaymentID
    , P.Ukprn
    , P.LearnerUln
    , P.AccountId
    , P.ApprenticeshipId
    , P.Amount
    , P.FundingSource
    , P.TransactionType
    , P.ContractType
    -- Mapped 0 as -1 in these codes to match original query
    , CASE WHEN P.LearningAimStandardCode = 0 THEN -1 
        ELSE P.LearningAimStandardCode 
      END                                           AS StdCode
    , CASE WHEN P.LearningAimFrameworkCode = 0 THEN -1
        ELSE P.LearningAimFrameworkCode 
     END                                            AS FworkCode
    , CASE WHEN P.LearningAimProgrammeType = 0 THEN -1
        ELSE P.LearningAimProgrammeType
      END                                           AS ProgType
    , CASE WHEN P.LearningAimPathwayCode = 0 THEN -1 
        ELSE P.LearningAimPathwayCode
      END                                           AS PwayCode
    -- derive dates from academic year / month to match original view calendar year values
    -- There are no calendar loookup for collection period R13/14 so deal with them in a case.
    , CASE WHEN P.CollectionPeriod <= 12 THEN CalCP.CalendarMonthNumber                     
        WHEN P.CollectionPeriod = 13 THEN 9
        WHEN P.CollectionPeriod = 14 THEN 10
      END                                           AS CollectionMonth
    , CASE WHEN P.CollectionPeriod <= 12 THEN CalCP.CalendarYear                            
      WHEN P.CollectionPeriod IN (13,14) THEN  
        Cast( ''20'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 3, 4) AS INT )
      END                                           AS CollectionYear
    , Cast( P.AcademicYear AS varchar) + ''-R'' 
      + RIGHT( ''0'' 
      + Cast (CollectionPeriod AS varchar), 2 )     AS CollectionPeriodName
    , ''R'' + Right( ''0'' 
          + Cast (CollectionPeriod AS varchar), 2 ) AS CollectionPeriodMonth
    , P.AcademicYear                                AS CollectionPeriodYear
    -- Need to lookup actual date for collection date as its used in age calcs (not academic calendar)
    , CASE WHEN P.CollectionPeriod <=12 THEN 
          Cast(CalCP.CalendarYear AS varchar)+ ''-''
          + RIGHT(''0'' + RTRIM(cast(CalCP.CalendarMonthNumber AS varchar)), 2)
          + ''-01''  
        WHEN P.CollectionPeriod = 13 THEN
          ''20'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 3, 4) 
          + ''-09-01''
        WHEN P.CollectionPeriod = 14 THEN
          ''20'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 3, 4)
          + ''-10-01''
      END                                           AS CollectionDate
    , CalDP.CalendarMonthNumber                     AS DeliveryMonth
    , CalDP.CalendarYear                            AS DeliveryYear
    , CalDP.CalendarMonthShortNameYear              AS DeliveryMonthShortNameYear 
    , P.DeliveryPeriod                              AS DeliveryPeriod
    , Cast(CalDP.CalendarYear AS varchar) + ''-''
      + RIGHT(''0'' + RTRIM(cast(CalDP.CalendarMonthNumber AS varchar)), 2)
      + ''-01''                                     AS DeliveryDate
    , P.IlrSubmissionDateTime                       AS EvidenceSubmittedOn
  FROM StgPmts.Payment P
  LEFT OUTER JOIN dbo.DASCalendarMonth CalCP -- Calendar Conversion for CollectionPeriod Dates
    ON ''20'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 1, 2) 
      + ''/'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 3, 4) = CalCP.AcademicYear 
    AND P.CollectionPeriod = CalCP.AcademicMonthNumber
  LEFT OUTER JOIN dbo.DASCalendarMonth CalDP -- Calendar Conversion for DeliveryPeriod Dates
    ON ''20'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 1, 2) 
      + ''/'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 3, 4) = CalDP.AcademicYear 
      AND P.DeliveryPeriod = CalDP.AcademicMonthNumber 
) 
'
-- Main Select
SET @VSQL3 = '
SELECT 
    P.ID
  , CAST( P.PaymentId AS nvarchar(100) )                              AS PaymentID  
  , P.UKprn                                                           AS UKPRN 
  , P.LearnerUln                                                      AS ULN 
  , CAST(P.AccountId AS nvarchar(100) )                               AS EmployerAccountID 
  , Acct.HashedId                                                     AS DasAccountId 
  , IsNull( P.ApprenticeshipId, -1)                                   AS CommitmentID 
  , P.DeliveryMonth                                                   AS DeliveryMonth 
  , P.DeliveryYear                                                    AS DeliveryYear 
  , ISNULL( CAST(P.CollectionMonth AS INT), -1)                       AS CollectionMonth 
  , ISNULL( CAST(P.CollectionYear  AS INT), -1)                       AS CollectionYear 
  , ISNULL(CAST( P.EvidenceSubmittedOn AS datetime ), ''9999-12-31'') AS EvidenceSubmittedOn 
  , CAST( NULL AS nvarchar(50) )                                      AS EmployerAccountVersion 
  , CAST( NULL AS nvarchar(50) )                                      AS ApprenticeshipVersion 
	, CAST( COALESCE(FS.FieldDesc,''Unknown'') AS nvarchar(25) )        AS FundingSource
  , CASE
      WHEN P.FundingSource = 5 THEN EAT.SenderAccountId
      ELSE NULL
    END                                                               AS FundingAccountId
	, CAST( COALESCE(TT.FieldDesc,''Unknown'') AS nvarchar(50) )        AS TransactionType
  , ISNULL( CAST( P.Amount AS DECIMAL (18, 5) ), -1 )                 AS Amount
  , P.StdCode
  , P.FworkCode
  , P.ProgType
  , P.PwayCode
  , CAST(CT.FieldDesc AS NVARCHAR(50))                                AS ContractType 
  , ISNULL( CAST( EvidenceSubmittedOn AS DATETIME ), ''9999-12-31'')  AS UpdateDateTime 
  , CAST( EvidenceSubmittedOn AS DATE )                               AS UpdateDate
  , 1                                                                 AS Flag_Latest
  , COALESCE(FP.Flag_FirstPayment, 0)                                 AS Flag_FirstPayment 
  , CASE
      WHEN C.DateOfBirth IS NULL THEN -1
      WHEN DATEPART(M,C.DateOfBirth) > DATEPART(M,P.CollectionDate) 
        OR (DATEPART(M,C.DateOfBirth) = DATEPART(M,P.CollectionDate) 
            AND DATEPART(DD,C.DateOfBirth) > DATEPART(DD,P.CollectionDate)
            ) THEN DATEDIFF(YEAR,C.DateOfBirth,P.CollectionDate) -1
      ELSE DATEDIFF(YEAR, C.DateOfBirth, p.CollectionDate)
    END                                                               AS PaymentAge 
  , CASE
      WHEN C.DateOfBirth IS NULL THEN ''Unknown DOB (no commitment)''
      WHEN 
        CASE
          WHEN C.DateOfBirth IS NULL THEN -1
          WHEN DATEPART(M,C.DateOfBirth) > DATEPART(M,P.CollectionDate) 
            OR ( DATEPART(M,C.DateOfBirth) = DATEPART(M,P.CollectionDate) 
                 AND DATEPART(DD,C.DateOfBirth) > DATEPART(DD,P.CollectionDate)
               ) THEN DATEDIFF(YEAR,C.DateOfBirth,P.CollectionDate) -1
          ELSE DATEDIFF(YEAR,C.DateOfBirth, P.CollectionDate)
        END BETWEEN 0 AND 18 THEN ''16-18''
      ELSE ''19+''
    END                                                               AS PaymentAgeBand 
  , P.DeliveryMonthShortNameYear 
  , Acct.Name                                                         AS DASAccountName 
  , CAST ( P.CollectionPeriodName AS nvarchar(20) )                   AS CollectionPeriodName
  , CAST ( P.CollectionPeriodMonth AS nvarchar(10) )                  AS CollectionPeriodMonth
  , CAST ( P.CollectionPeriodYear AS nvarchar(10) )                   AS CollectionPeriodYear
  , P.LearningAimFundingLineType                                      AS LearningAimFundingLineType
'
-- Joins
SET @VSQL4 = '
FROM cte_Payment P 
LEFT JOIN Acct.Ext_Tbl_Account Acct ON Acct.Id = P.AccountId
LEFT JOIN Comt.Ext_Tbl_Apprenticeship C
  ON P.ApprenticeshipId = C.ID
LEFT JOIN -- transfers
( SELECT DISTINCT 
    SenderAccountId
    , ReceiverAccountId
    , ApprenticeshipId
  FROM Fin.Ext_Tbl_AccountTransfers
) EAT ON P.ApprenticeshipId = EAT.ApprenticeshipId 
-- need to use cte_payment as weve messed with the delivery dates and they wont join
-- create a string to decide which is min doing individual columns doesnt 
-- work as dates and IDs are in alignment
LEFT JOIN
( SELECT P.AccountId
  , P.ApprenticeshipId
   , MIN( CAST( P.CollectionDate AS VARCHAR (12) ) 
    + ''-'' + CAST( P.DeliveryDate AS varchar(12) )
    + ''-'' + CAST( P.EvidenceSubmittedOn AS varchar(25) )
    + ''-'' + CAST( P.Id AS VARCHAR(12) ) ) AS MinPaymentString
  , 1 AS Flag_FirstPayment
  FROM cte_Payment P
  GROUP BY P.AccountId, P.ApprenticeshipId  
) FP ON P.AccountId = FP.AccountId
  AND ( CAST( P.CollectionDate AS VARCHAR (12) ) 
    + ''-'' + CAST( P.DeliveryDate AS varchar(12) )
    + ''-'' + CAST( P.EvidenceSubmittedOn AS varchar(25) )
    + ''-'' + CAST( P.Id AS VARCHAR(12) ) ) = FP.MinPaymentString
LEFT JOIN dbo.ReferenceData TT
  ON TT.FieldValue = P.TransactionType
    AND TT.FieldName = ''TransactionType''
    AND TT.Category = ''Payments''
LEFT JOIN dbo.ReferenceData FS
  ON FS.FieldValue=P.FundingSource
    AND FS.FieldName=''FundingSource''
    AND FS.Category=''Payments''
LEFT JOIN dbo.ReferenceData CT
  ON CT.FieldValue=P.ContractType
    AND CT.FieldName=''ContractType''
    AND CT.Category=''Payments''
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


		  

