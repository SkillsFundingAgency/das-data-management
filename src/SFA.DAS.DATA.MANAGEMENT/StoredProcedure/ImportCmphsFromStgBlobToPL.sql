
CREATE PROCEDURE [dbo].[ImportCmphsFromStgBlobToPL]
(
   @RunId int
)
AS
-- ==========================================================================================================
-- Author:      Himabindu Uddaraju
-- Create Date: 28/01/2022
-- Description: Transform and Load to PL Companies House Data that is imported from Blob to Stg.
-- ==========================================================================================================
BEGIN TRY
		DECLARE @LogID int
		DECLARE @DynSQL   NVarchar(max)
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
			   ,'ImportCmphsFromStgBlobToPL'
			   ,getdate()
			   ,0

		  SELECT @LogID=MAX(LogId) FROM Mgmt.Log_Execution_Results
		  WHERE StoredProcedureName='ImportCmphsFromStgBlobToPL'
			 AND RunId=@RunID


		/* Place Transformed data into Staging Table */
		    
			IF OBJECT_ID(N'tempdb..#StgChData') IS NOT NULL
            BEGIN
            DROP TABLE #StgCHData
            END



			select convert(NVarchar(500),HASHBYTES('SHA2_512',LTRIM(RTRIM(CONCAT(try_convert(varchar(200),REPLICATE('0', 8-LEN(CHN)) + CHN) , skl.SaltKey)))),2) CompanyNumber
	               ,[Equity]   
	               ,CurrentAssets
			       ,DirectorRemuneration
			       ,EmployeesTotal
			       ,GrossProfitLoss
			       ,IntangibleAssets
			       ,NetAssetsLiabilities
			       ,OperatingProfitLoss
			       ,ProfitLoss
			       ,ProfitLossOnOrdinaryActivitiesAfterTax
			       ,ProfitLossOnOrdinaryActivitiesBeforeTax
			       ,TotalAssetsLessCurrentLiabilities
			       ,TotalLiabilities
			       ,TurnoverRevenue
			       ,WagesSalaries
			       ,AmountSpecificBankLoan
			       ,BankBorrowings
			       ,Creditors
			       ,DeferredTaxLiabilities
			       ,FinishedGoodsGoodsForResale
			       ,GovernmentGrantIncome
			       ,[Value-addedTaxPayable] AS [ValueaddedTaxPayable]
			       ,SourceFileName
			 into  #StgCHData
             from (select [chn],SourceFileName,[name],[value]
				          from stg.cmphsdatafromblob cdfb
						 ) cmp
                 pivot
                       (
                       MAX([VALUE])
                   for [Name] in (UKCompaniesHouseRegisteredNumber,CurrentAssets,Equity,DirectorRemuneration,EmployeesTotal,GrossProfitLoss
                                 ,IntangibleAssets,NetAssetsLiabilities,OperatingProfitLoss,ProfitLoss,ProfitLossOnOrdinaryActivitiesAfterTax
                                 ,ProfitLossOnOrdinaryActivitiesBeforeTax,TotalAssetsLessCurrentLiabilities,TotalLiabilities,TurnoverRevenue
                                 ,WagesSalaries,AmountSpecificBankLoan,BankBorrowings,Creditors,DeferredTaxLiabilities,FinishedGoodsGoodsForResale
                                 ,GovernmentGrantIncome,[Value-addedTaxPayable]
)
                       ) piv
				 CROSS
                  JOIN       (Select TOP 1 SaltKeyID,SaltKey From Mgmt.SaltKeyLog Where SourceType ='EmployerReference'  Order by SaltKeyID DESC ) Skl
		    


		             
