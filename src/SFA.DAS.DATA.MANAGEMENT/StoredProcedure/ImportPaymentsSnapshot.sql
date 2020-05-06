
CREATE PROCEDURE ImportPaymentsSnapshot
(
   @RunId int
)
AS

-- ==================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 03/02/2020
-- Description: Import Payments Snapshot Data to help with Data Science Metadata Refresh Issue
--              ADM- 1036
-- Change Control
--     
-- Date				Author        Jira      Description
-- 06/05/2020 S Heath       ADM-1312  Change to StgPmnts.Payment instead of external table.
-- ==================================================

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
	   ,'Step-2'
	   ,'ImportPaymentsSnapshot'
	   ,getdate()
	   ,0

    SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportPaymentsSnapshot'
     AND RunId=@RunID


/* Import Payments Snapshot for Data Science */

TRUNCATE TABLE dbo.Payments_SS

DECLARE @vsql1 nvarchar(max)
DECLARE @vsql2 nvarchar(max)
DECLARE @vsql3 nvarchar(max)
DECLARE @vsql4 nvarchar(max)

-- CTEs
SET @vsql1='
WITH cte_Comt AS
( SELECT 
    ID
  , DateofBirth
  FROM Comt.Ext_Tbl_Apprenticeship
)
, cte_Transfers AS
( SELECT DISTINCT 
    SenderAccountId
  --,SenderAccountName
  , ReceiverAccountId
  --,ReceiverAccountName
  ,ApprenticeshipId
  FROM Fin.Ext_Tbl_AccountTransfers
)
, cte_Payment AS
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
    , CalCP.CalendarMonthNumber                     AS CollectionMonth
    , CalCP.CalendarYear                            AS CollectionYear
    , Cast( P.AcademicYear AS varchar) + ''-R'' 
      + RIGHT( ''0'' 
      + Cast (CollectionPeriod AS varchar), 2 )     AS CollectionPeriodName
    , ''R'' + Right( ''0'' 
          + Cast (CollectionPeriod AS varchar), 2 ) AS CollectionPeriodMonth
    , P.AcademicYear                                AS CollectionPeriodYear
    , CalDP.CalendarMonthNumber                     AS DeliveryMonth
    , CalDP.CalendarYear                            AS DeliveryYear
    , CalDP.CalendarMonthShortNameYear              AS DeliveryMonthShortNameYear 
    , Cast(CalCP.CalendarYear AS varchar)+ ''-''
      + RIGHT(''0'' + RTRIM(cast(CalCP.CalendarMonthNumber AS varchar)), 2)
      + ''-01''                                     AS CollectionDate 
    , Cast(CalDP.CalendarYear AS varchar) + ''-''
      + RIGHT(''0'' + RTRIM(cast(CalDP.CalendarMonthNumber AS varchar)), 2)
      + ''-01''                                     AS DeliveryDate
    , P.IlrSubmissionDateTime                       AS EvidenceSubmittedOn
  FROM StgPmts.Payment P
  INNER JOIN dbo.DASCalendarMonth CalCP -- Calendar Conversion for CollectionPeriod Dates
    ON ''20'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 1, 2) 
      + ''/'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 3, 4) = CalCP.AcademicYear 
    AND P.CollectionPeriod = CalCP.AcademicMonthNumber
  INNER JOIN dbo.DASCalendarMonth CalDP -- Calendar Conversion for DeliveryPeriod Dates
    ON ''20'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 1, 2) 
      + ''/'' + Substring( Cast ( P.AcademicYear AS VARCHAR) , 3, 4) = CalDP.AcademicYear 
      AND P.DeliveryPeriod = CalDP.AcademicMonthNumber 
) 
, cte_FirstPayment AS 
( SELECT
    P.AccountId AccountId
  , P.ApprenticeshipId ApprenticeshipId
  , MIN(CollectionDate) MinCollectionPeriod
  , MIN(DeliveryDate) MinDeliveryPeriod
  , 1 AS Flag_FirstPayment 
  FROM cte_Payment AS P 
  GROUP BY P.AccountId, P.ApprenticeshipId
) 
'
-- Insert
SET @vsql2='
        INSERT INTO  dbo.Payments_SS
		  ([PaymentId]
           ,[UkPrn]
           ,[Uln]
           ,[EmployerAccountId]
		   ,DasAccountId
		   ,CommitmentID
		   ,DeliveryMonth
		   ,DeliveryYear
		   ,CollectionMonth
		   ,CollectionYear
		   ,EvidenceSubmittedOn
		   ,EmployerAccountVersion
		   ,ApprenticeshipVersion
		   ,FundingSource
		   ,FundingAccountId
		   ,TransactionType
		   ,Amount
		   ,StdCode
		   ,FworkCode
		   ,ProgType
		   ,PwayCode
		   ,ContractType
		   ,UpdateDateTime
		   ,UpdateDate
		   ,Flag_Latest
		   ,Flag_FirstPayment
		   ,PaymentAge
		   ,PaymentAgeBand
		   ,DeliveryMonthShortNameYear
		   ,DASAccountName
		   ,CollectionPeriodName
		   ,CollectionPeriodMonth
		   ,CollectionPeriodYear
          )
