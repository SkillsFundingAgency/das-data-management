CREATE VIEW [ASData_PL].[DAS_SpendControlNonLevy_V2]
	AS
		SELECT 
		 COALESCE(Account.EmployerAccountId, -1)                                   AS EmployerAccountId
		,COALESCE(Account.DasAccountId, 'XXXXXX')                                  AS DasAccountId
		,CAST(COALESCE(Account.DasAccountName, 'NA') AS NVARCHAR(100))             AS DasAccountName		
		,CAST(COALESCE(Account.LegalEntityName,'NA') AS NVARCHAR(100))             AS LegalEntityName
		,COALESCE(Account.LegalEntityCreatedDate, '9999-12-31')                    AS AccountLegalEntityCreatedDate   
		,COALESCE(CONVERT(VARCHAR(255), Reservation.Id), 'NA')                     AS ReservationId                              
		,CASE 
			WHEN Reservation.IslevyAccount = '1' THEN 'Yes' 
			WHEN Reservation.IslevyAccount = '0' THEN 'No'
			ELSE 'NA'
		END                                                                        AS ReservationIsLevyAccount 
		,COALESCE(Reservation.CreatedDate, '9999-12-31')                           AS ReservationCreatedDate 
		,COALESCE(Reservation.StartDate, '9999-12-31')                             AS ReservationStartDate 
		,COALESCE(Reservation.ExpiryDate, '9999-12-31')                            AS ReservationExpiryDate 
		,CASE 
			WHEN Reservation.Status = '0' THEN 'Pending'
			WHEN Reservation.Status = '1' THEN 'Confirmed'
			WHEN Reservation.Status = '2' THEN 'Completed'
			WHEN Reservation.Status = '3' THEN 'Deleted'
			ELSE 'NA'
		END                                                                         AS ReservationStatus 
		,COALESCE(Reservation.Courseid, 'NA')                                       AS ReservationCourseId 
		,COALESCE(Course.Title, 'NA')                                               AS CourseTitle 
		,COALESCE(Course.Level, -1)                                                 AS CourseLevel 
		,COALESCE(Apprenticeship.Commitmentid, -1)                                  AS ApprenticeshipCommitmentId
		,COALESCE(Apprenticeship.Id, -1)                                            AS ApprenticeshipId 
		,COALESCE(Apprenticeship.CreatedOn, '9999-12-31')                           AS ApprenticeshipCreatedOn 
		,COALESCE(Apprenticeship.StartDate, '9999-12-31')                           AS ApprenticeshipStartDate 
		,COALESCE(Apprenticeship.TrainingType, -1)                                  AS ApprenticeshipTrainingType 
		,COALESCE(Apprenticeship.TrainingName, 'NA')                                AS ApprenticeshipTrainingName 
		,COALESCE(Apprenticeship.TrainingCode, 'NA')                                AS ApprenticeshipTrainingCode 
		,COALESCE(Apprenticeship.IsApproved, -1)                                    AS ApprenticeshipIsApproved 
		,COALESCE(Apprenticeship.AgreedOn, '9999-12-31')                            AS ApprenticeshipAgreedOn 
		,Apprenticeship.Cost                                                        AS ApprenticeshipAgreedCost
		,COALESCE(Reservation.ProviderId, -1)                                       AS ReservationByEmployerOrProvider
		,COALESCE(Commitment.ProviderId, -1)                                        AS CommitmentProviderId
		 -- ,COALESCE(Commitment.ProviderName, 'NA')                               AS CommitmentProviderName
		,COALESCE(TP.Name, 'NA')                                                   AS CommitmentProviderName                           
		,COALESCE(RD.FieldDesc,'NA')                                               AS ApprenticeshipAgreementStatus
		,CAST(CASE WHEN Apprenticeship.PaymentStatus='0' THEN 'PendingApproval'
						   WHEN Apprenticeship.PaymentStatus='1' THEN 'Active'
						   WHEN Apprenticeship.PaymentStatus='2' THEN 'Paused'
						   WHEN Apprenticeship.PaymentStatus='3' THEN 'Withdrawn'
						   WHEN Apprenticeship.PaymentStatus='4' THEN 'Completed'
						   WHEN Apprenticeship.PaymentStatus='5' THEN 'Deleted'
						   ELSE 'Unknown'
					   END AS Varchar(50))                                           AS ApprenticeshipPaymentStatus
		,COALESCE(CONVERT(VARCHAR(255), Payment.PaymentId), 'NA')					 AS PaymentId
		,COALESCE(Payment.PeriodEnd, 'NA')											 AS PaymentPeriodEnd
		,COALESCE(RDFS.FieldDesc, 'NA')                                              AS PaymentFundingSource
		,COALESCE(RDTT.FieldDesc, 'NA')                                              AS PaymentTransactionType
		,COALESCE(Payment.ApprenticeshipId, -1)                                      AS PaymentApprenticeshipId
		,Payment.Amount                                                              AS PaymentAmount
		FROM (
				SELECT 
					[Id],[IsLevyAccount],[CreatedDate],[StartDate],[ExpiryDate],
					[Status],[CourseId],[ProviderId],
					[AccountId],[AccountLegalEntityId]
				FROM ASData_PL.Resv_Reservation
			    WHERE YEAR(CreatedDate) > = 2020
				AND IsLevyAccount = 0
			  ) Reservation
		LEFT 
		JOIN (
			   SELECT Acct.Id as EmployerAccountId
					 ,Acct.HashedId as DasAccountId
					 ,ALE.Id as DasLegalEntityId
					 ,ALE.Created as LegalEntityCreatedDate
					 ,acct.Name as DasAccountName
					 ,ale.Name as LegalEntityName
				FROM ASData_PL.Acc_Account Acct
				JOIN ASData_PL.Acc_AccountLegalEntity ALE
				  ON Acct.Id=ale.AccountId
				) Account
		  ON Account.EmployerAccountId=Reservation.AccountId
		 AND Account.DasLegalEntityId=Reservation.AccountLegalEntityId
		LEFT 
		JOIN ASData_PL.Resv_Course Course 
		  ON Course.CourseId = Reservation.CourseId 
		LEFT 
		JOIN ASData_PL.Comt_Apprenticeship Apprenticeship
		  ON Apprenticeship.ReservationId = Reservation.Id
		LEFT 
		JOIN ASData_PL.Fin_Payment Payment
		  ON Payment.ApprenticeshipId = Apprenticeship.Id 
		LEFT 
		JOIN ASData_PL.Comt_Commitment Commitment
		  ON Commitment.Id = Apprenticeship.CommitmentId
		LEFT 
		JOIN dbo.ReferenceData RDFS
		  ON RDFS.Category='Payments'
		 AND RDFS.FieldName='FundingSource'
		 AND RDFS.FieldValue=Payment.FundingSource
		LEFT 
		JOIN dbo.ReferenceData RDTT
		  ON RDTT.Category='Payments'
		 AND RDTT.FieldName='TransactionType'
		 AND RDTT.FieldValue=Payment.TransactionType
		LEFT 
		JOIN dbo.ReferenceData RD
		  ON RD.Category='Commitments'
		 AND RD.FieldName='Approvals'
		 AND RD.FieldValue=Commitment.Approvals 
		 LEFT JOIN ASData_PL.Comt_Providers TP
		 ON  Commitment.ProviderId = TP.UKPRN
		GO