/* Merge to PL */


				MERGE AsData_PL.Cmphs_CompaniesHouseDataFromBlob as Target
                USING #StgCHData as Source
                   ON Target.CompanyNumber=Source.CompanyNumber
				  and Target.SourceFileName=Source.SourceFileName
				WHEN MATCHED 
                THEN UPDATE SET Target.Equity=try_convert(decimal(18,5),Source.Equity)
				               ,Target.CurrentAssets=try_convert(decimal(18,5),Source.CurrentAssets)
                               ,Target.DirectorRemuneration=try_convert(decimal(18,5),Source.DirectorRemuneration)
                               ,Target.EmployeesTotal=try_convert(decimal(18,5),Source.EmployeesTotal)
                               ,Target.GrossProfitLoss=try_convert(decimal(18,5),Source.GrossProfitLoss)
                               ,Target.IntangibleAssets=try_convert(decimal(18,5),Source.IntangibleAssets)
                               ,Target.NetAssetsLiabilities=try_convert(decimal(18,5),Source.NetAssetsLiabilities)
                               ,Target.OperatingProfitLoss=try_convert(decimal(18,5),Source.OperatingProfitLoss)
                               ,Target.ProfitLoss=try_convert(decimal(18,5),Source.ProfitLoss)
                               ,Target.ProfitLossOnOrdinaryActivitiesAfterTax=try_convert(decimal(18,5),Source.ProfitLossOnOrdinaryActivitiesAfterTax)
                               ,Target.ProfitLossOnOrdinaryActivitiesBeforeTax=try_convert(decimal(18,5),Source.ProfitLossOnOrdinaryActivitiesBeforeTax)
                               ,Target.TotalAssetsLessCurrentLiabilities=try_convert(decimal(18,5),Source.TotalAssetsLessCurrentLiabilities)
                               ,Target.TotalLiabilities=try_convert(decimal(18,5),Source.TotalLiabilities)
                               ,Target.TurnoverRevenue=try_convert(decimal(18,5),Source.TurnoverRevenue)
                               ,Target.WagesSalaries=try_convert(decimal(18,5),Source.WagesSalaries)
                               ,Target.AmountSpecificBankLoan=try_convert(decimal(18,5),Source.AmountSpecificBankLoan)
                               ,Target.BankBorrowings=try_convert(decimal(18,5),Source.BankBorrowings)
                               ,Target.Creditors=try_convert(decimal(18,5),Source.Creditors)
                               ,Target.DeferredTaxLiabilities=try_convert(decimal(18,5),Source.DeferredTaxLiabilities)
                               ,Target.FinishedGoodsGoodsForResale=try_convert(decimal(18,5),Source.FinishedGoodsGoodsForResale)
                               ,Target.GovernmentGrantIncome=try_convert(decimal(18,5),Source.GovernmentGrantIncome)
                               ,Target.ValueaddedTaxPayable=try_convert(decimal(18,5),Source.ValueaddedTaxPayable)
							   ,Target.AsDm_UpdatedDateTime=getdate()
               WHEN NOT MATCHED BY TARGET 
               THEN INSERT (			   
			   [CompanyNumber]
	           ,[Equity]   
			   ,CurrentAssets
			   ,DirectorRemuneration
			   ,EmployeesTotal
			   ,GrossProfitLoss
			   ,IntangibleAssets
			   ,NetAssetsLiabilities
			   ,OperatingProfitLoss
			   ,ProfitLoss
			   ,ProfitLossOnOrdinaryActivitiesAfterTax
			   ,ProfitLossOnOrdinaryActivitiesBeforeTax
			   ,TotalAssetsLessCurrentLiabilities
			   ,TotalLiabilities
			   ,TurnoverRevenue
			   ,WagesSalaries
			   ,AmountSpecificBankLoan
			   ,BankBorrowings
			   ,Creditors
			   ,DeferredTaxLiabilities
			   ,FinishedGoodsGoodsForResale
			   ,GovernmentGrantIncome
			   ,[ValueaddedTaxPayable]
               ,SourceFileName
                ) 
       VALUES (
	           source.CompanyNumber
	           ,try_convert(decimal(18,5),source.Equity)
	           ,try_convert(decimal(18,5),source.CurrentAssets)
	           ,try_convert(decimal(18,5),source.DirectorRemuneration)
	           ,try_convert(decimal(18,5),source.EmployeesTotal)
	           ,try_convert(decimal(18,5),source.GrossProfitLoss)
	           ,try_convert(decimal(18,5),source.IntangibleAssets)
	           ,try_convert(decimal(18,5),source.NetAssetsLiabilities)
	           ,try_convert(decimal(18,5),source.OperatingProfitLoss)
	           ,try_convert(decimal(18,5),source.ProfitLoss)
	           ,try_convert(decimal(18,5),source.ProfitLossOnOrdinaryActivitiesAfterTax)
	           ,try_convert(decimal(18,5),source.ProfitLossOnOrdinaryActivitiesBeforeTax)
	           ,try_convert(decimal(18,5),source.TotalAssetsLessCurrentLiabilities)
	           ,try_convert(decimal(18,5),source.TotalLiabilities)
	           ,try_convert(decimal(18,5),source.TurnoverRevenue)
	           ,try_convert(decimal(18,5),source.WagesSalaries)
	           ,try_convert(decimal(18,5),source.AmountSpecificBankLoan)
	           ,try_convert(decimal(18,5),source.BankBorrowings)
	           ,try_convert(decimal(18,5),source.Creditors)
	           ,try_convert(decimal(18,5),source.DeferredTaxLiabilities)
	           ,try_convert(decimal(18,5),source.FinishedGoodsGoodsForResale)
	           ,try_convert(decimal(18,5),source.GovernmentGrantIncome)
	           ,try_convert(decimal(18,5),source.ValueaddedTaxPayable)
			   ,source.SourceFileName
              );


