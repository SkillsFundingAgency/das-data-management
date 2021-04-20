CREATE VIEW [Data_Pub].[DAS_Employer_LegalEntities_V2]	
AS 
		WITH cte_EmpLEs AS
		(
		  SELECT 
						 ISNULL(CAST(ale.LegalEntityId * 10 as bigint), -1)                                                AS Id
						,ISNULL(CAST(a.HashedId as nvarchar(100)),'XXXXXX')												   AS DasAccountId
						,ISNULL(CAST(ale.LegalEntityId AS bigint), -1)                                                     AS DasLegalEntityId				
						
	                    , ISNULL(CAST(ale.Name as nvarchar(100)),'NA')                                                    AS LegalEntityName
	                    , CAST(ale.Address as nvarchar(256))                                                                as LegalEntityRegisteredAddress
                        , CAST(Mgmt.fn_ExtractPostCodeUKFromAddress(UPPER( ale.Address)) as Varchar(8))                     AS LegalEntityRegisteredAddressPostcode
						-- DO we need a valid postcode field
						, ISNULL(CAST((CASE 
								WHEN le.Source = 3 THEN 'Public Body'
								WHEN le.Source = 1 THEN 'Companies House'
								WHEN le.Source = 2 THEN 'Charities'
								WHEN le.Source = 5 THEN 'Pensions Regulator'
								ELSE 'Other'
								END) AS NVARCHAR(50)),'NA')																	 AS LegalEntitySource 
						-- Additional Columns for InceptionDate represented as a Date
						, CAST(le.DateOfIncorporation AS DATE)                                                               AS LegalEntityCreatedDate
						-- Column Renamed as has DateTime
						, le.DateOfIncorporation                                                                             AS LegalEntityCreatedDateTime
						, CAST(le.Code as nvarchar(50))                                                                      AS LegalEntityNumber 
						, CAST((CASE
						WHEN le.Source = 3 THEN le.Code 
						ELSE ''
						END) AS NVARCHAR(50))																				 AS LegalEntityCompanyReferenceNumber
						, CAST((CASE
						WHEN  le.Source = 2  THEN le.Code     
						ELSE ''
						END) AS nvarchar(50))																				 AS LegalEntityCharityCommissionNumber
						,CAST((CASE
						WHEN (isnumeric(le.Code) = 1) THEN CAST( 'active' AS NVARCHAR )
						ELSE null 
						END) AS nvarchar(50))																				 AS  LegalEntityStatus 
						, ISNULL(CAST((CASE
						-- Other also flag to Red
						WHEN le.Source not in (3,1,2,5) THEN 'Red' 
						-- Charity commission always flag to Green
						WHEN le.Source = 2 THEN 
						( CASE 
						WHEN  le.Code  IS NULL OR  le.Code  = '0' THEN 'Red' 
						ELSE 'Green' 
						END
						) 
						-- When company if first to charactors are text then flag as Amber else green
						WHEN le.Source = 1  THEN -- Companies House
						( CASE 
								WHEN  le.Code  IS NULL OR  le.Code  = '0' THEN 'Red'
								WHEN ISNUMERIC(LEFT( le.Code ,2)) <> 1 THEN 'Amber'
								ELSE 'Green'
							END
						)
						-- Public Sector always set to Amber
						WHEN le.Source = 3  THEN 'Amber' -- Public Bodies
						ELSE 'ERROR'
						END) AS Varchar(5)),'NA')                                                                         AS LegalEntityRAGRating
						, ISNULL(CASE 
							WHEN isnull(ale.Deleted,convert(datetime, '01 Jan 1900' )) > ale.Created THEN ale.Deleted
							ELSE ale.Created
							END, '9999-12-31' )																			  AS  UpdateDateTime
						-- Additional Columns for UpdateDateTime represented as a Date
						, CASE 
						WHEN isnull( ale.Deleted,convert(datetime, '01 Jan 1900' )) > ale.Created THEN Convert(DATE, ale.Deleted)
						ELSE Convert(DATE, ale.Created)
						END                                                                                                AS  UpdateDate
						-- Flag to say if latest record from subquery, Using Coalesce to set null value to 0
						, ISNULL((Cast( 1 AS BIT )),-1)                                                                    As Flag_Latest
						, ROW_NUMBER() OVER ( PARTITION BY LegalEntityId, HashedId ORDER BY LegalEntityId, HashedId, 
						CASE  WHEN isnull( ale.Deleted,convert(datetime, '01 Jan 1900' )) > ale.Created 
						THEN Convert(DATE, ale.Deleted) ELSE Convert(DATE, ale.Created) END desc) AS RowNumber
						, convert(bit, a.ApprenticeshipEmployerType)                                                        as ApprenticeshipEmployerType
				FROM [ASData_PL].[Acc_Account] a
				JOIN [ASData_PL].[Acc_AccountLegalEntity] ale ON a.ID = ale.AccountID
				LEFT JOIN [ASData_PL].[Acc_LegalEntity] le ON ale.LegalEntityID = le.ID
		) 
		SELECT Id ,
			   DASAccountId,
			   DasLegalEntityId,
			   LegalEntityName,
			   LegalEntityRegisteredAddress,
			   LegalEntityRegisteredAddressPostcode,
			   LegalEntitySource,
			   LegalEntityCreatedDate,
			   LegalEntityCreatedDateTime,
			   LegalEntityNumber,
			   LegalEntityCompanyReferenceNumber,
			   LegalEntityCharityCommissionNumber,
			   LegalEntityStatus,
			   LegalEntityRAGRating,
			   UpdateDateTime,
			   UpdateDate,
			   Flag_Latest,
			   ApprenticeshipEmployerType
		FROM cte_EmpLEs 
		WHERE Rownumber = 1
		GO