'
-- Main Select
SET @VSQL3 = '
SELECT 
    CAST( P.PaymentId AS nvarchar(100) )                              AS PaymentID  
  , P.UKprn                                                           AS UKPRN 
  , P.LearnerUln                                                      AS ULN 
  , CAST(P.AccountId AS nvarchar(100) )                               AS EmployerAccountID 
  , Acct.HashedId                                                     AS DasAccountId 
  , P.ApprenticeshipId                                                AS CommitmentID 
  , P.DeliveryMonth                                                   AS DeliveryMonth 
  , P.DeliveryYear                                                    AS DeliveryYear 
  , P.CollectionPeriodMonth                                           AS CollectionMonth 
  , P.CollectionPeriodYear                                            AS CollectionYear 
  , P.EvidenceSubmittedOn                                             AS EvidenceSubmittedOn 
  , CAST( NULL AS nvarchar(50) )                                      AS EmployerAccountVersion 
  , CAST( NULL AS nvarchar(50) )                                      AS ApprenticeshipVersion 
	, CAST( COALESCE(FS.FieldDesc,''Unknown'') AS nvarchar(25) )        AS FundingSource
  , CASE
      WHEN P.FundingSource = 5 THEN EAT.SenderAccountId
      ELSE NULL
    END                                                               AS FundingAccountId
	, CAST( COALESCE(TT.FieldDesc,''Unknown'') AS nvarchar(50) )        AS TransactionType
  , P.Amount                                                          AS Amount
  , P.StdCode
  , P.FworkCode
  , P.ProgType
  , P.PwayCode
  , CAST(NULL AS NVARCHAR(50))                                        AS ContractType 
  , EvidenceSubmittedOn                                               AS UpdateDateTime 
  , CAST(EvidenceSubmittedOn AS DATE)                                 AS UpdateDate
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
    END                                                                AS PaymentAgeBand 
  , P.DeliveryMonthShortNameYear 
  , Acct.Name                                                          AS DASAccountName 
  , P.CollectionPeriodName 
  , P.CollectionPeriodMonth
  , P.CollectionPeriodYear
'
-- Joins
SET @VSQL4 = '
FROM cte_Payment P 
LEFT JOIN Acct.Ext_Tbl_Account Acct ON Acct.Id = P.AccountId
LEFT JOIN cte_Transfers EAT ON P.ApprenticeshipId = EAT.ApprenticeshipId 
LEFT JOIN cte_FirstPayment FP
  ON FP.AccountId = P.AccountId 
    AND FP.ApprenticeshipId = P.ApprenticeshipId 
    AND FP.MinCollectionPeriod = P.CollectionDate 
    AND FP.MinDeliveryPeriod = P.DeliveryDate 		
LEFT JOIN cte_Comt C ON c.id = p.ApprenticeshipId
LEFT JOIN dbo.ReferenceData TT
  ON TT.FieldValue = P.TransactionType
    AND TT.FieldName = ''TransactionType''
    AND TT.Category = ''Payments''
LEFT JOIN dbo.ReferenceData FS
  ON FS.FieldValue=P.FundingSource
    AND FS.FieldName=''FundingSource''
    AND FS.Category=''Payments''
'

EXEC (@vsql1+@vsql2+@vsql3+@vsql4)
 
 
 /* Update Log Execution Results as Success if the query ran succesfully*/

UPDATE Mgmt.Log_Execution_Results
   SET Execution_Status=1
      ,EndDateTime=getdate()
	  ,FullJobStatus='Pending'
 WHERE LogId=@LogID
   AND RunID=@RunId

 
END TRY

BEGIN CATCH
    IF @@TRANCOUNT>0
	ROLLBACK TRANSACTION

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
	    'ImportPaymentsSnapshot',
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
