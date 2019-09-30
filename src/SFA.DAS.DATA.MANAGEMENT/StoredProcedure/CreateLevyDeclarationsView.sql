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
SELECT  LD.[Id]                                                              AS ID
      , EA.HashedId                                                          AS DASAccountID
      , LD.ID                                                                AS LevyDeclarationID              
      , HASHBYTES(''SHA2_512'',RTRIM(LTRIM(CAST(LD.empRef AS VARCHAR(20))))) AS PAYEReference
      , LD.LevyDueYTD                                                        AS LevyDueYearToDate
      , LD.[LevyAllowanceForYear]                                            AS LevyAllowanceForYear
      , LD.[SubmissionDate]                                                  AS SubmissionDateTime
      , CAST(LD.[SubmissionDate] AS DATE)                                    AS SubmissionDate
      , LD.[SubmissionId]                                                    AS SubmissionID
      , LD.[PayrollYear]                                                     AS PayrollYear
      , LD.[PayrollMonth]                                                    AS PayrollMonth
      , LD.[CreatedDate]                                                     AS CreatedDateTime
      , CAST(LD.CreatedDate AS DATE)                                         AS CreatedDate
      , LD.[EndOfYearAdjustment]                                             AS EndOfYearAdjustment
      , LD.[EndOfYearAdjustmentAmount]                                       AS EndOfYearAdjustmentAmount
      , LD.[DateCeased]                                                      AS DateCeased
      , LD.[InactiveFrom]                                                    AS InactiveFrom
      , LD.[InactiveTo]                                                      AS InactiveTo
      , LD.[HmrcSubmissionId]                                                AS HMRCSubmissionID
      , LD.[EnglishFraction]                                                 AS EnglishFraction
      , LD.[TopupPercentage]                                                 AS TopUpPercentage
      , TopUp                                                                AS TopUpAmount
      , LD.CreatedDate                                                       AS UpdatedDateTime
	 -- Additional Columns for UpdateDateTime represented as a Date
      ,	CAST(LD.CreatedDate AS DATE)                                         AS UpdateDate
	-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
      , 1                                                                    AS  Flag_Latest
	  , CM.CalendarMonthShortNameYear                                        AS PayrollMonthShortNameYear 
      , LD.LevyDeclaredInMonth                                               AS LevyDeclaredInMonth
      , LD.TotalAmount                                                       AS LevyAvailableInMonth                            
      , LD.LevyDeclaredInMonth * LD.EnglishFraction                          AS LevyDeclaredInMonthWithEnglishFractionApplied
  FROM fin.ext_tbl_getlevydeclarationandtopup AS LD
    LEFT JOIN acct.Ext_Tbl_Account EA 
           ON EA.ID=LD.AccountId
	LEFT JOIN dbo.DASCalendarMonth AS CM 
	       ON LD.PayrollYear = CM.TaxYear AND LD.PayrollMonth = CM.TaxMonthNumber
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


		  

