CREATE VIEW [Pds_AI].[PT_B]
	AS 
SELECT DISTINCT 
       Apprenticeship.Id                                  AS B1								
      ,COALESCE(Apprenticeship.CreatedOn, '9999-12-31') AS B2
      ,COALESCE(Course.Level, -1)                         AS B3 
      ,COALESCE(Apprenticeship.StartDate, '9999-12-31') AS B4 
      ,COALESCE(Apprenticeship.TrainingType, -99999)      AS B5
      ,case when trainingtype=1 then ao2.[ApprenticeshipOccupationId]	 
            else ao.[ApprenticeshipOccupationId]	 
        end                                               AS B6
      ,case when pay.amount>0 then 1 
            else 0 
        end                                               AS B7
      ,COALESCE(Apprenticeship.isapproved, -1)	          AS B8
      ,COALESCE(Apprenticeship.Cost, '-99999')	      AS B9
      ,Commitment.EmployerAccountId                       AS B10
      ,convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(Commitment.ProviderId , skl.SaltKey)))),2) AS B11
      ,CASE WHEN COMMITMENT.[TransferSenderId]IS NOT NULL THEN 1 
            ELSE 0 
        END                                               AS B12 
      ,CASE WHEN Apprenticeship.[DateOfBirth] IS NULL	THEN - 1
		    WHEN DATEPART([M], [Apprenticeship].[DateOfBirth]) > DATEPART([M], [Apprenticeship].[StartDate])
	     	  OR DATEPART([M], [Apprenticeship].[DateOfBirth]) = DATEPART([M], [Apprenticeship].[StartDate])
			 AND DATEPART([DD], [Apprenticeship].[DateOfBirth]) > DATEPART([DD], [Apprenticeship].[StartDate])
			THEN DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate]) - 1
			ELSE DATEDIFF(YEAR, [Apprenticeship].[DateOfBirth], [Apprenticeship].[StartDate]) 
		END                                              AS B13
       ,Apprenticeship.AsDm_UpdatedDateTime              AS B14 
       ,CASE WHEN Apprenticeship.CompletionDate is not null THEN 1
             ELSE 0
         END                                             AS B15
       ,Apprenticeship.StopDate                          AS B16
       ,Apprenticeship.EndDate                           AS B17
       ,Apprenticeship.PauseDate                         AS B18
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
CROSS
JOIN       (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC ) Skl
 
--LEFT OUTER JOIN ASData_PL.Assessor_Certificates AC
--on ac.ProviderUkPrn=Commitment.ProviderId
--and ac.StandardCode=try_convert(int,Apprenticeship.TrainingCode)
--and ac.Uln=Apprenticeship.ULN
where Apprenticeship.uln is not null

		


