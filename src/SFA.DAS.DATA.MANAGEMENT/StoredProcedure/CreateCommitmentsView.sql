CREATE PROCEDURE [dbo].[CreateCommitmentsView]
(
   @RunId int
)
AS
-- =========================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 15/08/2019
-- Description: Create Views for Commitments that mimics RDS Commitments
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
	   ,'CreateCommitmentsView'
	   ,getdate()
	   ,0

  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
   WHERE StoredProcedureName='CreateCommitmentsView'
     AND RunId=@RunID


DECLARE @VSQL1 VARCHAR(MAX)
DECLARE @VSQL2 VARCHAR(MAX)
DECLARE @VSQL3 VARCHAR(MAX)
DECLARE @VSQL4 VARCHAR(MAX)

SET @VSQL1='
if exists(select 1 from sys.views where name=''Das_Commitments'' and type=''v'')
Drop View Data_Pub.Das_Commitments
'
SET @VSQL2='
CREATE VIEW [Data_Pub].[Das_Commitments]
	AS 
SELECT [C].[ID] AS ID
	   , CAST([C].ID AS BIGINT) AS EventID
	   , CASE WHEN A.PaymentStatus=''0'' THEN ''PendingApproval''
	          WHEN A.PaymentStatus=''1'' THEN ''Active''
			  WHEN A.PaymentStatus=''2'' THEN ''Paused''
			  WHEN A.PaymentStatus=''3'' THEN ''Withdrawn''
			  WHEN A.PaymentStatus=''4'' THEN ''Completed''
			  WHEN A.PaymentStatus=''5'' THEN ''Deleted''
			  ELSE ''Unknown''
		  END AS PaymentStatus
	   , CAST(A.ID as bigint) AS CommitmentId
	   , CASE WHEN  A.AgreementStatus= ''3''
				THEN ''BothAgreed''
	       WHEN C.EditStatus = ''1''
				THEN ''EmployerAgreed''
		   WHEN C.EditStatus = ''2''
		        THEN ''ProviderAgreed''
		   ELSE ''NotAgreed''
		   END as AgreementStatus
		,C.ProviderId as UKPRN
		,A.ULN as ULN
		,C.ProviderId as ProviderId
		,A.ULN as LearnerId
		,C.EmployerAccountId as EmployerAccountID
		,Acc.HashedId as DasAccountID  
		,CASE WHEN A.TrainingType=0  THEN ''Standard''
		      WHEN A.TrainingType=1 THEN ''Framework''
			  ELSE ''Unknown''
			  END  as TrainingTypeID
		, A.TrainingCode As TrainingID
'
SET @VSQL3='
		, CASE
	      WHEN [A].[TrainingType] = 0  AND ISNUMERIC(A.TrainingCode) = 1
	      THEN CAST(A.TrainingCode AS INT)
	      ELSE ''-1''
	       END AS [StdCode]
	    , CASE
	      WHEN A.TrainingType = 1
	          AND CHARINDEX(''-'', [A].[TrainingCode]) <> 0 -- This to fix the issues when standard codes are being recorded as Frameworks
	      THEN CAST(SUBSTRING([A].[TrainingCode], 1, CHARINDEX(''-'', [A].[TrainingCode])-1) AS INT)
	      ELSE ''-1''
	       END AS [FworkCode]
	    , CASE
	      WHEN A.TrainingType = 1 
	          AND CHARINDEX(''-'',  [A].[TrainingCode]) <> 0 -- This to fix the issues when standard codes are being recorded as Frameworks
	      THEN CAST(SUBSTRING(SUBSTRING([A].[TrainingCode], CHARINDEX(''-'',[A].[TrainingCode])+1, LEN([A].[TrainingCode])), 1, CHARINDEX(''-'', SUBSTRING([A].[TrainingCode], CHARINDEX(''-'',[A].[TrainingCode])+1, LEN([A].[TrainingCode])))-1) AS INT)
	      ELSE ''-1''
	       END AS [ProgType]
	   , CASE
	      WHEN A.TrainingType = 1 
	      THEN CAST(SUBSTRING(SUBSTRING([A].[TrainingCode], CHARINDEX(''-'', [A].[TrainingCode])+1, LEN( [A].[TrainingCode])), CHARINDEX(''-'', SUBSTRING([A].[TrainingCode], CHARINDEX(''-'', [A].[TrainingCode])+1, LEN( [A].[TrainingCode])))+1, LEN(SUBSTRING([A].[TrainingCode], CHARINDEX(''-'',[A].[TrainingCode])+1, LEN( [A].[TrainingCode])))) AS INT)
	      ELSE ''-1''
	       END AS [PwayCode]
	   , CAST([a].[StartDate] AS DATE) AS TrainingStartDate
	   , CAST([a].[EndDate] AS DATE) AS TrainingEndDate
	   , C.TransferSenderId as TransferSenderAccountId
	   , C.TransferApprovalStatus as TransferApprovalStatus
	   , C.TransferApprovalActionedOn as TransferApprovalDate
	   , A.Cost as TrainingTotalCost
	   , GETDATE() AS UpdatedDateTime
	   , CAST(GETDATE() AS Date) as UpdatedDate
	   , 1 AS Flag_Latest
	   , CAST(C.LegalEntityID AS VARCHAR(50)) AS LegalEntityCode
	   , CAST(C.LegalEntityName as varchar(100)) AS LegalEntityName
	   , CASE WHEN C.LegalEntityOrganisationType =1 THEN ''CompaniesHouse''
	          WHEN C.LegalEntityOrganisationType=2 THEN ''Charities''
			  WHEN C.LegalEntityOrganisationType=3 THEN ''Public Bodies''
			  ELSE ''Other''
		  END as LegalEntitySource
	   , CAST(COALESCE(LE.ID,-1) AS BIGINT) AS DasLegalEntityId 
	   , CAST(A.DateOfBirth as DATE) as DateOfBirth
	   , CASE WHEN [a].[DateOfBirth] IS NULL	THEN - 1
		      WHEN DATEPART([M], [a].[DateOfBirth]) > DATEPART([M], [a].[StartDate])
			    OR DATEPART([M], [a].[DateOfBirth]) = DATEPART([M], [a].[StartDate])
			   AND DATEPART([DD], [a].[DateOfBirth]) > DATEPART([DD], [a].[StartDate])
			  THEN DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate]) - 1
		      ELSE DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate])
		END AS [CommitmentAgeAtStart]
