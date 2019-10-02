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
	   ,'CreateEmployerLegalEntitiesView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='EmployerLegalEntitiesView'
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
    b.LegalEntityId * 10  AS Id
	, a.HashedId AS DASAccountID
	, b.LegalEntityId AS DasLegalEntityID
	, b.Name AS LegalEntityName
	, b.Address as  LegalEntityRegisteredAddress
  , Mgmt.fn_ExtractPostCodeUKFromAddress(UPPER(b.Address)) AS LegalEntityRegisteredAddressPostcode
  -- DO we need a valid postcode field
	, CASE 
      WHEN c.OrganisationType = 3 THEN ' + @quote + 'Public Body' + @quote + '
			WHEN c.OrganisationType = 1 THEN ' + @quote + 'Companies House' + @quote + '
	    WHEN c.OrganisationType = 2 THEN ' + @quote + 'Charities' + @quote + '
			WHEN c.OrganisationType = 5 THEN ' + @quote + 'Pensions Regulator' + @quote + '
	    ELSE ' + @quote + 'Other' + @quote + '
	  END LegalEntitySource 
  -- Additional Columns for InceptionDate represented as a Date
	, b.Created AS LegalEntityCreatedDate  
	-- Column Renamed as has DateTime
	, b.Created   AS LegalEntityCreatedDateTime 
	, x.LegalEntityID AS LegalEntityNumber 
	, CASE
	    WHEN c.OrganisationType = 3 THEN  x.LegalEntityID 
		  ELSE '  + @QUOTE + @QUOTE + '
    END AS LegalEntityCompanyReferenceNumber
	, CASE
		  WHEN  c.OrganisationType = 2  THEN x.LegalEntityID     
      ELSE ' + @QUOTE + @QUOTE + '
	  END AS LegalEntityCharityCommissionNumber
  , CASE
      WHEN (isnumeric(x.LegalEntityID) = 1) THEN ' + @QUOTE + 'active' + @QUOTE + '
      ELSE null 
    END  AS  LegalEntityStatus 
	, CASE
		  -- Other also flag to Red
		  WHEN c.OrganisationType not in (3,1,2,5) THEN ' + @QUOTE + 'Red' + @QUOTE + ' 
		  -- Charity commission always flag to Green
		  WHEN c.OrganisationType = 2 THEN 
        ( CASE 
            WHEN  x.LegalEntityID  IS NULL OR  x.LegalEntityID  = ' + @QUOTE + '0' + @QUOTE + ' THEN ' + @QUOTE + 'Red' + @QUOTE + ' 
            ELSE ' + @QUOTE + 'Green' + @QUOTE + ' 
          END
        ) 
		  -- When company if first to charactors are text then flag as Amber else green
		  WHEN c.OrganisationType = 1  THEN -- Companies House
			( CASE 
				  WHEN  x.LegalEntityID  IS NULL OR  x.LegalEntityID  = '  + @QUOTE + '0'  + @QUOTE + ' THEN '  + @QUOTE +  'Red'  + @QUOTE + '
				  WHEN ISNUMERIC(LEFT( x.LegalEntityID ,2)) <> 1 THEN '  + @QUOTE + 'Amber'  + @QUOTE + '
				  ELSE ' + @QUOTE + 'Green'  + @QUOTE + '
			  END
      )
		  -- Public Sector always set to Amber
		  WHEN c.OrganisationType = 3  THEN ' + @QUOTE + 'Amber'  + @QUOTE + ' -- Public Bodies
		  ELSE ' + @QUOTE + 'ERROR'  + @QUOTE + '
	 END AS LegalEntityRAGRating
	, CASE 
      WHEN isnull(b.Deleted,convert(datetime, ' + @QUOTE + '01 Jan 1900' + @QUOTE + ' )) > b.Created THEN b.Deleted
	    ELSE b.Created
	  END  AS  UpdateDateTime
	-- Additional Columns for UpdateDateTime represented as a Date
	, CASE 
      WHEN isnull(b.Deleted,convert(datetime, ' + @Quote + '01 Jan 1900' + @quote + ' )) > b.Created THEN Convert(DATE,b.Deleted)
	    ELSE Convert(DATE,b.Created)
	  END  AS  UpdateDate
	-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
	, 1 As Flag_latest
FROM Acct.Ext_Tbl_Account a
JOIN Acct.Ext_Tbl_AccountLegalEntity b ON a.ID = b.AccountID
LEFT JOIN 
( SELECT  DISTINCT Name, Address, OrganisationType
	FROM Comt.Ext_Tbl_AccountLegalEntities
) c ON (b.Name = c.Name AND b.Address= c.Address)
LEFT JOIN 
( SELECT * FROM 
	( SELECT  LegalEntityId ,
		Name,
		Address,
		Row_number() over (partition by Name , Address ORDER BY LegalEntityID) as RowNumber
		FROM Comt.Ext_Tbl_AccountLegalEntities
    WHERE LegalEntityId > ' + @QUOTE + @QUOTE + '
	) d
  WHERE RowNumber = 1
) x ON (b.Name = x.Name AND b.Address= x.Address)
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
