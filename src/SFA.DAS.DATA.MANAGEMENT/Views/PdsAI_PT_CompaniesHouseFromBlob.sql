CREATE VIEW [Pds_AI].[PT_J]
	AS
SELECT CompanyNumber                                                                            AS J1
		,FORMAT(PERCENT_RANK() OVER ( 
                                ORDER BY convert(decimal(18,5),CurrentAssets) asc),'P0')        AS J2
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),DirectorRemuneration) asc),'P0') AS J3
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),EmployeesTotal) asc),'P0')       AS J4
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),GrossProfitLoss) asc),'P0')      AS J5
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),IntangibleAssets) asc),'P0')     AS J6
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),NetAssetsLiabilities) asc),'P0') AS J7
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),OperatingProfitLoss) asc),'P0')  AS J8
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),ProfitLoss) asc),'P0')           AS J9
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),ProfitLossOnOrdinaryActivitiesAfterTax) asc),'P0') AS J10
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),ProfitLossOnOrdinaryActivitiesBeforeTax) asc),'P0') AS J11
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),TotalAssetsLessCurrentLiabilities) asc),'P0') AS J12
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),TotalLiabilities) asc),'P0')                  AS J13
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),TurnoverRevenue) asc),'P0')                   AS J14
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),WagesSalaries) asc),'P0')                     AS J15
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),AmountSpecificBankLoan) asc),'P0')            AS J16
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),BankBorrowings) asc),'P0')                   AS J17
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),Creditors) asc),'P0')                        AS J18
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),DeferredTaxLiabilities) asc),'P0')          AS J19
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),FinishedGoodsGoodsForResale) asc),'P0')     AS J20
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),GovernmentGrantIncome) asc),'P0')           AS J21
				   
				   
			       ,FORMAT(PERCENT_RANK() OVER (
                                ORDER BY convert(decimal(18,5),ValueaddedTaxPayable) asc),'P0')          AS J22

  FROM ASData_PL.Cmphs_CompaniesHouseDataFromBlob
