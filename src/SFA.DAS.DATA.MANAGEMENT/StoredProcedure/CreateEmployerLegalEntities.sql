CREATE PROCEDURE [dbo].[CreateEmployerLegalEntitiesView]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Simon Heath
-- Create Date: 01/10/2019
-- Description: Create Views for EmployerLegalEntities that mimics RDS view
-- ===============================================================================

BEGIN TRY

DECLARE @LogID int
DEClARE @Quote varchar(5) = ''''

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
	   ,'CreateEmployerLegalEntitiesView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateEmployerLegalEntitiesView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''DAS_Employer_LegalEntities'')
Drop View Data_Pub.DAS_Employer_LegalEntities
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[DAS_Employer_LegalEntities]	AS 
SELECT 
      ISNULL(CAST(ale.LegalEntityId * 10 as bigint),-1)                                                 AS Id
	, ISNULL(CAST(a.HashedId as nvarchar(100)),'+@Quote+'XXXXXX'+@Quote+')                              AS DasAccountId
	, CAST(ale.LegalEntityId AS bigint)                                                                 AS DasLegalEntityId
	, CAST(ale.Name as nvarchar(100))                                                                   AS LegalEntityName
	, CAST(ale.Address as nvarchar(256))                                                                as LegalEntityRegisteredAddress
    , CAST(Mgmt.fn_ExtractPostCodeUKFromAddress(UPPER( ale.Address)) as Varchar(8))                     AS LegalEntityRegisteredAddressPostcode
  -- DO we need a valid postcode field
	, CAST((CASE 
            WHEN le.Source = 3 THEN ' + @Quote + 'Public Body' + @Quote + '
			WHEN le.Source = 1 THEN ' + @Quote + 'Companies House' + @Quote + '
	        WHEN le.Source = 2 THEN ' + @Quote + 'Charities' + @Quote + '
			WHEN le.Source = 5 THEN ' + @Quote + 'Pensions Regulator' + @Quote + '
	        ELSE ' + @Quote + 'Other' + @Quote + '
	        END) AS NVARCHAR(50))                                                                       AS LegalEntitySource 
  -- Additional Columns for InceptionDate represented as a Date
   , CAST(le.DateOfIncorporation AS DATE)                                                               AS LegalEntityCreatedDate
	-- Column Renamed as has DateTime
	, le.DateOfIncorporation                                                                            AS LegalEntityCreatedDateTime
	, CAST(le.Code as nvarchar(50))                                                                     AS LegalEntityNumber 
	, CAST((CASE
	    WHEN le.Source = 3 THEN le.Code 
		  ELSE '  + @Quote + @Quote + '
    END) AS NVARCHAR(50))                                                                               AS LegalEntityCompanyReferenceNumber
	, CAST((CASE
		  WHEN  le.Source = 2  THEN le.Code     
      ELSE ' + @Quote + @Quote + '
	  END) AS nvarchar(50))                                                                             AS LegalEntityCharityCommissionNumber
  , CAST((CASE
          WHEN (isnumeric(le.Code) = 1) THEN CAST( ' + @Quote + 'active' + @Quote + ' AS NVARCHAR )
          ELSE null 
          END) AS nvarchar(50))                                                                         AS  LegalEntityStatus 
	, CAST((CASE
		  -- Other also flag to Red
		  WHEN le.Source not in (3,1,2,5) THEN ' + @Quote + 'Red' + @Quote + ' 
		  -- Charity commission always flag to Green
		  WHEN le.Source = 2 THEN 
        ( CASE 
            WHEN  le.Code  IS NULL OR  le.Code  = ' + @Quote + '0' + @Quote + ' THEN ' + @Quote + 'Red' + @Quote + ' 
            ELSE ' + @Quote + 'Green' + @Quote + ' 
          END
        ) 
		  -- When company if first to charactors are text then flag as Amber else green
		  WHEN le.Source = 1  THEN -- Companies House
			( CASE 
				  WHEN  le.Code  IS NULL OR  le.Code  = '  + @Quote + '0'  + @Quote + ' THEN '  + @Quote +  'Red'  + @Quote + '
				  WHEN ISNUMERIC(LEFT( le.Code ,2)) <> 1 THEN '  + @Quote + 'Amber'  + @Quote + '
				  ELSE ' + @Quote + 'Green'  + @Quote + '
			  END
      )
		  -- Public Sector always set to Amber
		  WHEN le.Source = 3  THEN ' + @Quote + 'Amber'  + @Quote + ' -- Public Bodies
		  ELSE ' + @Quote + 'ERROR'  + @Quote + '
	 END) AS Varchar(5))                                                                                 AS LegalEntityRAGRating
	, ISNULL(CASE 
             WHEN isnull( ale.Deleted,convert(datetime, ' + @Quote + '01 Jan 1900' + @Quote + ' )) > ale.Created THEN ale.Deleted
	         ELSE ale.Created
	          END,'+@Quote+'9999-12-31'+@Quote+')                                                        AS  UpdateDateTime
	-- Additional Columns for UpdateDateTime represented as a Date
	, CASE 
      WHEN isnull( ale.Deleted,convert(datetime, ' + @Quote + '01 Jan 1900' + @Quote + ' )) > ale.Created THEN Convert(DATE, ale.Deleted)
	    ELSE Convert(DATE, ale.Created)
	  END                                                                                                AS  UpdateDate
	-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
	, ISNULL((Cast( 1 AS BIT )),-1)                                                                      As Flag_Latest
FROM Acct.Ext_Tbl_Account a
JOIN Acct.Ext_Tbl_AccountLegalEntity ale ON a.ID = ale.AccountID
LEFT JOIN Acct.Ext_Tbl_LegalEntity le ON ale.LegalEntityID = le.ID
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
	    'CreateEmployerLegalEntitiesView',
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
