CREATE VIEW [Data_Pub].[DAS_Commitments_V2]
	AS 
	SELECT [C].[ID]																							as ID
		   , CAST([C].ID AS BIGINT)																			as EventID
		   , CAST(CASE WHEN A.PaymentStatus='0' THEN 'PendingApproval'
					   WHEN A.PaymentStatus='1' THEN 'Active'
					   WHEN A.PaymentStatus='2' THEN 'Paused'
					   WHEN A.PaymentStatus='3' THEN 'Withdrawn'
					   WHEN A.PaymentStatus='4' THEN 'Completed'
					   WHEN A.PaymentStatus='5' THEN 'Deleted'
					   ELSE 'Unknown'
				   END AS Varchar(50))																		as PaymentStatus
		   , CAST(A.ID as bigint)																			as CommitmentID
		   , CAST(RD.FieldDesc AS Varchar(50))																as AgreementStatus
			,CAST(C.ProviderId as bigint)																	as UKPRN
			,CAST(isnull(A.ULN,-2) as bigint)																as ULN
			,CAST(C.ProviderId as Varchar(255))																as ProviderID
			,CAST(A.ULN as varchar(255))																	as LearnerID
			,CAST(C.EmployerAccountId as Varchar(255))														as EmployerAccountID
			,CAST(Acc.HashedId as Varchar(100))																as DasAccountId  
			,CAST(CASE WHEN A.TrainingType=0  THEN 'Standard'
				  WHEN A.TrainingType=1 THEN 'Framework'
				  ELSE 'Unknown'
				  END AS Varchar(255))																		as TrainingTypeID
			,CAST(A.TrainingCode AS VARCHAR(255))															as TrainingID
			, CASE
			  WHEN [A].[TrainingType] = 0  AND ISNUMERIC(A.TrainingCode) = 1
			  THEN CAST(A.TrainingCode AS INT)
			  ELSE '-1'
			   END																							as [StdCode]
			, CASE
			  WHEN A.TrainingType = 1
				  AND CHARINDEX('-', [A].[TrainingCode]) <> 0 
			  THEN CAST(SUBSTRING([A].[TrainingCode], 1, CHARINDEX('-', [A].[TrainingCode])-1) AS INT)
			  ELSE '-1'
			   END																							as [FworkCode]
			, CASE
			  WHEN A.TrainingType = 1 
				  AND CHARINDEX('-',  [A].[TrainingCode]) <> 0 
			  THEN CAST(SUBSTRING(SUBSTRING([A].[TrainingCode], CHARINDEX('-',[A].[TrainingCode])+1, LEN([A].[TrainingCode])), 1, CHARINDEX('-', SUBSTRING([A].[TrainingCode], CHARINDEX('-',[A].[TrainingCode])+1, LEN([A].[TrainingCode])))-1) AS INT)
			  ELSE '-1'
			   END																							as [ProgType]
		   , CASE
			  WHEN A.TrainingType = 1 
			  THEN CAST(SUBSTRING(SUBSTRING([A].[TrainingCode], CHARINDEX('-', [A].[TrainingCode])+1, LEN( [A].[TrainingCode])), CHARINDEX('-', SUBSTRING([A].[TrainingCode], CHARINDEX('-', [A].[TrainingCode])+1, LEN( [A].[TrainingCode])))+1, LEN(SUBSTRING([A].[TrainingCode], CHARINDEX('-',[A].[TrainingCode])+1, LEN( [A].[TrainingCode])))) AS INT)
			  ELSE '-1'
			   END																							as [PwayCode]
		   , CAST([a].[StartDate] AS DATE)																	as TrainingStartDate
		   , CAST([a].[EndDate] AS DATE)																	as TrainingEndDate
		   , CAST(C.TransferSenderId AS bigint)																as TransferSenderAccountId
		   , Convert(nvarchar(50), 
		   CASE WHEN TransferApprovalStatus is null 
							  THEN null
				WHEN TransferApprovalStatus = '0'
								THEN 'Pending'
							WHEN TransferApprovalStatus = '1'
								THEN 'TransferApproved'
							WHEN  TransferApprovalStatus = '2'
								THEN 'TransferRejected'
					END )																					as TransferApprovalStatus
		   , CAST(C.TransferApprovalActionedOn AS DateTime)													as TransferApprovalDate
		   , CAST(A.Cost as decimal(18,0))																	as TrainingTotalCost
		   , CAST(GETDATE() AS DateTime)																	as UpdateDateTime
		   , CAST(GETDATE() AS Date)																		as UpdateDate
		   , ISNULL(CAST(1 AS BIT),-1)																		as Flag_Latest
     	   , CAST(le.code AS VARCHAR(50))																	as LegalEntityCode	
		   , CAST(AcctLE.Name  as varchar(100))                                                             AS LegalEntityName
		   , CAST((CASE WHEN LE.Source = 1 THEN 'CompaniesHouse'
					  WHEN LE.Source = 2 THEN 'Charities'
					  WHEN LE.Source = 3  THEN 'Public Bodies'
					  ELSE 'Other'
				  END) AS Varchar(20))																		as LegalEntitySource
		   ,CAST(COALESCE(LE.ID,-1) AS BIGINT)																as DasLegalEntityId 	   
		   ,cast('9999-12-31'  as date) 																	as DateOfBirth
			,A.Age																							as Age
		   , CASE WHEN [a].[DateOfBirth] IS NULL	THEN - 1
				  WHEN DATEPART([M], [a].[DateOfBirth]) > DATEPART([M], [a].[StartDate])
					OR DATEPART([M], [a].[DateOfBirth]) = DATEPART([M], [a].[StartDate])
				   AND DATEPART([DD], [a].[DateOfBirth]) > DATEPART([DD], [a].[StartDate])
				  THEN DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate]) - 1
				  ELSE DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate])
			END																								as [CommitmentAgeAtStart]
		   , ISNULL(CAST((CASE 
						   WHEN [a].[DateOfBirth] IS NULL THEN '- 1'
						   WHEN CASE
								WHEN DATEPART([M], [a].[DateOfBirth]) > DATEPART([M], [a].[StartDate])
								  OR DATEPART([M], [a].[DateOfBirth]) = DATEPART([M], [a].[StartDate])
								 AND DATEPART([DD], [a].[DateOfBirth]) > DATEPART([DD], [a].[StartDate])
								THEN DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate]) - 1
								ELSE DATEDIFF(YEAR, [a].[DateOfBirth], [a].[StartDate])
								 END BETWEEN 0  AND 18 
								THEN '16-18'
							ELSE '19+'
							 END) as Varchar(5)),'NA')                                                      as [CommitmentAgeAtStartBand]
		    , ISNULL(CAST((CASE WHEN P.TotalAmount>0 THEN 'Yes' ELSE 'No' END) as Varchar(3)),'NA')			as RealisedCommitment
			 , ISNULL(CAST((CASE WHEN [a].[StartDate] BETWEEN DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
								 AND DATEADD(dd, - 1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
								THEN 'Yes'
								ELSE 'No'
								 END) AS VARCHAR(3)),'NA')													as StartDateInCurrentMonth
			 , CASE WHEN C.Approvals=0 THEN 1
				   WHEN C.Approvals=1 THEN 2
				   WHEN C.Approvals=2 THEN 3
				   WHEN C.Approvals=3 THEN 4
				   WHEN C.Approvals=4 THEN 5
				   WHEN C.Approvals=7 THEN 6
				   ELSE 9
				   END																						as [AgreementStatus_SortOrder]
			 , CASE WHEN A.PaymentStatus=0 THEN 1
				   WHEN A.PaymentStatus=1 THEN 2
				   WHEN A.PaymentStatus=2 THEN 3
				   WHEN A.PaymentStatus=3 THEN 4
				   WHEN A.PaymentStatus=4 THEN 5
				   WHEN A.PaymentStatus=5 THEN 6
				   ELSE 9
				   END																						as [PaymentStatus_SortOrder]	    
			 ,  CAST(AcctLE.Name  as nvarchar(100))                                                         AS DASAccountName
			 , ISNULL(CAST((CASE WHEN C.Approvals IN (3,7) THEN 'Yes'
								ELSE 'No'
								 END) AS Varchar(3)),'NA')													as FullyAgreedCommitment
			  ,  CAST(AcctLE.Address as nvarchar(256))                                                      as LegalEntityRegisteredAddress
			  ,  CONVERT(bit, CASE WHEN  isnull(C.Approvals,'0')  IN('3','7')
								   THEN C.ApprenticeshipEmployerTypeOnApproval
							       ELSE null
							   END 
				  )                                                                                         as ApprenticeshipEmployerTypeOnApproval
              , Acc.ApprenticeshipEmployerType									                            as ApprenticeshipEmployerType
			  , ISNULL(cast(A.MadeRedundant as int),-1)														as MadeRedundant
			  , A.CreatedOn																					as CreatedOn
			  , Case when AI.[ApprenticeshipId]  IS NOT NULL Then 1  Else 0 End 							As MadeIncentiveClaim
			  , ISNULL(EIP.PaidDateCount,0)																	As PaidDateCount
			  , A.StopDate																					As StopDate
	FROM [ASData_PL].[Comt_Commitment] C 
	LEFT JOIN [ASData_PL].[Comt_Apprenticeship] A
	  ON C.Id=A.CommitmentId

	LEFT JOIN [ASData_PL].[Acc_AccountLegalEntity] AcctLE
	ON c.AccountLegalEntityId = AcctLE.ID

	LEFT JOIN [ASData_PL].[Acc_Account] Acc
	  ON Acc.Id=c.EmployerAccountId

	LEFT JOIN [ASData_PL].[Acc_LegalEntity] LE  
	  ON AcctLE.LegalEntityId = LE.id


	LEFT JOIN (SELECT P.ApprenticeshipId 
			,SUM(P.Amount) as TotalAmount
			FROM [ASData_PL].[Fin_Payment] P
		   inner join
				(select P.AccountId
					   ,P.ApprenticeshipId as CommitmentId
					   ,P.DeliveryPeriodMonth
					   ,P.DeliveryPeriodYear
					   ,MAX(CAST(P.CollectionPeriodYear AS VARCHAR(255)) + '-' + CAST(P.CollectionPeriodMonth AS VARCHAR(255))) AS Max_CollectionPeriod
					   ,1 AS Flag_Latest
				   from [ASData_PL].[Fin_Payment] p
				  group by
						P.AccountId
					   ,P.ApprenticeshipId 
					   ,P.DeliveryPeriodMonth
					   ,P.DeliveryPeriodYear
				 ) as LP ON LP.AccountId=P.AccountId
						AND LP.CommitmentId=P.ApprenticeshipId
						AND LP.DeliveryPeriodMonth=P.DeliveryPeriodMonth
						AND LP.DeliveryPeriodYear=P.DeliveryPeriodYear
						AND LP.Max_CollectionPeriod=(CAST(P.CollectionPeriodYear as VARCHAR(255))+'-'+ CAST(P.CollectionPeriodMonth AS VARCHAR(255)))
			  GROUP BY P.ApprenticeshipId) P on P.ApprenticeshipId=A.ID
	LEFT JOIN dbo.ReferenceData RD
		   ON RD.Category='Commitments'
		  AND RD.FieldName='Approvals'
		  AND RD.FieldValue=C.Approvals

	LEFT JOIN [ASData_PL].[EI_ApprenticeshipIncentive]  AI
			ON A.ID = AI.[ApprenticeshipId]

	LEFT JOIN 
			( SELECT [ApprenticeshipIncentiveId],count([PaidDate]) as PaidDateCount      
			  FROM [ASData_PL].[EI_Payment] 
			  where [PaidDate]  IS NOT NULL 
			  GROUP BY [ApprenticeshipIncentiveId] 
			) EIP ON  
			AI.ID  = EIP.[ApprenticeshipIncentiveId]
	GO