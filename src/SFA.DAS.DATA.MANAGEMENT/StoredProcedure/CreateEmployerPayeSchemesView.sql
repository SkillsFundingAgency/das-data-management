CREATE PROCEDURE [dbo].[CreateEmployerPAYESchemesView]
(
   @RunId int
)
AS
-- ===========================================================================
-- Author:      Simon Heath
-- Create Date: 16/09/2019
-- Description: Create Views for EmployerPAYESchemes that mimics RDS view
-- ===========================================================================

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
	   ,'CreateEmployerPAYESchemesView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerPAYESchemesView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_PAYESchemes'')
Drop View Data_Pub.DAS_Employer_PAYESchemes
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_PayeSchemes]	AS 
SELECT ISNULL(CAST(ah.Id as bigint),-1)                                                                         as Id
, ISNULL(CAST(a.HashedId as nvarchar(100)),''XXXXXX'')                                                          as DasAccountId 
, HASHBYTES(''SHA2_512'',ah.PayeRef)                                                                            AS PAYEReference
, Cast( p.Name AS nvarchar(100))                                                                                as PAYESchemeName
, ISNULL(Cast(ah.AddedDate AS DateTime),''9999-12-31'')                                                         as AddedDate
, ah.RemovedDate                                                                                                as RemovedDate
, ISNULL(CASE -- make up a last changed date from added/removed.
    WHEN ah.RemovedDate > ah.AddedDate THEN ah.RemovedDate
    ELSE ah.AddedDate 
  END,''9999-12-31'')                                                                                           AS UpdateDateTime
, CASE -- make up a last changed date from added/removed.
    WHEN ah.RemovedDate > ah.AddedDate THEN Cast ( ah.RemovedDate as DATE ) 
    ELSE Cast ( ah.AddedDate AS DATE ) 
  END                                                                                                           AS UpdateDate
, ISNULL(CASE  -- work out IsLatest as the views that reference this view select out the islatest = 1 
    WHEN RANK () OVER (PARTITION BY a.ID, AH.PayeRef ORDER BY ah.RemovedDate DESC, ah.AddedDate DESC ) = 1 THEN Cast(1 AS BIT ) 
    ELSE Cast ( 0 AS BIT ) 
    END,-1)                                                                                                     AS Flag_Latest
FROM Acct.Ext_Tbl_Account a
INNER JOIN Acct.Ext_Tbl_AccountHistory ah ON a.Id = ah.AccountID
INNER JOIN Acct.Ext_Tbl_Paye p ON ah.PayeRef = p.Ref
'
-- SET @VSQL3='  '
-- SET @VSQL4='  '

EXEC SP_EXECUTESQL @VSQL1 -- run check to drop view if it exists. 
EXEC (@VSQL2) -- run sql to create view. 
-- +@VSQL3+@VSQL4) -- no 3 or 4 as small view. 

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
	    'CreateEmployerPAYESchemesView',
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


	