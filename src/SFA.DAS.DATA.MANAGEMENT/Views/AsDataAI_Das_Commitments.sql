CREATE VIEW [AsData_AI].[DAS_Commitments]
	AS 
SELECT DISTINCT 
       Apprenticeship.Id                                  AS A1								
      ,COALESCE(Apprenticeship.CreatedOn, '9999-12-31') AS A2
      ,COALESCE(Course.Level, -1)                         AS A3 
      ,COALESCE(Apprenticeship.StartDate, '9999-12-31') AS A4 
      ,COALESCE(Apprenticeship.TrainingType, -99999)      AS A5
      ,case when trainingtype=1 then ao2.[ApprenticeshipOccupationId]	 
            else ao.[ApprenticeshipOccupationId]	 
        end                                               AS A6
      ,case when pay.amount>0 then 1 
            else 0 
        end                                               AS A7
      ,COALESCE(Apprenticeship.isapproved, -1)	          AS A8
      ,COALESCE(Apprenticeship.Cost, '-99999')	      AS A9
      ,Commitment.EmployerAccountId                       AS A10
      ,convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(Commitment.ProviderId , skl.SaltKey)))),2) AS A11
      ,CASE WHEN COMMITMENT.[TransferSenderId]IS NOT NULL THEN 1 
            ELSE 0 
        END                                               AS A12 
      ,CASE WHEN Apprenticeship.[DateOfBirth] IS NULL	THEN - 1
		    WHEN DATEPART([M], [Apprenticeship].[DateOfBirth]) > DATEPART([M], [Apprenticeship].[StartDate])
	     	  OR DATEPART([M], [Apprenticeship].[DateOfBirth]) = DATEPART([M], [Apprenticeship].[StartDate])
			 AND DATEPART([DD], [Apprenticeship].[DateOfBirth]) > DATEPART([DD], [Apprenticeship].[StartDate])
			THEN DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate]) - 1
			ELSE DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate]) 
		END                                              AS A13
       ,Apprenticeship.AsDm_UpdatedDateTime              AS A14 
--,COALESCE(ac.OverallGrade,''N/A'') AS OverallGrade	Would be included later if needed
FROM		ASData_PL.Comt_Apprenticeship Apprenticeship
LEFT
JOIN        AsData_PL.Comt_Commitment Commitment
  ON        Commitment.Id = Apprenticeship.CommitmentId
LEFT 
JOIN        ASData_PL.Resv_Course Course
  ON        Course.CourseId =Apprenticeship.[TrainingCode]
LEFT
JOIN       (SELECT LearnerULN,SUM(AMOUNT) as Amount from StgPmts.Payment  GROUP BY LearnerULN) Pay
  ON        Pay.LearnerUln =Apprenticeship.Uln
LEFT 
JOIN        ASData_PL.Va_ApprenticeshipStandard ast
  ON        left(Apprenticeship.trainingcode,3)= ast.larscode
LEFT 
JOIN        Stg.Avms_ApprenticeshipOccupation ao
  on       ast.ApprenticeshipOccupationId=ao.ApprenticeshipOccupationId
LEFT
JOIN       [ASData_PL].[Va_ApprenticeshipFrameWorkAndOccupation] afwk
  ON       CAST(left(Apprenticeship.trainingcode,3) AS NVARCHAR(50)) = cast (afwk.[FrameworkCodeName] AS NVARCHAR(50))
LEFT
JOIN       Stg.Avms_ApprenticeshipOccupation ao2
  on       afwk.ApprenticeshipOccupationId=ao2.ApprenticeshipOccupationId
LEFT
JOIN       Mgmt.SaltKeyLog SKL 
  ON       SourceType ='EmployerReference'
 AND       convert(date,SKL.CreatedDateTime)=convert(date,apprenticeship.AsDm_UpdatedDateTime)  

--LEFT OUTER JOIN ASData_PL.Assessor_Certificates AC
--on ac.ProviderUkPrn=Commitment.ProviderId
--and ac.StandardCode=try_convert(int,Apprenticeship.TrainingCode)
--and ac.Uln=Apprenticeship.ULN
where Apprenticeship.uln is not null

		