/* Insert Rejected Records to Staging Rejected Records */

			  INSERT INTO Stg.Cmphs_StgBlobRejectedRecords
			  ([CompanyNumber]
	           ,[Equity]   
			   ,CurrentAssets
			   ,DirectorRemuneration
			   ,EmployeesTotal
			   ,GrossProfitLoss
			   ,IntangibleAssets
			   ,NetAssetsLiabilities
			   ,OperatingProfitLoss
			   ,ProfitLoss
			   ,ProfitLossOnOrdinaryActivitiesAfterTax
			   ,ProfitLossOnOrdinaryActivitiesBeforeTax
			   ,TotalAssetsLessCurrentLiabilities
			   ,TotalLiabilities
			   ,TurnoverRevenue
			   ,WagesSalaries
			   ,AmountSpecificBankLoan
			   ,BankBorrowings
			   ,Creditors
			   ,DeferredTaxLiabilities
			   ,FinishedGoodsGoodsForResale
			   ,GovernmentGrantIncome
			   ,[ValueaddedTaxPayable]
  			   ,SourceFileName
			   ,RunId)
			   SELECT 
			   [CompanyNumber]
	           ,[Equity]   
			   ,CurrentAssets
			   ,DirectorRemuneration
			   ,EmployeesTotal
			   ,GrossProfitLoss
			   ,IntangibleAssets
			   ,NetAssetsLiabilities
			   ,OperatingProfitLoss
			   ,ProfitLoss
			   ,ProfitLossOnOrdinaryActivitiesAfterTax
			   ,ProfitLossOnOrdinaryActivitiesBeforeTax
			   ,TotalAssetsLessCurrentLiabilities
			   ,TotalLiabilities
			   ,TurnoverRevenue
			   ,WagesSalaries
			   ,AmountSpecificBankLoan
			   ,BankBorrowings
			   ,Creditors
			   ,DeferredTaxLiabilities
			   ,FinishedGoodsGoodsForResale
			   ,GovernmentGrantIncome
			   ,[ValueaddedTaxPayable]
			   ,SourceFileName
			   ,@RunId
			   FROM #StgCHData SCD
			  WHERE NOT EXISTS (SELECT 1 FROM ASData_PL.Cmphs_CompaniesHouseDataFromBlob CDFB
			                 WHERE CDFB.SourceFileName=SCD.SourceFileName
				     		   AND CDFB.CompanyNumber=SCD.CompanyNumber
							   AND (TRY_CONVERT(nvarchar(255),CDFB.Equity)<>TRY_CONVERT(nvarchar(255),SCD.Equity)
							   or TRY_CONVERT(nvarchar(255),CDFB.CurrentAssets)<>TRY_CONVERT(nvarchar(255),SCD.CurrentAssets)
                               or TRY_CONVERT(nvarchar(255),CDFB.DirectorRemuneration)<>TRY_CONVERT(nvarchar(255),SCD.DirectorRemuneration)
                               or TRY_CONVERT(nvarchar(255),CDFB.EmployeesTotal)<>TRY_CONVERT(nvarchar(255),SCD.EmployeesTotal)
                               or TRY_CONVERT(nvarchar(255),CDFB.GrossProfitLoss)<>TRY_CONVERT(nvarchar(255),SCD.GrossProfitLoss)
                               or TRY_CONVERT(nvarchar(255),CDFB.IntangibleAssets)<>TRY_CONVERT(nvarchar(255),SCD.IntangibleAssets)
                               or TRY_CONVERT(nvarchar(255),CDFB.NetAssetsLiabilities)<>TRY_CONVERT(nvarchar(255),SCD.NetAssetsLiabilities)
                               or TRY_CONVERT(nvarchar(255),CDFB.OperatingProfitLoss)<>TRY_CONVERT(nvarchar(255),SCD.OperatingProfitLoss)
                               or TRY_CONVERT(nvarchar(255),CDFB.ProfitLoss)<>TRY_CONVERT(nvarchar(255),SCD.ProfitLoss)
                               or TRY_CONVERT(nvarchar(255),CDFB.ProfitLossOnOrdinaryActivitiesAfterTax)<>TRY_CONVERT(nvarchar(255),SCD.ProfitLossOnOrdinaryActivitiesAfterTax)
                               or TRY_CONVERT(nvarchar(255),CDFB.ProfitLossOnOrdinaryActivitiesBeforeTax)<>TRY_CONVERT(nvarchar(255),SCD.ProfitLossOnOrdinaryActivitiesBeforeTax)
                               or TRY_CONVERT(nvarchar(255),CDFB.TotalAssetsLessCurrentLiabilities)<>TRY_CONVERT(nvarchar(255),SCD.TotalAssetsLessCurrentLiabilities)
                               or TRY_CONVERT(nvarchar(255),CDFB.TotalLiabilities)<>TRY_CONVERT(nvarchar(255),SCD.TotalLiabilities)
                               or TRY_CONVERT(nvarchar(255),CDFB.TurnoverRevenue)<>TRY_CONVERT(nvarchar(255),SCD.TurnoverRevenue)
                               or TRY_CONVERT(nvarchar(255),CDFB.WagesSalaries)<>TRY_CONVERT(nvarchar(255),SCD.WagesSalaries)
                               or TRY_CONVERT(nvarchar(255),CDFB.AmountSpecificBankLoan)<>TRY_CONVERT(nvarchar(255),SCD.AmountSpecificBankLoan)
                               or TRY_CONVERT(nvarchar(255),CDFB.BankBorrowings)<>TRY_CONVERT(nvarchar(255),SCD.BankBorrowings)
                               or TRY_CONVERT(nvarchar(255),CDFB.Creditors)<>TRY_CONVERT(nvarchar(255),SCD.Creditors)
                               or TRY_CONVERT(nvarchar(255),CDFB.DeferredTaxLiabilities)<>TRY_CONVERT(nvarchar(255),SCD.DeferredTaxLiabilities)
                               or TRY_CONVERT(nvarchar(255),CDFB.FinishedGoodsGoodsForResale)<>TRY_CONVERT(nvarchar(255),SCD.FinishedGoodsGoodsForResale)
                               or TRY_CONVERT(nvarchar(255),CDFB.GovernmentGrantIncome)<>TRY_CONVERT(nvarchar(255),SCD.GovernmentGrantIncome)
                               or TRY_CONVERT(nvarchar(255),CDFB.[ValueaddedTaxPayable])<>TRY_CONVERT(nvarchar(255),SCD.[ValueaddedTaxPayable])
							   )
							   
							   )

				

				
				

				/* Drop Staging Table if PL is successful */

				--IF  EXISTS (select * from INFORMATION_SCHEMA.TABLES  where table_name ='CmphsDataFromBlob' AND TABLE_SCHEMA='Stg' AND TABLE_TYPE='BASE TABLE')
				--DROP TABLE [Stg].[CmphsDataFromBlob]


				UPDATE Mgmt.Log_Execution_Results
				   SET Execution_Status=1
					  ,EndDateTime=getdate()
					  ,FullJobStatus='Finish'
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
				'ImportCmphsFromStgBlobToPL',
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