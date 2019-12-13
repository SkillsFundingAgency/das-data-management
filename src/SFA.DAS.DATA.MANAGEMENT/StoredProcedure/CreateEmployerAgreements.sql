CREATE PROCEDURE [dbo].[CreateEmployerAgreementsView]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Simon Heath
-- Create Date: 02/12/2019
-- Description: Create Views for EmployerAgreements that mimics RDS view
-- ===============================================================================

BEGIN TRY

DECLARE @LogID int
DECLARE @Quote varchar(5) = ''''

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
	   ,'CreateEmployerAgreementsView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerAgreementsView'
     AND RunId=@RunID

DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)


SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_Agreements'')
Drop View Data_Pub.DAS_Employer_Agreements
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_Agreements]	AS 
SELECT 
    ea.Id
  , IsNull ( a.HashedId, ' + @Quote + 'XXXXX' + @Quote + ' )	AS DasAccountId
  , IsNull ( eas.name, ' + @Quote + 'XXXXX' + @Quote + ' )		AS EmployerAgreementStatus
  , IsNull( Cast ( ' + @Quote + 'Suppressed' + @Quote +  ' AS VARCHAR(10) ) , ' 
       + @Quote + 'XXXXX' + @Quote + '	 )							AS SignedBy
  , ea.SignedDate															AS SignedDateTime
	, CAST( ea.SignedDate AS Date )									AS SignedDate
  , ea.ExpiredDate															AS ExpiredDateTime
	, CAST( ea.ExpiredDate AS Date )									AS ExpiredDate
	, IsNull( ale.LegalEntityId, -1)										AS DasLegalEntityId
    , IsNull ( Cast( ale.SignedAgreementId AS NVARCHAR(100) ) 
		, ' + @Quote + 'XXXXX' + @Quote + '	)						AS DasEmployerAgreementID
	, IsNull( CAST 
	( CASE WHEN ea.ExpiredDate IS NOT NULL AND ea.ExpiredDate > ea.SignedDate 
			THEN ea.ExpiredDate
		ELSE ea.SignedDate	
	  END AS DATETIME )
	  , CAST ( ' + @Quote + '9999-12-31' + @Quote + ' AS DATETIME )
	)																			AS UpdateDateTime
	, IsNull( CAST  
	( CASE WHEN ea.ExpiredDate IS NOT NULL AND ea.ExpiredDate > ea.SignedDate 
			THEN ea.ExpiredDate
		ELSE ea.SignedDate	
	  END AS DATE )
	  , CAST ( ' + @Quote + '9999-12-31' + @Quote + ' AS DATE )
	)																			AS UpdateDate
  ,	IsNull ( CAST( 1 AS bit ), -1) 										AS Flag_Latest
FROM Acct.Ext_Tbl_EmployerAgreement ea
	LEFT OUTER JOIN Acct.Ext_Tbl_EmployerAgreementStatus eas
		ON ea.StatusId = eas.Id
	LEFT OUTER JOIN Acct.Ext_Tbl_AccountLegalEntity ale
	  ON ea.AccountLegalEntityId = ale.Id
	LEFT OUTER JOIN Acct.Ext_Tbl_Account a 
	  ON ale.AccountId = a.Id
WHERE ea.SignedDate is not null
'
;

EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
EXEC (@VSQL2) -- run sql to create view. 


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
	    'CreateEmployerAgreementsView',
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