'
SET @VSQL4=
'	   , CASE WHEN P.TotalAmount>0 THEN ''Yes'' ELSE ''No'' END AS RealisedCommitment
	   , CASE 
		 WHEN CASE 
				WHEN [a].[DateOfBirth] IS NULL
					THEN - 1
				WHEN DATEPART([M], [a].[DateOfBirth]) > DATEPART([M], [a].[StartDate])
					OR DATEPART([M], [a].[DateOfBirth]) = DATEPART([M], [a].[StartDate])
					AND DATEPART([DD], [a].[DateOfBirth]) > DATEPART([DD], [a].[StartDate])
					THEN DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate]) - 1
				ELSE DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate])
				END BETWEEN 0
				AND 18
			THEN ''16-18''
		ELSE ''19+''
		END AS [CommitmentAgeAtStartBand]
		--,RealisedCommitment
		, CASE 
		  WHEN [a].[StartDate] BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
				AND DATEADD(dd, - 1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
		  THEN ''Yes''
		  ELSE ''No''
		END AS StartDateInCurrentMonth
		--,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AS [Start day of current month]
		--,DATEADD(dd, - 1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) AS [Last day of current month]
		, CASE WHEN A.AgreementStatus=0 THEN 1
		       WHEN A.AgreementStatus=1 THEN 2
			   WHEN A.AgreementStatus=2 THEN 3
			   WHEN A.AgreementStatus=3 THEN 4
			   ELSE 9
			   END AS [AgreementStatus_SortOrder]
		, CASE WHEN A.PaymentStatus=0 THEN 1
		       WHEN A.PaymentStatus=1 THEN 2
			   WHEN A.PaymentStatus=2 THEN 3
			   WHEN A.PaymentStatus=3 THEN 4
			   WHEN A.PaymentStatus=4 THEN 5
			   WHEN A.PaymentStatus=5 THEN 6
			   ELSE 9
			   END AS [PaymentStatus_SortOrder]
		, C.LegalEntityName as DASAccountName
		, CASE WHEN A.AgreementStatus=3 THEN ''Yes''
		       ELSE ''No''
			   END as FullyAgreedCommitment
	    , C.LegalEntityAddress as LegalEntityRegisteredAddress
FROM [Comt].[Ext_Tbl_Commitment] C 
LEFT JOIN [Comt].[Ext_Tbl_Apprenticeship] A
  ON C.Id=A.CommitmentId
LEFT JOIN [Comt].[Ext_Tbl_Accounts] Acc
  ON Acc.Id=c.EmployerAccountId
LEFT JOIN [Acct].[Ext_Tbl_LegalEntity] LE
  ON LE.Code=c.LegalEntityId
LEFT JOIN (SELECT P.ApprenticeshipId 
        ,SUM(P.Amount) as TotalAmount
        FROM Fin.Ext_Tbl_Payment P
	   inner join
	        (select P.AccountId
	               ,P.ApprenticeshipId as CommitmentId
		           ,P.DeliveryPeriodMonth
		           ,P.DeliveryPeriodYear
		           ,MAX(CAST(P.CollectionPeriodYear AS VARCHAR(255)) + ''-'' + CAST(P.CollectionPeriodMonth AS VARCHAR(255))) AS Max_CollectionPeriod
		           ,1 AS Flag_Latest
	           from Fin.Ext_Tbl_Payment p
	          group by
	                P.AccountId
		           ,P.ApprenticeshipId 
		           ,P.DeliveryPeriodMonth
		           ,P.DeliveryPeriodYear
	         ) as LP ON LP.AccountId=P.AccountId
	                AND LP.CommitmentId=P.ApprenticeshipId
			        AND LP.DeliveryPeriodMonth=P.DeliveryPeriodMonth
			        AND LP.DeliveryPeriodYear=P.DeliveryPeriodYear
			        AND LP.Max_CollectionPeriod=(CAST(P.CollectionPeriodYear as VARCHAR(255))+''-''+ CAST(P.CollectionPeriodMonth AS VARCHAR(255)))
	      GROUP BY P.ApprenticeshipId) P on P.ApprenticeshipId=A.ID
'

EXEC @VSQL1
EXEC (@VSQL2+@VSQL3+@VSQL4)

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
	    'CreateCommitmentsView',
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


		  

