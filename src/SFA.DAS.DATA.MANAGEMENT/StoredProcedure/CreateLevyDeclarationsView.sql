CREATE PROCEDURE [dbo].[CreateLevyDeclarationsView]
(
   @RunId int
)
AS
-- ================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 24/09/2019
-- Description: Create Views for LevyDeclarations that mimics RDS LevyDeclarations
-- ================================================================================

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
	   ,'CreateLevyDeclarationsView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateLevyDeclarationsView'
     AND RunId=@RunID


DECLARE @VSQL1 NVARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(SELECT 1 from INFORMATION_SCHEMA.VIEWS where TABLE_NAME=''Das_LevyDeclarations'')
Drop View Data_Pub.Das_LevyDeclarations
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[Das_LevyDeclarations]
	AS 
SELECT  ISNULL(CAST(LD.[Id] AS bigint),-1)                                   AS ID
      , ISNULL(CAST(EA.HashedId as nvarchar(100)),''XXXXXX'')                AS DASAccountID
      , ISNULL(CAST(LD.ID as bigint),-1)                                     AS LevyDeclarationID              
      , HASHBYTES(''SHA2_512'',RTRIM(LTRIM(CAST(LD.empRef AS VARCHAR(20))))) AS PAYEReference
      , CAST(LD.LevyDueYTD AS decimal(18,5))                                 AS LevyDueYearToDate
      , CAST(LD.[LevyAllowanceForYear] as decimal(18,5))                     AS LevyAllowanceForYear
      , LD.[SubmissionDate]                                                  AS SubmissionDateTime
      , CAST(LD.[SubmissionDate] AS DATE)                                    AS SubmissionDate
      , ISNULL(CAST(LD.[SubmissionId] as bigint),-1)                         AS SubmissionID
      , ISNULL(CAST(LD.[PayrollYear] as nvarchar(10)),-1)                    AS PayrollYear
      , ISNULL(CAST(LD.[PayrollMonth] as tinyint),0)                         AS PayrollMonth
      , ISNULL(LD.[CreatedDate],''9999-12-31'')                              AS CreatedDateTime
      , CAST(LD.CreatedDate AS DATE)                                         AS CreatedDate
      , ISNULL(LD.[EndOfYearAdjustment],-1)                                  AS EndOfYearAdjustment
      , CAST(LD.[EndOfYearAdjustmentAmount] as Decimal(18,5))                AS EndOfYearAdjustmentAmount
      , LD.[DateCeased]                                                      AS DateCeased
      , LD.[InactiveFrom]                                                    AS InactiveFrom
      , LD.[InactiveTo]                                                      AS InactiveTo
      , LD.[HmrcSubmissionId]                                                AS HMRCSubmissionID
      , ISNULL(CAST(LD.[EnglishFraction] as decimal(18,5)),-1)               AS EnglishFraction
      , ISNULL(CAST(LD.[TopupPercentage] as decimal(18,5)),-1)               AS TopUpPercentage
      , ISNULL(CAST(TopUp as decimal(18,5)),-1)                              AS TopUpAmount
      , ISNULL(LD.CreatedDate,''9999-12-31'')                                AS UpdatedDateTime
	 -- Additional Columns for UpdateDateTime represented as a Date
      ,	CAST(LD.CreatedDate AS DATE)                                         AS UpdateDate
	-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
      , ISNULL(CAST(1 as Bit),-1)                                            AS  Flag_Latest
	  , cast(CM.CalendarMonthShortNameYear AS Varchar(20))                   AS PayrollMonthShortNameYear 
      , Cast(LD.LevyDeclaredInMonth AS decimal(18,5))                        AS LevyDeclaredInMonth
      , Cast(LD.TotalAmount as Decimal(18,5))                                AS LevyAvailableInMonth                            
      , cast(LD.LevyDeclaredInMonth * LD.EnglishFraction as decimal(37,10))  AS LevyDeclaredInMonthWithEnglishFractionApplied
  FROM fin.ext_tbl_getlevydeclarationandtopup AS LD
    LEFT JOIN acct.Ext_Tbl_Account EA 
           ON EA.ID=LD.AccountId
	LEFT JOIN dbo.DASCalendarMonth AS CM 
	       ON LD.PayrollYear = CM.TaxYear AND LD.PayrollMonth = CM.TaxMonthNumber
 WHERE LD.LastSubmission=1
'


EXEC SP_EXECUTESQL @VSQL1
EXEC (@VSQL2)

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
	    'CreateLevyDeclarationsView',
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


		  

