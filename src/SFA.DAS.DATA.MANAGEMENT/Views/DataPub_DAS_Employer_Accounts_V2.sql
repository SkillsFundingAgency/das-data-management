CREATE VIEW [Data_Pub].[DAS_Employer_Accounts_V2]	
AS
		SELECT	isnull(CAST(a.Id * 100 as bigint),-1)													as Id
			,	isnull(CAST(a.HashedId AS nvarchar(100)),'XXXXXX')										as DasAccountId
			,   isnull(CAST(a.Id as bigint),-1)															as EmployerAccountId
			,	'Suppressed'																			as DASAccountName
			,	Convert(DATE,a.CreatedDate)																as DateRegistered
			,	ISNULL(CAST(a.CreatedDate as DateTime),'9999-12-31')									as DateTimeRegistered
			--Owner Email Address suppressed for Data Protection reasons
			,	ISNULL(CAST('Suppressed' AS Varchar(10)),'NA')											as OwnerEmail
			,  ISNULL(ISNULL(ModifiedDate,CreatedDate),'9999-12-31')									as UpdateDateTime
			-- Additional Columns for UpdateDateTime represented as a Date
			,	ISNULL(ISNULL( Convert(DATE,ModifiedDate), Convert(DATE,CreatedDate)),'9999-12-31')		as UpdateDate
			-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
			,  ISNULL(Cast( 1 AS BIT ),-1)																as Flag_Latest
			--Count of currrent PAYE Schemes
			 , isnull(eps.CountOfCurrentPAYESchemes, 0)													as CountOfCurrentPAYESchemes
			--Count of currrent Legal Entities
			 , isnull(ele.CountOfCurrentLegalEntities, 0)												as CountOfCurrentLegalEntities
		FROM [ASData_PL].[Acc_Account] a
		-- Adding Current number of PAYE Schemes
		LEFT JOIN 
		( 
				SELECT
				  eps.DASAccountID
				,COUNT(*) AS CountOfCurrentPAYESchemes
				FROM Data_Pub.DAS_Employer_PayeSchemes_v2 eps
				--Checking if the PAYE Schemes are valid when the view runs using 31 DEC 2999 as default removed date if null
				WHERE GETDATE() BETWEEN eps.AddedDate AND isnull(eps.RemovedDate,'31 DEC 2999')
				GROUP BY eps.DASAccountId
		) eps
		ON a.HashedId = eps.DASAccountId
		-- Adding Current number of LegalEntities
		LEFT JOIN
		( 
			SELECT ele.DASAccountId
				  ,Count(*) AS CountOfCurrentLegalEntities
			FROM      
			Data_Pub.DAS_Employer_LegalEntities_v2 ele
			GROUP BY ele.DASAccountID
		) ele
		ON a.HashedId  = ele.DASAccountId
		GO

