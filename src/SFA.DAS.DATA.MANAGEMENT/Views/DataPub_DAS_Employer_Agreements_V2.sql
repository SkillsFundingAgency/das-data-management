CREATE VIEW [Data_Pub].[DAS_Employer_Agreements_V2]	
AS 
		SELECT 
				ea.Id
			  , IsNull ( a.HashedId, 'XXXXX' )														AS DasAccountId
			  , IsNull ( eas.name, 'XXXXX' )														AS EmployerAgreementStatus
			  , IsNull( Cast ( 'Redacted' AS VARCHAR(10) ) , 'XXXXX'	 )							AS SignedBy
			  , ea.SignedDate																		AS SignedDateTime
			  , CAST( ea.SignedDate AS Date )														AS SignedDate
			  , ea.ExpiredDate																		AS ExpiredDateTime
			  , CAST( ea.ExpiredDate AS Date )														AS ExpiredDate
			  , IsNull( ale.LegalEntityId, -1)														AS DasLegalEntityId
			  , IsNull ( Cast( ale.SignedAgreementId AS NVARCHAR(100) ) 
			  , 'XXXXX'	)																			AS DasEmployerAgreementID
			  , IsNull( CAST 
				( CASE WHEN ea.ExpiredDate IS NOT NULL AND ea.ExpiredDate > ea.SignedDate 
						THEN ea.ExpiredDate
					ELSE ea.SignedDate	
				  END AS DATETIME )
				  , CAST ( '9999-12-31' AS DATETIME )
				)																					AS UpdateDateTime
			  , IsNull( CAST  
				( CASE WHEN ea.ExpiredDate IS NOT NULL AND ea.ExpiredDate > ea.SignedDate 
						THEN ea.ExpiredDate
					ELSE ea.SignedDate	
				  END AS DATE )
			  , CAST ( '9999-12-31' AS DATE )
				)																					AS UpdateDate
			  ,	IsNull ( CAST( 1 AS bit ), -1) 														AS Flag_Latest
				FROM [ASData_PL].[Acc_EmployerAgreement] ea
					LEFT OUTER JOIN [ASData_PL].[Acc_EmployerAgreementStatus] eas
						ON ea.StatusId = eas.Id
					LEFT OUTER JOIN [ASData_PL].[Acc_AccountLegalEntity] ale
					  ON ea.AccountLegalEntityId = ale.Id
					LEFT OUTER JOIN [ASData_PL].[Acc_Account] a 
					  ON ale.AccountId = a.Id
				WHERE ea.SignedDate is not null
			GO

