CREATE PROCEDURE [dbo].[ImportVacanciesCandidateDetailsToPL]
(
   @RunId int
)
AS
-- ===============================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 02/07/2020
-- Description: Import and Integrate Vacancies Candidate Details from FAA, RAA and AVMS Dbs
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
	   ,'Step-6'
	   ,'ImportVacanciesCandidateDetailsToPL'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='ImportVacanciesCandidateDetailsToPL'
     AND RunId=@RunID

BEGIN TRANSACTION

DELETE FROM ASData_PL.Va_CandidateDetails

IF OBJECT_ID(N'tempdb..#tRAAv2Eth') IS NOT NULL
BEGIN
DROP TABLE #tRAAv2Eth
END

/* Bring the Derived Code and Actual Code for Eth */
SELECT ELookUp.FullName,EDerived.ShortCode,EDerived.NID
  INTO #tRAAv2Eth
  FROM (SELECT FullName, ROW_NUMBER() OVER (PARTITION BY SourceDb Order By SourceSK) RN
	      FROM dbo.CandidateEthLookUp
	     WHERE SourceDb='RAAv2') ELookUp
  JOIN (SELECT CA.NID,CC.ShortCode,CC.SourceDb
	          ,row_number() over (partition by CC.SourceDb order by Cast(replace(CC.ShortCode,'''null''',-1) as int)) rn
	      FROM (SELECT *,row_number() over (partition by sourcedb ORDER BY CAID) RN
	              FROM Stg.CopyActivity
		         WHERE SourceDb='RAAv2'
		           AND Category='Eth'
			       AND RunId=(SELECT MAX(RunId) FROM Stg.CopyActivity)) CA
	      JOIN (SELECT *,row_number() over (partition by sourcedb ORDER BY sourcesk) RN
	              FROM Stg.CandidateConfig
		         WHERE SourceDb='RAAv2'
		           AND Category='Ethnicity') CC
	        ON CA.RN=CC.RN
	       AND CA.RunId=CC.RunId
         )EDerived
	ON ELookUp.rn=EDerived.rn

/* Insert Candidate Ethnicity Details to Presentation Layer Table */

IF ((SELECT COUNT(*) FROM #tRAAv2Eth) > 0)
BEGIN
INSERT INTO [ASData_PL].[Va_CandidateDetails]
           (
		    [CandidateId] 
           ,[CandidateEthnicCode] 
           ,[CandidateEthnicDesc] 
           ,[SourceDb] 
		   )
SELECT VC.CandidateId
      ,ETH.ShortCode
	  ,ETH.FullName
	  ,'FAA'
  FROM Stg.FAA_CandidateDetails FCD
  JOIN ASData_PL.Va_Candidate VC
    ON VC.CandidateGuid=FCD.CandidateId
   AND VC.SourceDb='RAAv2'
  LEFT
  JOIN #tRAAv2Eth Eth
    ON FCD.EID=Eth.NID
END
ELSE RAISERROR( 'Ethnicity Lookup for RAAv2 is empty',1,1)


/* RAAv1(AVMS) Candidate Eth Details */

IF OBJECT_ID(N'tempdb..#tRAAv1Eth') IS NOT NULL
BEGIN
DROP TABLE #tRAAv1Eth
END

/* Bring the Derived Code and Actual Code for Eth */
SELECT ELookUp.FullName,EDerived.ShortCode,EDerived.NID
  INTO #tRAAv1Eth
  FROM (SELECT FullName, ROW_NUMBER() OVER (PARTITION BY SourceDb Order By SourceSK) RN
	      FROM dbo.CandidateEthLookUp
	     WHERE SourceDb='RAAv1') ELookUp
  JOIN (SELECT CA.NID,CC.ShortCode,CC.SourceDb
	          ,row_number() over (partition by CC.SourceDb order by Cast(replace(CC.ShortCode,'''null''',-1) as int)) rn
	      FROM (SELECT *,row_number() over (partition by sourcedb ORDER BY CAID) RN
	              FROM Stg.CopyActivity
		         WHERE SourceDb='RAAv1'
		           AND Category='Eth'
			       AND RunId=(SELECT MAX(RunId) FROM Stg.CopyActivity)) CA
	      JOIN (SELECT *,row_number() over (partition by sourcedb ORDER BY sourcesk) RN
	              FROM Stg.CandidateConfig
		         WHERE SourceDb='RAAv1'
		           AND Category='Ethnicity') CC
	        ON CA.RN=CC.RN
	       AND CA.RunId=CC.RunId
         )EDerived
	ON ELookUp.rn=EDerived.rn

/* Insert Candidate Ethnicity Details for RAAv1(AVMS) from FAA and RAAv1(AVMS) to Presentation Layer Table */

IF ((SELECT COUNT(*) FROM #tRAAv1Eth) > 0)
BEGIN
INSERT INTO [ASData_PL].[Va_CandidateDetails]
           (
		    [CandidateId] 
           ,[CandidateEthnicCode] 
           ,[CandidateEthnicDesc] 
           ,[SourceDb] 
		   )
SELECT VC.CandidateId
      ,ETH.ShortCode
	  ,ETH.FullName
	  ,'RAAv1'
  FROM Stg.Avms_CandidateDetails ACD
  JOIN ASData_PL.Va_Candidate VC
    ON VC.SourceCandidateId_v1=ACD.CandidateId
   AND VC.SourceDb='RAAv1'
  LEFT
  JOIN #tRAAv1Eth Eth
    ON ACD.EID=Eth.NID
 UNION
SELECT VC.CandidateId
      ,ETH.ShortCode
	  ,ETH.FullName
	  ,'FAA'
  FROM Stg.FAA_CandidateDetails FCD
  JOIN ASData_PL.Va_Candidate VC
    ON VC.SourceCandidateId_v1=FCD.LegacyCandidateId
   AND VC.SourceDb='RAAv1'
  LEFT
  JOIN #tRAAv2Eth Eth
    ON FCD.EID=Eth.NID
END
ELSE RAISERROR( 'Ethnicity Lookup for RAAv1 is empty',1,1)
   

     
COMMIT TRANSACTION



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
	    'ImportVacanciesCandidateToPL',
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
