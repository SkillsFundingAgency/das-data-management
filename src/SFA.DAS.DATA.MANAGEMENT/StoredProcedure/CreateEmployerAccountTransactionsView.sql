CREATE PROCEDURE [dbo].[CreateEmployerAccountTransactionsView]
(
   @RunId int
)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/09/2019
-- Description: Create Views for EmployerAccountTransactions that mimics RDS 
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
	   ,'CreateEmployerAccountTransactionsView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerAccountTransactionsView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_AccountTransactions'')
Drop View Data_Pub.DAS_Employer_AccountTransactions
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_AccountTransactions]
	AS 
With LevyDeclarationAndTopUp
AS
(SELECT AccountId
       ,CreatedDate
	   ,SubmissionDate
	   ,PayrollMonth
	   ,PayrollYear
	   ,EnglishFraction
	   ,LevyDeclaredInMonth
	   ,TopUp
   FROM Fin.Ext_Tbl_GetLevyDeclarationAndTopUp
  WHERE LastSubmission=1
)

'
SET @VSQL3='
     SELECT   CAST(DasAccountID as nvarchar(100))                  as DasAccountId
	         ,ISNULL(CAST(CreatedDate as DateTime),''9999-12-31'') as CreatedDate
			 ,CAST(SubmissionDate as DateTime)                     as SubmissionDate
			 ,CAST(PayrollMonth as tinyint)                        as PayrollMonth
			 ,CAST(PayrollYear as nvarchar(10))                    as PayrollYear
			 ,CAST(CollectionMonth as int)                         as CollectionMonth
			 ,CAST(CollectionYear as int)                          as CollectionYear
			 ,CAST(TransactionType as nvarchar(54))                as TransactionType
			 ,Cast(Amount AS decimal(37,10))                       as Amount
	   FROM (
     SELECT    EA.HashedId AS DasAccountID
          ,    LD.CreatedDate
		  ,	   LD.SubmissionDate
		  ,    LD.PayrollMonth
		  ,    LD.PayrollYear
		  ,    NULL AS CollectionMonth
		  ,    NULL AS CollectionYear
          ,    ''IN Levy Money from HMRC'' AS TransactionType
          ,    ROUND((LD.LevyDeclaredInMonth * LD.EnglishFraction),2) AS Amount
      FROM LevyDeclarationAndTopUp AS LD
	  LEFT
	  JOIN Acct.Ext_Tbl_Account EA ON EA.Id = LD.AccountId 
     UNION ALL
       -- Top Up Amount  
    SELECT     EA.HashedId 
         ,     LD.CreatedDate
  	     ,     LD.SubmissionDate
	     ,     LD.PayrollMonth
	     ,    LD.PayrollYear
		 ,    NULL AS CollectionMonth
		 ,    NULL AS CollectionYear
         ,    ''IN Levy Top Up Amount'' AS TransactionType
         ,    ROUND(LD.TopUp,2) AS Amount
      FROM LevyDeclarationAndTopUp AS LD
	  LEFT
	  JOIN Acct.Ext_Tbl_Account EA ON EA.Id = LD.AccountId 
     UNION ALL
     -- Payments 
    SELECT    EA.HashedId AS DasAccountId
         ,    PS.EvidenceSubmittedOn AS CreatedDate
	     ,     NULL as SubmissionDate
		 ,     NULL as PayrollMonth
		 ,	   NULL as PayrollYear
	     ,     PS.CollectionPeriodMonth
		 ,     ps.CollectionPeriodYear
         ,    ''OUT''+  TT.FieldDesc   AS TransactionType
         ,    ROUND((PS.Amount*-1),2) AS Amount -- Made negative as Payment
      FROM fin.Ext_Tbl_Payment AS PS
 	  LEFT
	  JOIN dbo.ReferenceData TT
		ON TT.FieldValue=PS.TransactionType
	   AND TT.Category=''Payments''
	   AND TT.FieldName=''TransactionType''
      LEFT 
	  JOIN Acct.Ext_Tbl_Account EA ON EA.Id = [PS].AccountId 
     WHERE PS.FundingSource = 1  -- Only Month coming from balances
	 ) T
'

EXEC SP_EXECUTESQL @VSQL1
EXEC (@VSQL2+@VSQL3)

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
	    'CreateEmployerAccountTransactionsView',
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


		  

