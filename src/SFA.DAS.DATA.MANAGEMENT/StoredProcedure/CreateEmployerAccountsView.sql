CREATE PROCEDURE [dbo].[CreateEmployerAccountsView]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Simon Heath
-- Create Date: 02/10/2019
-- Description: Create Views for EmployerAccounts that mimics RDS view
-- ===============================================================================

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
	   ,'Step-4'
	   ,'CreateEmployerAccountsView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerAccountsView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_Accounts'')
Drop View Data_Pub.DAS_Employer_Accounts
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_Accounts]	AS
SELECT	 isnull(a.Id * 100,-1) as Id
	,	isnull(a.HashedId,' + @Quote +' XXXXXX' + @Quote + ') AS DasAccountID
	,   a.Id AS EmployerAccountID
	,	a.Name as DASAccountName
	,	Convert(DATE,a.CreatedDate) AS DateRegistered
	,	a.CreatedDate AS DateTimeRegistered
	--Owner Email Address suppressed for Data Protection reasons
	,	' + @Quote + 'Suppressed'  + @Quote + ' AS OwnerEmail
	, , ISNULL(ISNULL(ModifiedDate,CreatedDate),' + @Quote +'9999-12-31' +@Quote+') UpdateDateTime
	-- Additional Columns for UpdateDateTime represented as a Date
	,	ISNULL(ISNULL( Convert(DATE,ModifiedDate), Convert(DATE,CreatedDate)),' + @Quote +'9999-12-31' +@Quote+') UpdateDate
	-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
	,  ISNULL(Cast( 1 AS BIT ),-1) as Flag_Latest
	--Count of currrent PAYE Schemes
     , isnull(eps.CountOfCurrentPAYESchemes, 0) AS CountOfCurrentPAYESchemes
	--Count of currrent Legal Entities
     , isnull(ele.CountOfCurrentLegalEntities, 0) AS CountOfCurrentLegalEntities
FROM  Acct.Ext_Tbl_Account a
-- Adding Current number of PAYE Schemes
LEFT JOIN 
( SELECT
	  eps.DASAccountID
	, COUNT(*) AS CountOfCurrentPAYESchemes
  FROM Data_Pub.DAS_Employer_PayeSchemes eps
	--Checking if the PAYE Schemes are valid when the view runs using 31 DEC 2999 as default removed date if null
	WHERE GETDATE() BETWEEN eps.AddedDate AND isnull(eps.RemovedDate,' + @Quote + '31 DEC 2999' + @Quote + ')
	GROUP BY eps.DASAccountId
) eps
ON a.HashedId = eps.DASAccountId
-- Adding Current number of LegalEntities
LEFT JOIN
( SELECT ele.DASAccountId
  , Count(*) AS CountOfCurrentLegalEntities
FROM      
    Data_Pub.DAS_Employer_LegalEntities ele
GROUP BY ele.DASAccountID
) ele
ON a.HashedId  = ele.DASAccountId
'
-- SET @VSQL3=' ' 
-- SET @VSQL4=' ' 

EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
EXEC (@VSQL2) -- run sql to create view. 
-- +@VSQL3+@VSQL4) -- no 3 or 4 

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
	    'CreateEmployerAccountsView',
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
